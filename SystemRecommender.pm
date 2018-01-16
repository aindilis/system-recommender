package SystemRecommender;

# ("created-by" "PPI-Convert-Script-To-Module")
# this is a system to recommend results

use BOSS::Config;
use Data::Dumper;
use KBFS::Cache;
use Manager::Dialog qw(Approve ChooseByProcessor SubsetSelect QueryUser);
use MyFRDCSA qw(ConcatDir Dir);
use PerlLib::Collection;
use PerlLib::HTMLConverter;
use PerlLib::MySQL;
use PerlLib::SwissArmyKnife;
use PerlLib::ToText;
use PerlLib::UI;
use SystemRecommender::Mapping;

use IO::File;
use Parse::Debian::Packages;
use Text::Wrap;
use YAML;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Conf MyConfig CurrentSystem DocRatings Docs IDF iOrder iTokens
	MainMenu Purposes Scoring SelectedPurposes Specification
	StartingWeight StorageMethod StorageFile TermRatings TF TFIDF
	Tokens MyCache MyConverter Order SystemData /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Specification("
	-m			Use barely any systems
	-a			Use all systems

	-s <file>		Purpose file
	--np			Don't save/load purposes (used when running -u often)

	-u [<host> <port>]	Run as a UniLang agent
");
  $UNIVERSAL::systemdir = ConcatDir(Dir("minor codebases"),"system-recommender");
  $self->MyConfig
    (BOSS::Config->new
     (Spec => $self->Specification,
      ConfFile => ""));

  $self->Conf($self->MyConfig->CLIConfig);
  if (exists $self->Conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $self->Conf->{-u}->{'<host>'} ?
       $self->Conf->{-u}->{'<host>'} : "localhost",
       Port => defined $self->Conf->{-u}->{'<port>'} ?
       $self->Conf->{-u}->{'<port>'} : "9000");
  }
  if ($self->Conf->{'--np'}) {
    $self->StorageMethod("none");
  } else {
    $self->StorageMethod("file");
    $self->StorageFile($self->Conf->{'-s'} || "data/input/purposes.pl");
  }
  $self->StartingWeight(10);
  $self->CurrentSystem("");
  $self->Order([]);
  $self->iOrder({});
  $self->Docs({});
  $self->DocRatings({});
  $self->TermRatings({});
  $self->Scoring({});

  $self->Purposes
    (PerlLib::Collection->new
     (
      Type => "String",
      StorageMethod => $self->StorageMethod,
      StorageFile => $self->StorageFile,
     ));
  $self->Purposes->Load;

  $self->SelectedPurposes({});
  $self->Tokens({});
  $self->iTokens({});
  $self->TF({});
  $self->IDF({});
  $self->TFIDF({});

  $self->MainMenu
    (PerlLib::UI->new
     (Menu => [
	       "Main Menu", [
			     "Purposes",
			     "Purposes",

			     "Navigation",
			     "Navigation",

			     "Rate system",
			     sub {$self->RateCurrentSystem()},

			     "Reorder",
			     sub {$self->Reorder()},

			     "Queue system",
			     sub {$self->QueueSystem()},

			     "Show scores for system",
			     sub {$self->ShowScoresForSystem()},

			     "Show tokens for purpose",
			     sub {$self->ShowTokensForPurpose()},

			     "Generate Top Systems",
			     sub {$self->GenerateTopSystems()},
			    ],
	       "Purposes", [
			    "Select purposes",
			    sub {$self->SelectPurposes()},

			    "Add purpose",
			    sub {$self->AddPurpose()},

			    "Remove purposes",
			    sub {$self->RemovePurposes()},
			   ],
	       "Navigation", [
			      "First system",
			      sub {$self->FirstSystem()},

			      "Previous page",
			      sub {$self->PreviousPage()},

			      "Previous system",
			      sub {$self->PreviousSystem()},

			      "Jump to system",
			      sub {$self->JumpToSystem()},

			      "Next system",
			      sub {$self->NextSystem()},

			      "Next page",
			      sub {$self->NextPage()},

			      "Last system",
			      sub {$self->LastSystem()},
			     ],
	      ],
      CurrentMenu => "Main Menu"));
}

sub Execute {
  my ($self,%args) = @_;
  $self->Initialize(Method => 'CSO2');
  $self->RebuildTermRatings();
  $self->Reorder();
  $self->CurrentSystem($self->Order->[0]);
  if (exists $self->Conf->{'-u'}) {
    print "Running as unilang agent, entering in to a listening loop\n";
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  } else {
    $self->MainMenu->Hooks->{Refresh} = sub {$self->DisplayContext()};
    $self->MainMenu->BeginEventLoop;
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub Initialize {
  my ($self,%args) = @_;
  $self->SelectedPurposes->{$self->Purposes->GetSortedValues->[0]} = 1 if ! $self->Purposes->IsEmpty;

  if ($args{Method} eq 'CSO2') {
    print "Loading the cso2 data\n";
    my $mysql = PerlLib::MySQL->new
      (DBName => "cso_flossmole");
    # load results from database for use in learning
    my $statement;
    if (exists $self->Conf->{'-a'}) {
      die "-a method is not supported for CSO2 currently, as it is implied by default\n";
    } else {
      my $res1 = $mysql->Do(Statement => 'show tables', Array => 1);
      my $tables = {};
      foreach my $array (@$res1) {
	$tables->{$array->[0]} = 1;
      }
      # Skipping Debian Metrics
      # Skipping Sourceforge
      # Skipping Github
      my $mappings = $SystemRecommender::Mapping::mappings;
      my @union;
      my $j = 1;
      foreach my $sourceabbrev (sort {$mappings->{$a}->{SourceName} cmp $mappings->{$a}->{SourceName}} keys %$mappings) {
	my $source = $mappings->{$sourceabbrev};
	my $sourcename = $source->{SourceName};
	if ($source->{KeyName}) {
	  @keynames = ($source->{KeyName});
	} elsif ($source->{KeyNames}) {
	  @keynames = sort values %{$source->{KeyNames}};
	  foreach my $key (keys %{$source->{KeyNames}}) {
	    $iSourceKeyNames->{$source->{KeyNames}{$key}} = $key;
	  }
	}
	my (@select,@from,@where) = ((),(),());
	my $i = 1;
	my $allfail = 1;
	foreach my $key (qw(ShortName LongName ShortDesc LongDesc)) {
	  my $fail = 1;
	  if (exists $source->{$key}) {
	    my $table_record = $source->{$key};
	    my ($table, $record) = split /\./, $table_record;
	    if (exists $tables->{$table}) {
	      $fail = 0;
	      $allfail = 0;
	      push @select, 's_'.$j.'_'.$i.'.'.$record.' as '.$key;
	      if ($i > 1) {
		if (scalar @keynames == 1) {
		  foreach my $keyname (@keynames) {
		    push @where, 's_'.$j.'_1.'.$keyname.' = s_'.$j.'_'.$i.'.'.$keyname;
		  }
		}
	      }
	      my $var = 's_'.$j.'_'.$i;
	      push @from, $table.' '.$var;
	      $tables->{$table} = $var;
	      ++$i;
	    }
	  }
	  if ($fail) {
	    push @select, 'NULL as '.$key;
	  }

	  # select concat("Rubyforge::",s1.proj_unixname) as key_name
	  # "Rubyforge" as source_name, s1.proj_unixname as name
	  # s2.description as short_desc 
	  # from rf_projects s1, rf_project_description s2 where s1.proj_unixname = s2.proj_unixname;
	}
	if (scalar @keynames == 1) {
	  push @select, 'concat("'.$sourcename.'::",'.
	    join(',"::",', map {'s_'.$j.'_1.'.$_} @keynames).') as key_name';
	} else {
	  my @list;
	  foreach my $keyname (@keynames) {
	    if (exists $tables->{$iSourceKeyNames->{$keyname}}) {
	      push @list, $tables->{$iSourceKeyNames->{$keyname}}.".$keyname";
	    } else {
	      my $it = 's_'.$j.'_'.$i++.'.'.$keyname.' as '.$iSourceKeyNames->{$keyname};
	      push @select, $it;
	      push @list, $it.".$keyname";
	    }
	  }
	  push @select, 'concat("'.$sourcename.'::",'.join(',"::",',@list).') as key_name';
	}
	push @select, '"'.$sourcename.'" as source_name';

	print Dumper([
		      \@select,
		      \@from,
		      \@where,
		     ]) if 0;
	if (! $allfail) {
	  my $prelim_sql = 'select '.join(', ', @select).' from '.join(', ',@from);
	  if (@where) {
	    $prelim_sql .= ' where '.join(' and ',@where);
	  }
	  push @union, $prelim_sql;
	  ++$j;
	} else {
	  print "Skipping $sourcename\n";
	}
      }
      my @temp;
      if (exists $self->Conf->{'-m'}) {
	@temp = map {"$_ limit 1000"} @union;
      } else {
	@temp = @union;
      }
      my $sql = join(' UNION ', @temp).";";
      print "$sql\n";

      my $res = $mysql->Do
	(
	 Statement => $sql,
	 Debug => 1,
	 KeyField => 'key_name',
	);

      $self->SystemData($res);
      foreach my $key (keys %$res) {
	my $name = $res->{$key}->{key_name};
	my @content;
	push @content, 'sn: '.$res->{$key}->{ShortName} if defined $res->{$key}->{ShortName};
	push @content, 'ln: '.$res->{$key}->{LongName} if defined $res->{$key}->{LongName};
	push @content, 'sd: '.$res->{$key}->{ShortDesc} if defined $res->{$key}->{ShortDesc};
	push @content, 'ld: '.$res->{$key}->{LongDesc} if defined $res->{$key}->{LongDesc};
	if (@content) {
	  $self->Docs->{$name} = {
				  ID => $name,
				  Contents => join("\n",@content),
				 };
	}
      }
    }
  } elsif ($args{Method} eq 'CSO') {
    print "Loading the cso data\n";
    my $mysql = PerlLib::MySQL->new
      (DBName => "cso");
    # load results from database for use in learning
    my $statement;
    if (exists $self->Conf->{'-a'}) {
      $statement = "select * from systems";
    } elsif (exists $self->Conf->{'-m'}) {
      $statement = "select * from systems limit 300",
    } else {
      $statement = "select * from systems where Source='AptCache'",
    }
    my $docs2 = $mysql->Do
      (Statement => $statement,
       KeyField => "ID");

    foreach my $key (keys %$docs2) {
      my $name = $docs2->{$key}->{Name}."#".$docs2->{$key}->{ID};
      my @content;
      push @content, $docs2->{$key}->{ShortDesc} if defined $docs2->{$key}->{ShortDesc};
      push @content, $docs2->{$key}->{LongDesc} if defined $docs2->{$key}->{LongDesc};
      if (@content) {
	$self->Docs->{$name} = {
				ID => $name,
				Contents => join(" ",@content),
			       };
      }
    }
  } elsif ($args{Method} eq 'apt-cache') {
    my $results = `apt-cache search -f .`;
    foreach my $entry (split /\n\n/, $results) {
      # print Dumper({$entry => $entry});
      my ($id,$contents);
      if ($entry =~ /^Package: (.+?)$/sm) {
	$id = $1;
      }
      if ($entry =~ /Description(-en)?: (.*?)\n(.*)(^\S+:)?/sm) {
	$contents = "$2\n$3";
      }
      if ($contents) {
	$self->Docs->{$id} = {
			      ID => $id,
			      Contents => $contents,
			     };
      }
    }
  }
  print Dumper({Keys => scalar keys %{$self->Docs}});

  print "Getting tokens\n";
  # now compute tfidf
  foreach my $doc (keys %{$self->Docs}) {
    foreach my $token ($self->GetTokens(Contents => $self->Docs->{$doc}->{Contents})) {
      $self->Tokens->{$token}->{$doc}++;
      $self->iTokens->{$doc}->{$token}++;
    }
  }
  print "Computing TFIDF\n";
  foreach my $token (keys %{$self->Tokens}) {
    my $numdocs = scalar keys %{$self->iTokens};
    my $numdocscontainingterm = scalar keys %{$self->Tokens->{$token}};
    # $idf->{$token} = log ($numdocs/$numdocscontainingterm);
    $self->IDF->{$token} = ($numdocs/$numdocscontainingterm);
    foreach my $doc (keys %{$self->Tokens->{$token}}) {
      my $length = scalar keys %{$self->iTokens->{$doc}};
      if ($length < 20) {
	$length = 20;
      }
      $self->TF->{$token}->{$doc} = $self->Tokens->{$token}->{$doc} / $length;
      $self->TFIDF->{$token}->{$doc} = $self->TF->{$token}->{$doc} * $self->IDF->{$token};
    }
  }
}

sub GetTokens {
  my ($self,%args) = @_;
  map {lc($_)} split /\W+/, $args{Contents};
}

sub Score {
  my ($self,%args) = @_;
  my $item = $args{Item};
  if (exists $self->Scoring->{$item}) {
    return $self->Scoring->{$item};
  }
  return 0;
}

sub Reorder {
  my ($self,%args) = @_;
  print "Reordering\n";
  print Dumper({SelectedPurposes => $self->SelectedPurposes});
  $self->Scoring({});
  foreach my $purpose (keys %{$self->SelectedPurposes}) {
    foreach my $token (keys %{$self->TermRatings->{$purpose}}) {
      print "<$token>\n" if 0;
      if (exists $self->IDF->{$token} and $self->IDF->{$token} > 100) {
	foreach my $doc (keys %{$self->Tokens->{$token}}) {
	  $self->Scoring->{$doc} += $self->TermRatings->{$purpose}->{$token} * $self->TFIDF->{$token}->{$doc};
	}
      }
    }
  }
  # sort by scoring of documents
  $self->Order([sort {$self->Score(Item => $b) <=> $self->Score(Item => $a)} keys %{$self->Docs}]);
  my $i = 0;
  foreach my $item (@{$self->Order}) {
    $self->iOrder->{$item} = $i++;
  }

  return
    {
     Success => 1,
     Result => $self->Scoring,
    };
}

sub SelectPurposes {
  my ($self,%args) = @_;
  if (exists $args{SelectedPurposes}) {
    my $existingpurposes = {};
    foreach my $key (keys %{$args{SelectedPurposes}}) {
      print "<Key: $key>\n";
      if ($self->Purposes->HasValue(Value => $key)) {
	$existingpurposes->{$key} = 1;
      } else {
	print "Purpose does not exists: <".$key.">\n";
      }
    }
    $self->SelectedPurposes($existingpurposes);
  } else {
    my $hash = {};
    print Dumper({Purposes => [$self->Purposes->GetSortedValues]});
    foreach my $entry (SubsetSelect
		       (Set => $self->Purposes->GetSortedValues,
			Selection => $self->SelectedPurposes)) {
      $hash->{$entry} = 1;
    }
    $self->SelectedPurposes($hash);
  }
  $self->RebuildTermRatings();
}

sub AddPurpose {
  my ($self,%args) = @_;
  print "1\n";
  my $newpurpose = $args{Purpose} || QueryUser("Purpose?");
  print "2\n";
  if (! $self->Purposes->HasValue(Value => $args{Purpose})) {
    print "2a\n";
    if (exists $args{Purpose} or Approve("Add this purpose?")) {
      print "2b\n";
      $self->Purposes->AddAutoIncrement
	(Item => $newpurpose);
      print "2c\n";
      $self->Purposes->Save;
      print "2d\n";
    }
  } else {
    print "3\n";
    print "This purpose already exists.\n";
  }
  print "4\n";
}

sub RemovePurposes {
  my ($self,%args) = @_;
  my $hash = {};
  $self->Purposes->SubtractByValue
    ($self->Purposes->SelectValuesByProcessor
     (Processor => sub {$_}));
  $self->Purposes->Save;
}

sub min {
  my ($a, $b) = @_;
  return $a if ($a < $b);
  $b;
}

sub max {
  my ($a, $b) = @_;
  return $a if ($a > $b);
  $b;
}

sub DisplaySystem {
  my ($self,%args) = @_;
  my $system = $args{System};
  my $score =  exists $self->Scoring->{$system} ? $self->Scoring->{$system} : "0";
  my $summary = $self->Docs->{$system}->{Contents};
  my $count;
  my $rating;
  foreach my $purpose (keys %{$self->SelectedPurposes}) {
    if (exists $self->DocRatings->{$purpose}->{$system}) {
      $rating += $self->DocRatings->{$purpose}->{$system};
      ++$count;
    }
  }
  if ($count) {
    $rating /= $count;
    $rating = sprintf("%1.1f",$rating);
  } else {
    $rating = "";
  }
  $summary =~ s/[\n\r]+/ /g;
  $summary =~ s/(.{80}).*/$1/;
  my $txt = $system;
  $txt =~ s/\s+//g;
  $txt =~ s/\#.*//;

  my $retval .= sprintf("%s %i %-15s %3.3f",$rating,$self->iOrder->{$system},$txt,$score);
  if ($_ eq $self->CurrentSystem) {
    my $txt = $self->Docs->{$self->CurrentSystem}->{Contents};
    $txt =~ s/[^[:alnum:]]/ /sg;
    $retval .= "\n".wrap("\t","\t", $txt);
  } else {
    $retval .= " ".sprintf("%80s",$summary);
  }
  return $retval;
}

sub RateCurrentSystem {
  my ($self,%args) = @_;
  # just jump to the next system for now
  my $rating = QueryUser("Rating for current system");
  if ($rating =~ /[\-\.\d]+/) {
    $self->AdjustRatings(Rating => $rating);
  }
  $self->NextSystem();
}

sub QueueSystem {
  my ($self,%args) = @_;
  print "Queue System: $currentsystem\n";
}

sub ShowScoresForSystem {
  my ($self,%args) = @_;
  print "Showing Scores for System: $currentsystem\n";
  # we want to show each word in the description and how much its worth to the total

  # okay the score for the system should be the sum of the values for
  # the terms in it, divided by length of the document

  # so what we want is to compute for each token, its score / length of the document

  # where are the contents of the current system
  foreach my $token ($self->GetTokens(Contents => $self->Docs->{$self->CurrentSystem}->{Contents})) {
    my $score = 0;
    foreach my $purpose (keys %{$self->SelectedPurposes}) {
      my $a = $self->TermRatings->{$purpose}->{$token};
      my $b = $self->TFIDF->{$token}->{$self->CurrentSystem};
      if ($a and $b) {
	# print "($a,$b)\n";
	$score +=  $a * $b;
      }
    }
    print "A $token\t\t$score\n";
  }
  print "\n\n";
}

sub ShowTokensForPurpose {
  my ($self,%args) = @_;
  print "Showing Tokens for Purposes\n";
  # we want to show and edit the top scores for tokens
  # just show for now

  foreach my $token ($self->GetTokens(Contents => $self->Docs->{$self->CurrentSystem}->{Contents})) {
    my $score = 0;
    foreach my $purpose (keys %{$self->SelectedPurposes}) {
      my $a = $self->TermRatings->{$purpose}->{$token};
      my $b = $self->TFIDF->{$token}->{$self->CurrentSystem};
      if ($a and $b) {
	# print "($a,$b)\n";
	$score +=  $a * $b;
      }
    }
    print "B $token\t\t$score\n";
  }
  print "\n\n";
}

sub DisplayContext {
  my ($self,%args) = @_;
  # skip for now
  # okay we want to do
  # take the 20 systems in the vicinity of the current
  $self->DisplayPurposes();

  my $window = 20;
  my $min;
  my $max;
  my $i = $self->iOrder->{$self->CurrentSystem};
  if ($i < $window / 2) {
    $min = 0;
    $max = $window;
  } elsif ($i > $self->IndexOfLastElementOfOrder - $window / 2) {
    $min = $self->IndexOfLastElementOfOrder - $window;
    $max = $self->IndexOfLastElementOfOrder;
  } else {
    $min = $i - $window / 2;
    $max = $i + $window / 2;
  }
  my @seq = $min .. $max;
  my @order = @{$self->Order};
  my @res = @order[@seq];
  foreach (@res) {
    print $self->DisplaySystem(System => $_)."\n";
  }
  print "\n";
}

sub DisplayPurposes {
  my ($self,%args) = @_;
  # print Dumper($selectedpurposes)."\n";
}

sub AdjustRatings {
  my ($self,%args) = @_;
  my $adjustment = $args{Rating};
  foreach my $purpose (keys %{$self->SelectedPurposes}) {
    $self->DocRatings->{$purpose}->{$self->CurrentSystem} = $adjustment;
  }
  # rebuild term ratings
  $self->RebuildTermRatings();
}

sub RebuildTermRatings {
  my ($self,%args) = @_;
  print "Rebuilding term ratings\n";
  $self->TermRatings({});
  foreach my $purpose (keys %{$self->SelectedPurposes}) {
    foreach my $system (keys %{$self->DocRatings->{$purpose}}) {
      foreach my $token ($self->GetTokens(Contents => $self->Docs->{$system}->{Contents})) {
	if (exists $self->IDF->{$token} and $self->IDF->{$token} > 100) {
	  $self->TermRatings->{$purpose}->{$token} = $self->DocRatings->{$purpose}->{$system};
	}
      }
    }
  }

  foreach my $purpose (@{$self->Purposes->GetSortedValues}) {
    # now retrieve the purpose correctly here
    my $text = $self->RetrieveTextForPurpose(Purpose => $purpose);
    print Dumper
      ({
	Purpose => $purpose,
	MyText => $text,
       }) if 0;
    foreach my $token ($self->GetTokens(Contents => $text)) {
      if (exists $self->IDF->{$token} and $self->IDF->{$token} > 100) {
	print "$token\t".$self->IDF->{$token}."\n";
	$self->TermRatings->{$purpose}->{$token} = $self->StartingWeight;
      }
    }
  }
}

sub RetrieveTextForPurpose {
  my ($self,%args) = @_;
  my $purpose = $args{Purpose};
  if ($purpose =~ /^file:\/\/(.*)$/) {
    $totext = PerlLib::ToText->new();
    my $res = $totext->ToText(File => $1);
    if ($res->{Success}) {
      return $res->{Text};
    }
    # return `cat "$1"`;
  } elsif ($purpose =~ /^http:\/\/.*$/) {
    # don't do anything for onw
    if (! defined $self->MyCache) {
      my $cachedir = "/tmp/system-recommender";
      if (! -d $cachedir) {
	system "mkdir -p ".shell_quote($cachedir);
      }
      $self->MyCache
	(KBFS::Cache->new
	 (
	  CacheDir => $cachedir,
	  CacheType => "web",
	 ));
      $self->MyConverter(PerlLib::HTMLConverter->new());
    }
    my $item = $self->MyCache->CacheNewItem(URI => $purpose);
    return $self->MyConverter->ConvertToTxt(Contents => $item->Contents);
  } else {
    return $purpose;
  }
}

sub NextPage {
  my ($self,%args) = @_;
  my $i = $self->iOrder->{$self->CurrentSystem};
  print "$i\n";
  if (exists $self->Order->[$i + 20]) {
    $self->CurrentSystem($self->Order->[$i + 20]);
  } else {
    print "Last Page\n";
  }
}

sub NextSystem {
  my ($self,%args) = @_;
  my $i = $self->iOrder->{$self->CurrentSystem};
  print "$i\n";
  if (exists $self->Order->[$i + 1]) {
    $self->CurrentSystem($self->Order->[$i + 1]);
  } else {
    print "Last System\n";
  }
}

sub PreviousSystem {
  my ($self,%args) = @_;
  my $i = $self->iOrder->{$self->CurrentSystem};
  print "$i\n";
  if (exists $self->Order->[$i - 1]) {
    $self->CurrentSystem($self->Order->[$i - 1]);
  } else {
    print "First System\n";
  }
}

sub PreviousPage {
  my ($self,%args) = @_;
  my $i = $self->iOrder->{$self->CurrentSystem};
  print "$i\n";
  if ($i > 0 and exists $self->Order->[$i - 20]) {
    $self->CurrentSystem($self->Order->[$i - 20]);
  } else {
    print "First Page\n";
  }
}

sub FirstSystem {
  my ($self,%args) = @_;
  $self->CurrentSystem($self->Order->[0]);
}

sub JumpToSystem {
  my ($self,%args) = @_;
  my $size = scalar @{$self->Order};
  my $int = QueryUser("Jump to which of $size systems");
  if ($int =~ /^\d+$/) {
    if ($int <= $self->IndexOfLastElementOfOrder and $int >= 0) {
      $self->CurrentSystem($self->Order->[$int]);
    } else {
      print "out of range\n";
    }
  } else {
    print "not a number\n";
  }
}

sub LastSystem {
  my ($self,%args) = @_;
  $self->CurrentSystem = $self->Order->[-1];
}

sub GenerateTopSystems {
  my ($self,%args) = @_;
}

sub IndexOfLastElementOfOrder {
  my ($self,%args) = @_;
  my $size = scalar @{$self->Order};
  return $size - 1;
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  print Dumper($m);		# UniLang::Util::Message

  # look at the data segment and send
  my $it = $m->Contents;
  if ($it =~ /^echo\s*(.*)/) {
    $UNIVERSAL::agent->SendContents
      (Contents => $1,
       Receiver => $m->{Sender});
  } elsif ($it =~ /^(quit|exit)$/i) {
    $UNIVERSAL::agent->Deregister;
    exit(0);
  }

  my $d = $m->Data;
  print Dumper($d);
  my $res;
  if (exists $d->{Command}) {
    if ($d->{Command} eq "Add Purpose" and exists $d->{Purpose}) {
      $self->AddPurpose
	(
	 Purpose => $d->{Purpose}
	);
    } elsif ($d->{Command} eq "Select Purposes" and exists $d->{SelectedPurposes}) {
      $self->SelectPurposes
	(
	 SelectedPurposes => $d->{SelectedPurposes}
	);
    } elsif ($d->{Command} eq "Get Scoring") {
      $res = $self->Reorder();
    } elsif ($d->{Command} eq "Get SystemData") {
      my $file = ConcatDir($UNIVERSAL::systemdir,'data','systemdata.dat');
      if (-f $file) {
	print "File <$file> already exists, skipping\n";
      } else {
	print "Writing <$file>\n";
	my $fh2 = IO::File->new();
	$fh2->open(">".$file);
	print $fh2 Dumper($self->SystemData);
	$fh2->close();
      }
      $res =
	{
	 Success => 1,
	 Result => {
		    File => $file,
		   },
	};

    }
  }
  # print Dumper({Res => $res});
  my $result = "";
  if (defined $res and $res->{Success}) {
    $result = $res->{Result}
  }
  $self->ReturnAnswer
    (
     # QueryAgentReply => 1,
     Result => {Result => $result},
     Message => $m,
    );
}

sub ReturnAnswer {
  my ($self,%args) = @_;
  $UNIVERSAL::agent->QueryAgentReply
    (
     Message => $args{Message},
     Data => {
	      _DoNotLog => 1,
	      Result => $args{Result}->{Result},
	     },
    );
}

1;
