#!/usr/bin/perl 

use strict;
use warnings;

use XML::Compile::SOAP11;
use XML::Compile::WSDL11;
use List::Util qw(first);

my $wsdl_file = $ARGV[0] or die "Usage: $0 /path/to/file.wsdl\n";

my $wsdl = XML::Compile::WSDL11->new( $wsdl_file );

my $prefixes = $wsdl->prefixes;
my $tns = first { $prefixes->{$_}->{prefix} eq 'tns' } keys %$prefixes;

print "\n** operations **\n";
print map $_->name ."\n", $wsdl->operations;
print "\n** elements **\n";
print map "$_\n", $wsdl->elements;

print "\n** templates for $tns **\n";
do {
    my $elem = $_;
    unless ($elem =~ /$tns/) {
        warn "skipping $elem...\n";
        next;
    }
    print "======================\n";
    print $elem, "\n";
    print "PERL\n";
    print $wsdl->template('PERL', $elem), "\n";
    print "XML\n";
    print $wsdl->template('XML', $elem), "\n";
    print "\n";
} for $wsdl->elements;

