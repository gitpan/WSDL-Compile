
use strict;
use warnings;

use Test::More;
use Test::NoWarnings;
use Test::Exception;
use Test::Differences;

use Data::Dumper;$Data::Dumper::Indent=1;

BEGIN {
    use_ok "WSDL::Compile::Meta::Attribute::WSDL";
};

{
    package WSDL::Compile::Example::Class;
    use Moose;

    has 'wsdl_attr_1' => (
        metaclass => 'WSDL',
        is => 'rw',
        isa => 'Str',
    );

    no Moose;
}

done_testing( 2 );

