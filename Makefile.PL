
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Email-Sender-Transport-SQLite',
  NAME      => 'Email::Sender::Transport::SQLite',
  AUTHOR    => 'Ricardo\ Signes\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'deliver\ mail\ to\ an\ sqlite\ db\ for\ testing',
  VERSION   => '0.091660',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "DBD::SQLite" => '0',
    "Email::Sender" => '0.091660',
    "DBI" => '0',
  },
);
