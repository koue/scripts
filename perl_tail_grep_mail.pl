#!/usr/bin/perl

use strict;
use warnings;
my @buffer;
# the size of the buffer which will collect the logs (in lines)
my $buffersize = 3;
my $line;
my $i;
my $subject;
my $send_to = $ARGV[0] or die "\nMail address is missing!\nExample: $0 good_bad_ugly\@chaosophia.net /var/log/secure\n\n";
my $LFILE = $ARGV[1] or die "\nLog file missing!\nExample: $0 good_bad_ugly\@chaosophia.net /var/log/secure\n\n";
my $MSG;
# regular expression about checking for errors
my $errors = "exception|error";
# don't report if the string contents following regular expression
my $escape = "escape string";

open my $pipe, "-|", "/usr/bin/tail", "-n1", "-F", $LFILE or die "could not start tail on $LFILE: $!";

while (<$pipe>) {
	# put every single line into @buffer;
        push(@buffer, $_);
	# keep the size of the @buffer;
        while(scalar(@buffer) > $buffersize) {
                shift(@buffer);
        }
	# check log lines for the given regular expressions;
        if (m/$errors/i && !m/$escape/) {
		$subject = $&;
                $line = $_;
                my $DT = `date +H-S`;
                chomp($DT);
                $MSG = $DT." ".$LFILE."\n";
                foreach (@buffer) {
                        $MSG .= $_;
                }
                $MSG .= "--------------\n";

                open(SENDMAIL, "|/usr/sbin/sendmail -t") or die "Cannot open sendmail: $!";
                print SENDMAIL "Reply-to: alerts\@chaosophia.net\n";
                print SENDMAIL "Subject: $subject\n";
                print SENDMAIL "To: $send_to\n";
                print SENDMAIL "Content-type: text/plain\n\n";
                print SENDMAIL $MSG;
                close(SENDMAIL);
                $MSG = "";
        }
}
