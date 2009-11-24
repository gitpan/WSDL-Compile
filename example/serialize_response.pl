#!/usr/bin/perl 

use strict;
use warnings;

use WSDL::Compile::Serialize;
use Data::Dumper;
$Data::Dumper::Indent = 1;

use Example::Op::CreateCustomer::Request;
use Example::CT::Contact;


my $s             = WSDL::Compile::Serialize->new();
my $class         = 'Example::Op::CreateCustomer::Request';
my $contact_class = 'Example::CT::Contact';


my $res = $class->new(
    'TemplateCode' => 'example',
    'Contact'      => $contact_class->new(
        'Street' => 'example',
        'County' => 'example',
        'City'   => 'example'
    ),
    'CustomerID' => [ 'example', 'example' ],
    'Contacts'   => [
        $contact_class->new(
            'Street' => 'example',
            'County' => 'example',
            'City'   => undef
        ),
        $contact_class->new(
            'Street' => 'example',
            'County' => 'example',
            'City'   => 'example'
        ),
    ],
    'BuildingNumber' => undef,
    'CustomerType'   => ['example', undef, 'example2'],
);

my $opts = $s->for_xml( $res );
print Dumper($opts);
print "$class object turned into XML::Compile::SOAP::Client compatible args successfully\n";

