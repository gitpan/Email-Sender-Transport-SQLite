
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "deliver mail to an sqlite db for testing",
  "AUTHOR" => "Ricardo Signes <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Email-Sender-Transport-SQLite",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Email::Sender::Transport::SQLite",
  "PREREQ_PM" => {
    "DBD::SQLite" => "0",
    "DBI" => "0",
    "Email::Sender" => "0.091660",
    "Email::Sender::Transport" => "0",
    "Moo" => "0"
  },
  "TEST_REQUIRES" => {
    "Capture::Tiny" => "0",
    "File::Spec" => "0",
    "File::Temp" => "0",
    "Test::More" => "0.96",
    "blib" => "0",
    "strict" => "0",
    "warnings" => "0"
  },
  "VERSION" => "0.092002",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



