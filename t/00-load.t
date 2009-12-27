#!perl -T

use Test::More tests => 4;
use Test::NoWarnings;

BEGIN {
    use_ok( 'WSDL::Compile' );
}

diag( "Testing WSDL::Compile $WSDL::Compile::VERSION, Perl $], $^X" );

use_ok( 'WSDL::Compile::Utils' );
use_ok( 'WSDL::Compile::Serialize' );
