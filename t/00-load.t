#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'WSDL::Compile' );
}

diag( "Testing WSDL::Compile $WSDL::Compile::VERSION, Perl $], $^X" );

use_ok( 'WSDL::Compile::Utils' );
use_ok( 'WSDL::Compile::Serialize' );
