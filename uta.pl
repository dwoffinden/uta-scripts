#!/usr/bin/perl

use strict;
use warnings;
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

  open(my $ssh, '-|', 'ssh -p 10022 labranch.doc.ic.ac.uk');

  system("git init $exercise");

  chdir "$exercise";

  my @remote_branches;

  while (<$ssh>) {
    if (m|git clone (ssh://.+?/lab/(.+?)/.+?/$exercise)|) {
      my $url = $1;
      my $tutee = $2;
      system("git remote add --fetch $tutee $url");
      push(@remote_branches, "$tutee/master");
    };
  }
  close($ssh);

  # find the root commit, checkout and create a master branch there
  # pretty terrible hack, pity the git in labs doesn't support --max-parents=0 :(
  system('git checkout -b master ' . `git rev-list --author=tora\@doc.ic.ac.uk @remote_branches`);
}

sub fetch {
  open(my $git, '-|', 'git remote');
  while (<$git>) {
    system("git fetch $_");
  }
  close($git);
}

given ($ARGV[0]) {
  when ('init') {
    if ($ARGV[1]) {
      init $ARGV[1];
    } else {
      usage;
    }
  }
  when ('fetch') {
    fetch;
  }
  default {
    usage;
  }
}
