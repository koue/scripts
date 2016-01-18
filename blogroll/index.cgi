#!/usr/bin/perl

#use strict;
#use warnings;

use DBI;


$database = "/etc/scripts/aggregator/RSS.sql";

$dbargs = { PrintError => 1};

$db = DBI->connect("dbi:SQLite:dbname=$database","","",$dbargs) or die "No connection to the database!\n";


$main_query = $db->prepare("SELECT id, modified, link, title, description, pubdate from feeds where chanid IN (select id from channels where catid = 2) order by id desc limit 10");
$main_query->execute;

print "Content-type:text/html\r\n\r\n";
print '<html>';
print '<head>';
print '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
print '<title>chaosophia blogroller</title>';
print '<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<style type="text/css" media="screen, print">
		@import "https://blogroll.chaosophia.net/graffitti/style/common.css";
		@import "https://blogroll.chaosophia.net/graffitti/style/default.css";
	</style>';
print '</head>';
print '<body>';
print '<div id="header">
		<a href="https://blogroll.chaosophia.net/index.cgi" title="home"> chaosophia blogroller</a>
	</div>';

print '<div class="entryend"></div>';
print ' <div id="sidebar">
			<div class="column">
				<h1>About</h1>
				<p>Quick and dirty RSS collector.<br /> koue _at_ chaosophia.net</p>
			</div>

			<div class="column">';
$channels_query = $db->prepare("select link from channels where catid = 2");
$channels_query->execute;
@channels_array = ();
while(@result = $channels_query->fetchrow_array())
{
		push(@channels_array, $result[0]);
#		print "<a href=".$result[0].">".$result[0]."</a><br />\n";
}
@channels_array = sort(@channels_array);
foreach (@channels_array)
{
		print "<a href=".$_.">".$_."</a><br />\n";
}

print '			 </div>
		</div>

<div id="content">

';
# check last modified time on every link and if there is new timestamp
# then check it for new feeds
while (@result = $main_query->fetchrow_array())
{
	$feed_id = $result[0];
	$feed_modified = $result[1];
	$feed_link = $result[2];
	$feed_title = $result[3];
	$feed_description = $result[4];
	$feed_pubdate = $result[5];
#	print "<tr><td>".$feed_id. "</td><td>".$feed_pubdate."</td><td>".$feed_url."</td><td>".$feed_title."</td><td>".$feed_description."</td></tr>\n";
	print '<p class="date">'.$feed_pubdate.'</p>';
	print '<div class="entry">';
	print '<h1 class="title">'.$feed_title.'</h1>';
	print '<div class="story">';
	print $feed_description;
	print '</div>';
print '<p class="postinfo">

	<a href="'.$feed_link.'">'.$feed_link.'</a>
	</p></div>';

print '<div class="entryend"></div>';
}
$main_query->finish;
#print "</table>\n";
print "</div>\n";

print '</body>';
print '</html>';

1;
