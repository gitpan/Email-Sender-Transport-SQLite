package Email::Sender::Transport::SQLite;
our $VERSION = '0.091660';

use Moose;
with 'Email::Sender::Transport';
# ABSTRACT: deliver mail to an sqlite db for testing


use DBI;

has _dbh => (
  is       => 'rw',
  init_arg => undef,
);

has _dbh_pid => (
  is       => 'rw',
  init_arg => undef,
  default  => sub { $$ },
);

sub dbh {
  my ($self) = @_;

  ## no critic Punctuation
  my $existing_dbh = $self->_dbh;

  return $existing_dbh if $existing_dbh and $self->_dbh_pid == $$;

  my $must_setup = ! -e $self->db_file;
  my $dbh        = DBI->connect("dbi:SQLite:dbname=" . $self->db_file);

  $self->_dbh($dbh);
  $self->_dbh_pid($$);
  $self->_setup_dbh if $must_setup;

  return $dbh;
}

has db_file => (
  is      => 'ro',
  default => 'email.db',
);

sub _setup_dbh {
  my ($self) = @_;
  my $dbh = $self->_dbh;

  $dbh->do('
    CREATE TABLE emails (
      id INTEGER PRIMARY KEY,
      body varchar NOT NULL,
      env_from varchar NOT NULL
    );
  ');

  $dbh->do('
    CREATE TABLE recipients (
      id INTEGER PRIMARY KEY,
      email_id integer NOT NULL,
      env_to varchar NOT NULL
    );
  ');
}

sub send_email {
  my ($self, $email, $env) = @_;

  my $message = $email->as_string;
  my $to      = $env->{to};
  my $from    = $env->{from};

  my $dbh = $self->dbh;

  $dbh->do(
    "INSERT INTO emails (body, env_from) VALUES (?, ?)",
    undef,
    $message,
    $from,
  );

  my $id = $dbh->last_insert_id((undef) x 4);

  for my $addr (@$to) {
    $dbh->do(
      "INSERT INTO recipients (email_id, env_to) VALUES (?, ?)",
      undef,
      $id,
      $addr,
    );
  }

  return $self->success;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Email::Sender::Transport::SQLite - deliver mail to an sqlite db for testing

=head1 VERSION

version 0.091660

=head1 DESCRIPTION

This transport makes deliveries to an SQLite database, creating it if needed.
The SQLite transport is intended for testing programs that fork or that
otherwise can't use the Test transport.  It is not meant for robust, long-term
storage of mail.

The database will be created in the file named by the C<db_file> attribute,
which defaults to F<email.db>.

The database will have two tables:

  CREATE TABLE emails (
    id INTEGER PRIMARY KEY,
    body     varchar NOT NULL,
    env_from varchar NOT NULL
  );

  CREATE TABLE recipients (
    id INTEGER PRIMARY KEY,
    email_id integer NOT NULL,
    env_to   varchar NOT NULL
  );

Each delivery will insert one row to the F<emails> table and one row per
recipient to the F<recipients> table.

Delivery to this transport should never fail.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


