#!/usr/bin/perl 

# Copyright (c) 2011 Ákos Kovács <akoskovacs@gmx.com> Puli Compiler and Preprocessor
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


use strict;
use warnings;

my $VERSION = "v0.1-alpha";
my $bin_name = ();
my @source = ();
my $out_file = ();
my $wdir = `pwd`;
my $lnum = ();
my @header = (
    "#include <iostream>\n", 
    "#include <string>\n\n",
    "using namespace std;\n"
);

my %keywords = (
    'egész'      =>   'int',
    'karak'      =>   'char',
    'szöveg'     =>   'string',
    'egyesített' =>   'struct {',
    'unió'       =>   'union {',
    'kistört'    =>   'float',
    'tört'       =>   'double', 
    'semmi'      =>   'void',
    'vég'        =>   '}',
    'vissz'      =>   'return',
    'megáll'     =>   'break',
    'folytat'    =>   'continue',
    'ki'         =>   'cout',
    'be'         =>   'cin',
    'hiba'       =>   'cerr',
    'sorozat'    =>   'enum',
    'ref'        =>   '&',
    'akkor'      =>   ') {',
    'tedd'       =>   'do ',
    'ezt'        =>   '{',
    'bool'       =>   'unsgined char',
    'igaz'       =>   '1',
    'egyenlő'    =>   '==',
    'nagyobb'    =>   '>',
    'kisebb'     =>   '<',
    'hamis'      =>   '0',
    'ha'         =>   'if (',
    'amíg'       =>   'while (',
    'kezdet'     =>   'int main(int argc, char **argv) {',
    'addig'      =>   'for ('
);

print "Puli Compiler $VERSION\n" .
    "Copyright (C) Ákos Kovács - 2011\n\n";

if (not defined($ARGV[0])) {
        die "[HIBA]: Nincs fájl!\n";
}

$bin_name = $ARGV[0];
$bin_name =~ s/\.pu$//i;

foreach my $file (@ARGV) {
    if (!-e $file) {
        die "[HIBA]: A fájl nem található!\n";
    }
    $lnum = 1;
    &process_file($file);
}

sub process_file($) {
    my $file = shift;

    open(FILE, '<' . $file) or
        die "[HIBA]: Nem sikerült megynyitni fájlt: $!";

    @source = <FILE>;
    close (FILE);
    print " [F] $file\n";
    &replace_all();
    &generate_code($file);
    #print `g++ $out_file -o $wdir/$bin_name`;
}

sub replace_all {
    foreach my $line (@source) {
        foreach (keys %keywords) {
            if ($line =~ m/^\s*$/) {
                last;
            }
            $line =~ s/$_/$keywords{$_}/g;
        } # keys %keywords
        if ($line =~ m/fgv/) {
            &parse_func(\$line);
        }
        $lnum++;
    } # @source
}

sub parse_func($) {
    my $line_ref = shift;
    if ($$line_ref =~ m/->/) {
        if ($$line_ref =~ m/fgv\s+(\w+)\s*\((.*)\)\s*->\s*(\w+)/) {
            &create_function($line_ref, $3, $1, $2);
        }
    } elsif ($$line_ref =~ m/fgv\s+(\w+)\((.*)\)/){ 
        &create_function($line_ref, 'void', $1, $2);
    } else {
        die "[HIBA]: Rossz függvénymegadás, az $lnum. sorban!";
    }
}

sub create_function($$$) {
    my $line_ref = shift;
    my $ret_type = shift;
    my $fn_name = shift;
    my $params = shift;

    my $head = "$ret_type $fn_name($params)";
    push @header, $head . ";\n";
    
    $$line_ref = $head . " {\n";
}

sub generate_code($) {
    my $file = shift;
    $out_file = $file;
    $out_file =~ s/\.pu$/\.c++/i;
    $out_file = '/tmp/' . $out_file;
    
    unshift @source, @header;

    open(OUT, '>' . $out_file) or
        die "[HIBA]: Nem sikerült megynyitni fájlt: $!";
    
    print(OUT @source);
    
    close (OUT);
}
