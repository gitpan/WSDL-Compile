#!/bin/sh

perl -Ilib -Iexample/lib/ example/wsdl_generator.pl > example/Example.wsdl
perl -Ilib -Iexample/lib/ example/xml-compile-templates.pl example/Example.wsdl > example/wsdl.templates

