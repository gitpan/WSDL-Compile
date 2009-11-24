package WSDL::Compile::Meta::Attribute::WSDL;

=encoding utf-8

=head1 NAME

WSDL::Compile::Meta::Attribute::WSDL - metaclass for WSDL attributes 

=cut

use Moose;

our $VERSION = '0.01_1';

extends 'Moose::Meta::Attribute';

=head1 ATTRIBUTES

=head2 xs_minOccurs

xs:element attribute minOccurs. Defaults to 0

=cut

has 'xs_minOccurs' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
    predicate => 'has_xsminOccurs',
);

=head2 xs_maxOccurs

xs:element attribute maxOccurs. Defaults to undef (unbounded)

=cut

has 'xs_maxOccurs' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
    predicate => 'has_xsmaxOccurs',
);

=head2 xs_type

xs:element attribute type. Created based on attribute isa.
NOTE: Please use only if you know what you are doing.

=cut

has 'xs_type' => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_xstype',
);

=head2 xs_ref

xs:element attribute ref. Created based on attribute isa. Used by complex
types.
NOTE: Please use only if you know what you are doing.

=cut

has 'xs_ref' => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_xsref',
);

=head2 xs_name

xs:element attribute name. Created based on attribute name and isa.
NOTE: Please use only if you know what you are doing.

=cut

has 'xs_name' => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_xsname',
);

package Moose::Meta::Attribute::Custom::WSDL;
sub register_implementation {'WSDL::Compile::Meta::Attribute::WSDL'}


=head1 COPYRIGHT & LICENSE

Copyright 2009 Alex J. G. Burzyński.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WSDL::Compile::Meta::Attribute::WSDL
