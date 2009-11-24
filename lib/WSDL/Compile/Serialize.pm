package WSDL::Compile::Serialize;

=encoding utf-8

=head1 NAME

WSDL::Compile::Serialize - serialize to and from class for
L<XML::Compile::SOAP::Client>

=cut

use Moose;

our $VERSION = '0.01_1';

use MooseX::Params::Validate qw( pos_validated_list );
use WSDL::Compile::Utils qw( wsdl_attributes parse_attr load_class_for_meta );

=head1 ATTRIBUTES

=head2 namespace_pattern

Regexp pattern for the class names namespace.

=cut

has 'namespace_pattern' => (
    is => 'rw',
    isa => 'Regexp',
    default => sub { qr/^[\w:]+::Op::(\w+)::\w+$/ },
    lazy => 1,
);

=head1 FUNCTIONS

=head2 for_class

For given class name and hashref returned from SOAP call creates arguments
needed to instantiate that class.

=cut


sub for_class {
    my $self = shift;
    my ( $class_name, $data ) = pos_validated_list( \@_,
        { isa => 'Str' },
        { isa => 'HashRef' },
    );

    my $meta = load_class_for_meta( $class_name );

    if ( $meta->name =~ $self->namespace_pattern && $meta->name !~ /Request$/) {
        $data = $data->{lc $1};
    }

    my %args;
    for my $attr ( wsdl_attributes($meta) ) {
        my $attr_data = parse_attr( $attr );
        my $attr_name = $attr_data->{name} || $attr_data->{ref};
        if (my $ct = delete $attr_data->{complexType}) {
            if ( $ct->{type} eq 'Class' and $data->{ $attr_name } ) {
                my $class_name = $ct->{attr}->type_constraint->name;
                load_class_for_meta( $class_name );

                my $class_args = $self->for_class(
                    $class_name,
                    $data->{ $attr_name }
                );

                $args{ $attr_name } = $class_name->new( %$class_args);
            } elsif ( $ct->{type} eq 'ArrayRef' ) {
                if ( my $acmeta = $ct->{defined_in}->{class}) {
                    my $class_name = $ct->{attr}->type_constraint->type_parameter->class;
                    load_class_for_meta( $class_name );

                    for my $item ( @{ $data->{ $attr_name } } ) {
                        my $class_args = $self->for_class(
                            $class_name,
                            $item->{ $ct->{attr}->name }
                        );
                        push @{ $args{ $ct->{attr}->name } }, $class_name->new( %$class_args );
                    }
                } elsif ( $ct->{defined_in}->{types_xs} ) {
                    $args{ $ct->{attr}->name } = [
                        map { $_->{$ct->{attr}->name} }
                        @{ $data->{ $attr_name } }
                    ];
                }
            }
        } else {
            if ( $attr_data->{nillable} ) {
                $args{ $attr_name } = $data->{ $attr_name } && $data->{ $attr_name } eq 'NIL'
                    ? undef : $data->{ $attr_name };
            } elsif (exists $data->{ $attr_name }) {
                $args{ $attr_name } = $data->{ $attr_name };
            }
        };
    }

    return \%args;
}

=head2 for_xml

For class object creates arguments needed to pass to SOAP call.

=cut


sub for_xml {
    my $self = shift;
    my ( $obj ) = pos_validated_list( \@_,
        { isa => 'Object' },
    );
    my $meta = $obj->meta;

    my %args;
    for my $attr ( wsdl_attributes($meta) ) {
        my $attr_data = parse_attr( $attr );
        my $attr_name = $attr_data->{name} || $attr_data->{ref};
        my $obj_attr_name = $attr->name;
        if (my $ct = delete $attr_data->{complexType}) {
            if ( $ct->{type} eq 'Class') {
                my $class_args = $self->for_xml(
                    $obj->$obj_attr_name()
                ) if $obj->$obj_attr_name();

                $args{ $attr_name } = $class_args;
            } elsif ( $ct->{type} eq 'ArrayRef' ) {
                if ( my $acmeta = $ct->{defined_in}->{class}) {
                    for my $item ( @{ $obj->$obj_attr_name() } ) {
                        my $class_args = $self->for_xml(
                            $item
                        );

                        push @{ $args{ $attr_name } }, {
                            $obj_attr_name => $class_args,
                        };
                    }
                } elsif ( $ct->{defined_in}->{types_xs} ) {
                    my %opts = (
                        is => 'ro',
                        isa => $ct->{attr}->type_constraint->type_parameter->name,
                        required => $attr->is_required ? 1 : 0,
                    );
                    my $tmpattr = WSDL::Compile::Meta::Attribute::WSDL->new(
                        $ct->{attr}->name,
                        %opts
                    );
                    my $attr_data = parse_attr( $tmpattr );

                    $args{ $attr_name } = [
                        map {
                            {
                                $obj_attr_name => $_ 
                            }
                        }
                        map { $self->_nillable_attribute( $attr_data, $_ ) } @{ $obj->$obj_attr_name() }
                    ];
                }
            }
        } else {
            $args{ $attr_name } = $self->_nillable_attribute(
                $attr_data, $obj->$obj_attr_name()
            );
        };
    }

    if ( $meta->name =~ $self->namespace_pattern && $meta->name !~ /Request$/) {
        return { lc $1 => \%args };
    }
    return \%args;
}

sub _nillable_attribute {
    my $self = shift;
    my ( $data, $value ) = pos_validated_list( \@_,
        { isa => 'HashRef' },
        { isa => 'Item' },
    );

    if ( $data->{nillable} && ! defined $value ) {
        return 'NIL';
    }
    return $value;
}

=head1 COPYRIGHT & LICENSE

Copyright 2009 Alex J. G. Burzyński.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WSDL::Compile::Serialize
