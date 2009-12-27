#!/usr/bin/perl 

use strict;
use warnings;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

use WSDL::Compile::Serialize;

use Example::Op::CreateCustomer::Request;
use Example::Op::CreateCustomer::Response;
use Example::CT::Contact;

my $s              = WSDL::Compile::Serialize->new();
my $request_class  = 'Example::Op::CreateCustomer::Request';
my $response_class = 'Example::Op::CreateCustomer::Response';
my $contact_class  = 'Example::CT::Contact';

my $req = $request_class->new(
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


my $wsdl = XML::Compile::WSDL11->new('Example.wsdl');

my $call = $wsdl->compileClient('CreateCustomer');

# turn object into hashref
my $call_request = $s->for_xml( $req );

# at that point this example will fail as XML::Compile will try to connect to
# SOAP service.
my $answer = $call->( %$call_request );

# turn hashref into class args
my $res_args = $s->for_class( $response_class, $answer );

my $res = Example::Op::CreateCustomer::Response->new(
    %$res_args
);

