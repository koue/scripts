#!/usr/bin/perl
use strict;
use MIME::Base64;

if ($#ARGV < 2)
{
        print(STDERR "Not enough parameters\n\n");
        print(STDERR "Usage:\n");
        print(STDERR "\t./send.pl e\@mail \"Subject\" file1 file2 ...\n");
        print(STDERR "\t./send.pl \"e\@mail,a\@ddress\" \"Subject\" file1 file2 ...\n\n");
        exit -1;
}

#Sendmail requires email addresses to be separated by comma AND space
my $to = $ARGV[0];
$to =~ s/,/, /g;

open STDOUT, "|/usr/sbin/sendmail -t";

my $boundary = "_----------=_10167391557129230";

print("Content-Transfer-Encoding: 7bit\n");
print("Content-Type: multipart/mixed; boundary=\"$boundary\"\n");
print("MIME-Version: 1.0\n");
print("Date: ".`date`);
print("To: $to\n");
print("Subject: $ARGV[1]\n\n");
print("Report: $ARGV[2]\n");

for (my $i = 2; $i <= $#ARGV; $i++)
{
        my $basename = `basename $ARGV[$i]`;
        $basename =~ s/\s//g;
        print("\n--".$boundary."\n");
        print("Content-Transfer-Encoding: base64\n");
        print("Content-Type: application/octet-stream; name=\"$basename\"\n\n");

        local $/=undef;
        open FILE, $ARGV[$i] or die "Couldn't open file $ARGV[$i]";
        binmode FILE;
        my $content = <FILE>;
        close FILE;

        print encode_base64($content)."\n\n";
}

print("--$boundary\n.\n");
