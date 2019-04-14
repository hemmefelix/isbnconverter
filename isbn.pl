#! /usr/bin/perl
use strict;
use warnings;

# Autor: Felix Hemme
# Version: v1, 2019-04-14
# Lizenz: MIT License 
#
# *** BEGIN LICENSE BLOCK ***
# MIT License
# Copyright (c) [2019] [Felix Hemme]
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# *** END LICENSE BLOCK ***

# Dieses Programm liest ISBN-10 Nummern auf der Kommandozeile ein, validiert
# sie und konvertiert sie in die ISBN-13 Entsprechung.

# Valide ISBN-10 zum Testen 
# 3939260150
# 3778313061
# 3452291472
# 3800650193
# 3527509704
# 3746762715
# 3643141556
# 3430210097
# 3631545258
# 3939260169
# 353119917X

# Fehlerhafte ISBN-10 zum Testen
# 3-262-60047-7
# 3878313798

#Fehlermeldungen
my $HOW_TO = "Bitte geben Sie eine ISBN-10 ein:" . "\n";
my $ERROR_NOVALIDISBN = "Keine gültige ISBN-10 eingegeben.";
my $ERROR_CHECKDIGIT = "Keine gültige ISBN-10 eingegeben. Prüfziffer falsch.";
my $ERROR_EXIT = "Programm wird jetzt beendet.";

# Nutzer zur Eingabe auffordern
print $HOW_TO;

# ISBN-10 einlesen
my $isbn10 = <STDIN>;

# Möglichen Zeilenumbruch entfernen
chomp($isbn10);

# Mögliche Bindestriche entfernen
$isbn10 =~ s/-//g;

# ISBN-10 validieren
# Wirklich 10 Stellen?
if (length($isbn10) != 10) {
    print $ERROR_NOVALIDISBN . "\n" . $ERROR_EXIT . "\n";
    exit;
}

# ISBN-10 validieren, dafür wird ein Array erstellt
my @isbn10chars = split('',$isbn10);

# Prüfziffer X durch 10 ersetzen
# Suche nach x und X über Parameter i (case-insensitive)
$isbn10chars[9] =~ s/x/10/gi;

my $i = 0;
my $sum = 0;
for ($i = 0; $i < @isbn10chars; $i++) {
    $sum += (10-$i) * $isbn10chars[$i];
}

# Moduloberechnung über die Summe
# Wenn Prüfsumme ungleich 0, Programmabbruch
# Wenn Prüfsumme gleich 0, Meldung
if (($sum % 11) != 0) {
    print $ERROR_CHECKDIGIT . "\n" . $ERROR_EXIT . "\n";
    exit;
} elsif (($sum % 11) == 0) {
    print "ISBN-10 ist valide." . "\n";
}

# Aufaddieren des Ziffernvorspanns
my $pruefziffer = 9 + 3 * 7 + 8;

# Aufaddieren der ungeraden Stellen der ISBN
$i = 0;
while ($i < 9) {
    $pruefziffer = $pruefziffer + (3 * $isbn10chars[$i]);
    $i = $i + 2;
}

# Aufaddieren der geraden Stellen der ISBN
$i = 1;
while ($i < 9) {
    $pruefziffer = $pruefziffer + $isbn10chars[$i];
    $i = $i + 2;
}

# Berechnen der ISBN-13 Prüfziffer
$pruefziffer = 10 - ($pruefziffer % 10);

# Wenn Prüfziffer durch 10 teilbar ist, sei Prüfziffer == 0
if ($pruefziffer == 10) {
    $pruefziffer = 0;
}

# ISBN-13 concatenation mit Prefix 978, entfernen der ISBN-10-Prüfziffer
# und anfügen der berechneten ISBN-13-Prüfziffer
my $isbn13 = "978" . substr ($isbn10, 0, 9) . $pruefziffer;

# Ausgabe der ISBN-13
print "Die ISBN-10 " . $isbn10 . " entspricht dieser ISBN-13: " . $isbn13 . "\n";
