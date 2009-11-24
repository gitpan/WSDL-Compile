#!/usr/bin/perl 

use strict;
use warnings;

use WSDL::Compile::Serialize;
use Data::Dumper;
$Data::Dumper::Indent = 1;

my $s     = WSDL::Compile::Serialize->new();
my $class = 'Example::Op::CreateCustomer::Request';

my $opts = $s->for_class( $class, data() );
print Dumper($opts);

my $req = $class->new(%$opts);
print "$class object created successfully\n";

sub data {
    return { # sequence of TemplateCode, ArrayOfCustomerID,
    #   ArrayOfCustomerType, Title, Contact, ArrayOfContacts,
    #   BuildingNumber

    # is a {http://www.w3.org/2001/XMLSchema}string
    TemplateCode => "example",

    # occurs any number of times
    ArrayOfCustomerID =>
    [ { # sequence of CustomerID

        # is a {http://www.w3.org/2001/XMLSchema}string
        # is optional
        CustomerID => "example", }, ],

    # occurs any number of times
    ArrayOfCustomerType =>
    [ { # sequence of CustomerType

        # is a {http://www.w3.org/2001/XMLSchema}string
        # is optional
        CustomerType => "example", }, ],

    # is optional
    Contact =>
    { # sequence of Street, City, County

      # is a {http://www.w3.org/2001/XMLSchema}string
      # is optional
      Street => "example",

      # is a {http://www.w3.org/2001/XMLSchema}string
      # is optional
      City => "example",

      # is a {http://www.w3.org/2001/XMLSchema}string
      # is optional
      County => "example", },

    # occurs any number of times
    ArrayOfContacts =>
    [ { # sequence of Contacts

        # is optional
        Contacts =>
        { # sequence of Street, City, County

          # is a {http://www.w3.org/2001/XMLSchema}string
          # is optional
          Street => "example",

          # is a {http://www.w3.org/2001/XMLSchema}string
          # is optional
          City => "example",

          # is a {http://www.w3.org/2001/XMLSchema}string
          # is optional
          County => "example", }, }, ],

    # is a {http://www.w3.org/2001/XMLSchema}integer
    # is optional
    BuildingNumber => undef, };
}
