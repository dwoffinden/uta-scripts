#!/usr/bin/perl

use strict;
use warnings;
use feature 'switch';

sub list {
  open(my $ssh, '-|', 'ssh -p 10022 labranch.doc.ic.ac.uk 2>&1');
  while (<$ssh>) {
    if (m|git clone ssh://.+?(/lab/.+?/.+?/.+?$)|) {
      print $1, "\n";
    };
  }
  close($ssh);
}

sub usage {
  print <<END;
usage:
  $0 init EXERCISE
    create git repo EXERCISE, fetching all tutee branches

  $0 fetch
    fetch from all remotes for the current repo

  $0 list
    list available repos
END
}

sub fetch {
  system('git fetch --all');
}

sub init {
  open(my $ssh, '-|', 'ssh -p 10022 labranch.doc.ic.ac.uk 2>&1');

  my $exercise = shift;

  system("git init $exercise");

  chdir "$exercise";

  my @remote_branches;

  while (<$ssh>) {
    if (m|git clone (ssh://.+?/lab/(.+?)/.+?/$exercise)|) {
      my $url = $1;
      my $tutee = $2;
      system("git remote add $tutee $url");
      push(@remote_branches, "$tutee/master");
    };
  }
  close($ssh);

  fetch;

  # find the root commit, checkout and create a master branch there
  # pretty terrible hack, pity the git in labs doesn't support --max-parents=0 :(
  system('git checkout -b master ' . `git rev-list --author=tora\@doc.ic.ac.uk @remote_branches`);
}

given ($ARGV[0]) {
  when ('list') {
    list;
  }
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