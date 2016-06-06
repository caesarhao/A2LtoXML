#!/usr/bin/env perl
# use local defined library.
use lib qw(./lib/);
use A2L;
use strict;
use warnings;

print "Please drag in the input a2l file:";
my $ifile = <STDIN>;
$ifile =~ s///g;
chomp $ifile;
my $a2l = new A2L($ifile);
print "\nA2L version: ", $a2l->get_version(), "\n";
$a2l->outputXML();

