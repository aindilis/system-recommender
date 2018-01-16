#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

use Test::More tests => 1;

# start system implementor
# # do this manually for now
# "/var/lib/myfrdcsa/codebases/minor/system-recommender/system-recommender --np -m -u"

# now start the agent to connect to it

use_ok('UniLang::Util::TempAgent');

my $tempagent = UniLang::Util::TempAgent->new(Debug => 1);

# now add some purposes
my $purposes = {
		"semantic file system" => 1,
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
  diag($message1->Generate());
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
diag($message2->Generate());

my $message3 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "System-Recommender",
   Contents => "",
   Data => {
	    Command => "Get Scoring",
	   },
  );
diag(Dumper($message3->Generate()));

1;
