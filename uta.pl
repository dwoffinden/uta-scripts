#!/usr/bin/perl -w

use strict;
use feature 'switch';

sub usage {
  print <<END;
usage:
  $0 init EXERCISE
    create git repo EXERCISE, fetching all tutee branches

  $0 fetch
    fetch from all remotes for the current repo
END
}

sub init {
  my $exercise = shift;

  open(SSH, 'ssh -p 10022 labranch.doc.ic.ac.uk |');

  system("git init $exercise");

  chdir "$exercise";

  while (my $line = <SSH>) {
    if ($line =~ m|git clone (ssh://.+?/lab/(.+?)/.+?/$exercise)|) {
      my $url = $1;
      my $tutee = $2;
      system("git remote add --fetch $tutee $url");
    };
  }

  system("git gc")
}

sub fetch {
  open(SSH, 'git remote |');

  while (my $remote = <SSH>) {
    system("git fetch $remote");
  }
}

given ($ARGV[0]) {
  when ("init") {
    if (defined($ARGV[1])) {
      init $ARGV[1];
    } else {
      usage; exit;
    }
  }
  when ("fetch") {
    fetch;
  }
  default {
    usage; exit;
  }
}
