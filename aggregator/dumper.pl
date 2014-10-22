#!/usr/bin/perl
use XML::Simple;
my $config = XMLin('errata.xml');
use Data::Dumper;
print Dumper($config);
