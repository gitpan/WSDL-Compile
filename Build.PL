use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'WSDL::Compile',
    license           => 'perl',
    dist_author       => q{Alex J. G. Burzyński <ajgb@cpan.org>},
    dist_version_from => 'lib/WSDL/Compile.pm',
    build_requires    => {
        'Test::More'               => 0,
        'Moose'                    => '0.93',
        'Data::Dumper'             => 0,
        'MooseX::Types::XMLSchema' => 0,
        'Perl6::Junction'          => '1.40000',
        'XML::LibXML'              => '1.69',
        'XML::Compile::SOAP'       => '2.08',
    },
    add_to_cleanup     => ['WSDL-Compile-*'],
    create_makefile_pl => 'passthrough',
    create_readme      => 0, # Pod::Parser doesn't support =encoding
    create_licence     => 1,
);

$builder->create_build_script();
