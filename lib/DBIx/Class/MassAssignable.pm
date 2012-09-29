package DBIx::Class::MassAssignable;

use 5.010000;
use strict;
use warnings;
use base qw(DBIx::Class);
use Carp qw/croak carp/;

our $VERSION = '0.01';

__PACKAGE__->mk_group_accessors('inherited', qw/
        attr_accessible
        attr_protected
    /);

sub set_columns {
  my $self = shift;
  my $columns = shift;

  $self->_sanitize_mass_assignment($columns);

  return $self->next::method( $columns );
}

sub set_inflated_columns {
  my $self = shift;
  my $columns = shift;

  $self->_sanitize_mass_assignment($columns);

  return $self->next::method( $columns );
}


sub _sanitize_mass_assignment {
  my $self = shift;
  my $columns = shift;

  $self->_sanitize_attr_accessible($columns);
  $self->_sanitize_attr_protected($columns);
}

sub _sanitize_attr_accessible {
  my $self = shift;
  my $columns = shift;

  return unless defined $self->attr_accessible;
  croak "attr_accessible must be passed an array ref" unless ref($self->attr_accessible) eq "ARRAY";

  my %accessible = map { $_ => 1 } @{$self->attr_accessible} ;
  foreach my $key( keys %$columns ) {
    unless($accessible{$key}) {
      carp "Attempted to mass assign none whitelisted value $key";
      delete $columns->{$key} ;
    }
  }
  
}

sub _sanitize_attr_protected {
  my $self = shift;
  my $columns = shift;

  return unless defined $self->attr_protected;

  croak "attr_protected must be passed an array ref" unless ref($self->attr_accessible) eq "ARRAY";
  my %protected = map { $_ => 1 } @{$self->attr_protected};
  foreach my $key( keys %$columns ) {
    if($protected{$key}) {
      carp "Attempted to mass assign blacklisted value $key";
      delete $columns->{$key} ;
    }
  }
  
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::Class::MassAssignable - Perl extension for blah blah blah

=head1 SYNOPSIS

  use DBIx::Class::MassAssignable;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for DBIx::Class::MassAssignable, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Jonathan Taylor, E<lt>jon@localE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Jonathan Taylor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
