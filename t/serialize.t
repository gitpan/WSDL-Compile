
use strict;
use warnings;

use Test::More;
use Test::NoWarnings;
use Test::Exception;
use Test::Differences;

use Data::Dumper;
$Data::Dumper::Indent = 1;
use MooseX::Types::XMLSchema qw( :all );
use WSDL::Compile::Serialize;

use XML::Compile::SOAP11;
use XML::Compile::WSDL11;

use lib qw( example/lib );

use Example::Op::CreateCustomer::Request;
use Example::Op::CreateCustomer::Response;
use Example::CT::Contact;

BEGIN {
    use_ok "WSDL::Compile::Serialize";
}

my $s             = WSDL::Compile::Serialize->new();
my $req_class     = 'Example::Op::CreateCustomer::Request';
my $res_class     = 'Example::Op::CreateCustomer::Response';
my $contact_class = 'Example::CT::Contact';

my $wsdl_file = "example/Example.wsdl";
my $wsdl      = XML::Compile::WSDL11->new($wsdl_file);

my $req_template = $wsdl->template( 'PERL',
    '{http://localhost/Example}CreateCustomer'
);
my $res_template = $wsdl->template( 'PERL',
    '{http://localhost/Example}CreateCustomerResponse'
);

my $req = eval "$req_template";
my $res = eval "$res_template";

my ($req_obj, $res_obj);
my ($req_opts, $res_opts);

{
    package WSDL::Compile::Custom::Class::Name;
    use Moose;
    use WSDL::Compile::Meta::Attribute::WSDL;

    has 'regular_attr_1' => (
        is => 'rw',
        isa => 'Str',
    );
    has 'wsdl_attr_regular_isa_1' => (
        metaclass => 'WSDL',
        is => 'rw',
        isa => 'Str',
        xs_type => 'xs:string',
    );
    has 'regular_attr_2' => (
        is => 'rw',
        isa => 'Int',
    );
    has 'wsdl_attr_xs_isa_1' => (
        metaclass => 'WSDL',
        is => 'rw',
        isa => 'xs:string',
    );
    has 'wsdl_attr_xs_isa_2' => (
        metaclass => 'WSDL',
        is => 'rw',
        isa => 'ArrayRef[Maybe[xs:string]]',
        xs_minOccurs => 1,
        xs_maxOccurs => 2,
        required => 1,
    );

    no Moose;
}

diag "for_xml";
$req_obj = $req_class->new(
    Title        => 'example',
    TemplateCode => 'example',
    Contact      => $contact_class->new(
        Street => 'example',
        County => 'example',
        City   => 'example'
    ),
    CustomerID => ['example'],
    Contacts   => [
        $contact_class->new(
            Street => 'example',
            County => 'example',
            City   => 'example',
        ),
    ],
    BuildingNumber => 42,
    CustomerType   => ['example'],
);
lives_ok {
    $req_opts = $s->for_xml($req_obj);
} "Request serialized";
is_deeply $req_opts, $req, " request arguments created correctly";

$req_obj = $req_class->new(
    TemplateCode => 'example',
    CustomerID => ['example'],
    Contacts   => [
        $contact_class->new(
            Street => 'example',
            County => 'example',
            City   => 'example',
        ),
        $contact_class->new(
            Street => 'example',
            County => 'example',
            City   => undef,
        ),
    ],
    BuildingNumber => 42,
    CustomerType   => ['example'],
);
lives_ok {
    $req_opts = $s->for_xml($req_obj);
} "Request serialized with undefined values";


$res_obj = $res_class->new(
    CustomerID => ['example'],
);
lives_ok {
    $res_opts = $s->for_xml($res_obj);
} "Response could be serialized as Request as well";
$res_obj = WSDL::Compile::Custom::Class::Name->new(
    regular_attr_1 => 'example',
    wsdl_attr_regular_isa_1 => 'example',
    regular_attr_2 => 42,
    wsdl_attr_xs_isa_1 => 'example',
    wsdl_attr_xs_isa_2 => [ 'example', 'example' ],
);
lives_ok {
    $res_opts = $s->for_xml($res_obj);
} "Class name not matching namespace pattern";


diag "for_class";
lives_ok {
    $res_opts = $s->for_class( $res_class, $res );
} "Response serialized";
lives_ok {
    $res_obj = $res_class->new(%$res_opts);
} "response object created";
is $res_obj->CustomerID->[0],
  $res->{createcustomer}->{ArrayOfCustomerID}->[0]->{CustomerID},
  "...and created correctly";

my $req2 = { %$req };
lives_ok {
    $res_opts = $s->for_class( $req_class, $req2 );
} "Request class serialized as well";
lives_ok {
    $req_obj = $req_class->new(%$res_opts);
} "Request object created";

$req2 = { %$req };
delete $req2->{Title};
delete $req2->{Contact};
$req2->{BuildingNumber} = 'NIL';
lives_ok {
    $res_opts = $s->for_class( $req_class, $req2 );
} "Request class with null or missing values";
lives_ok {
    $req_obj = $req_class->new(%$res_opts);
} "Request object created";


done_testing( 14 );

