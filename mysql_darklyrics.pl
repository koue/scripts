#!/usr/bin/perl
######################################################################
# Usage: perl lyrics.pl --artist=<artist name>
#
#       $perl lyrics.pl --artist=icedearth
#
#	2007 fetch lyrics from http://darklyrics.com
#
#	[long time not used probably need some update]
######################################################################

use HTTP::Lite;
use Getopt::Long;

sub usage {
        print "Usage: $0 --artist=<artist name>\n"; exit;
}

sub getContent {
	$database = "database";
	$found = 0;
	$open = 0;
	my $url = $_[0];
	$http->reset();
	my $req = $http->request("http://www.darklyrics.com/$url") or die("\nUnable to connect!");
	@lines = split(/\n/, $http->body());
        foreach (@lines) {
		$all = $_;
                if ( $_ =~ "size=3") {
                   $split1 = "<FONT size=3 color=white><b>";
                   $split2 = "FONT><br>";
		   $temp = $_;
                   $temp =~ s/$split1//i;
		   $temp =~ s/$split2//i;
                   $temp = substr($temp,0,length($temp)-12);

			$year = substr($temp,-4);

		   $name = substr($temp,0,length($temp)-6);
		   if ($year =~ /\d\d\d\d/) {
		   	$found = 1;
			print "$year $name\n";	
		   }
		}
		if ($found) {
			if (($open == 1) && ($all =~ m/^<FONT size=1/)) {
#debug

				print CONTENT "<badrock>\");\n";
				$open = 0;
			        close(CONTENT);
			}
#debug
			if (($open == 0) && ($all =~ m/<FONT size=3 color=white/)) {
#			if (($open == 0) && ($all =~ m/^<a name=/)) {
#debug
				$open = 1;
				$file_content = "$year $name";
				open(CONTENT,">>$database") || die("Cannot Open File!\n");
				print CONTENT "INSERT INTO album VALUES (\"\",\"$year\",\"<badrock>$name<badrock>\",\"<badrock>";
				
			}
			if ($open) {
#debug
#$all =~ s/<FONT size=1 color=#FFFFCC><\/FONT><BR><BR><BR>//;

				$all = substr($all,0,length($all)-1);
				print CONTENT "$all";
			}
		}
        }
}

GetOptions("artist=s" => \$artist);
if (!$artist) {
        usage();
}
$http = new HTTP::Lite;
process();

sub process {
	$before = "blqblqblq";
        @artist_arr = split(//,$artist);
	$artist = lc($artist);
	@artist_array = split(' ',$artist);
	$char = substr($artist,0,1);
        $req = $http->request("http://www.darklyrics.com/$char/$artist.html") or die("\nUnable to connect!");
	@lines = split(/\n/,$http->body());
        foreach (@lines) {
            if ($_ =~ "../lyrics/") {
		@tmp = split(' ', $_);
		$link = substr($tmp[1],9);
		$link = substr($link,0,length($link)-3);
		if ( $before !~ $link) {
		 if ( substr($link,length($link)-1) !~ "#") {
		  $before = $link;
		  push(@links, $link);
		 }
		}
            }
        }
	foreach (@links) {
	   getContent($_, $artist);
	}
	$file = "Links";
	open(DAT,">$file") || die("Cannot Open File!");
	foreach (@links) {
	print DAT "$_\n";
	}
	close(DAT);
}

