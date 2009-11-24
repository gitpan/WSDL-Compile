use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WSDL::Compile',
    AUTHOR              => q{Alex J. G. Burzyński <ajgb@cpan.org>},
    VERSION_FROM        => 'lib/WSDL/Compile.pm',
    ABSTRACT_FROM       => 'lib/WSDL/Compile.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Moose' => '0.93',
        'Data::Dumper' => 0,
        'MooseX::Types::XMLSchema' => 0,
        'Perl6::Junction' => '1.40000',
        'XML::LibXML' => '1.69',
        'XML::Compile::SOAP' => '2.08',
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WSDL-Compile-*' },
);
