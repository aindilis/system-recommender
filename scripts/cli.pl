#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

# start system implementor
# # do this manually for now
# "/var/lib/myfrdcsa/codebases/minor/system-recommender/system-recommender --np -m -u"

# now start the agent to connect to it


my $tempagent = UniLang::Util::TempAgent->new(Debug => 1);

print "Query?: ";
while (my $query = <STDIN>) {
  # now add some purposes
  my $purposes = {
		  $query => 1,
		 };

  foreach my $purpose (keys %$purposes) {
    my $message1 = $tempagent->MyAgent->QueryAgent
      (
       Receiver => "System-Recommender",
       Contents => "",
       Data => {
		Command => "Add Purpose",
		Purpose => $purpose,
	       },
      );
    print Dumper($message1->Generate()) if $debug;
  }

  my $message2 = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "System-Recommender",
     Contents => "",
     Data => {
	      Command => "Select Purposes",
	      SelectedPurposes => $purposes,
	     },
    );
  print Dumper($message2->Generate()) if $debug;

  my $message3 = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "System-Recommender",
     Contents => "",
     Data => {
	      Command => "Get Scoring",
	     },
    );
  print Dumper($message3->Generate()) if $debug;
  my $resulthash = $message3->Data->{Result};
  foreach my $key (sort {$resulthash->{$b} <=> $resulthash->{$a}} keys %$resulthash) {
    printf ("%5.5f %s\n",$resulthash->{$key}, $key);
  }
  print "\n\n";
  print "Query?: ";
}

1;
