#!/usr/bin/perl

# Convert source files to 1251 encoding and PDF

# Usage: perl topdf.pl result_filename [source html files]

use strict;

use Encode qw(from_to);


my $f = shift;

foreach my $file (@ARGV) {

my $text = load_file($file);

Encode::_utf8_on($text); 

$text =~ s/&\#(\d+);/chr($1)/ge; ## fix html characters after 127

Encode::_utf8_off($text);

from_to($text,'utf8','cp-1251'); ## encode

save_file($file,$text);

} 

## call htmldoc

system ("/usr/local/bin/htmldoc --webpage --embedfonts --charset cp-1251 -f $f @ARGV");


sub load_file {

my ($file) = @_;

open (F, "< $file") or die $!;

local $/ = undef;

<F>;

}

sub save_file {

my ($file,$text) = @_;

open (F, "> $file") or die $!;

local $/ = undef;

print F $text;

close(F);

}
