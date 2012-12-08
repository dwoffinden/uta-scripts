UTA-Scripts
===========

A Simple script to aid DoC UTAs by fetching an assignment and all student
branches from their repositories.

Usage
-----

* List all available repositories with `./uta.pl list`.

* Create and initialise a repository, and do an initial fetch with
  `./uta.pl init <repo-name>`. This will also try to create a `master` branch
  at the inital commit, and check it out.

* Fetch updates with `./uta.pl fetch`. Note that, as pushing is disabled when
  the deadline passes, you will never get updates pushed after that.


That's it! You can now see a see a students changes with
`git diff -R <student>/master`, checkout their code with
`git checkout <student>/master`, or compare submissions with
`git diff <student-a>/master <student-b>/master`.

Enjoy! Pull requests always welcome.
