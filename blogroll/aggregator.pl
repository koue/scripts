#!/usr/bin/perl

use strict;
use warnings;

use LWP::Simple;
use XML::Simple;
use DBI;

my $DEBUG_ENABLE = 0;


my $database = "/etc/scripts/aggregator/RSS.sql";

my $dbargs = { PrintError => 1};

my $db = DBI->connect("dbi:SQLite:dbname=$database","","",$dbargs) or die "No connection to the database!\n";

sub isdefined
{
	if(defined($_[0]))
	{
		return $_[0];
	}
	else
	{
		return "__NULL__";
	}
}

sub escape_chars
{
        my $str = $_[0];

        $str =~ s/(')/'$1/g;

        return $str;
}

# select links from tech category
my $main_query = $db->prepare("SELECT id, modified, link from channels");
$main_query->execute;

# check last modified time on every link and if there is new timestamp
# then check it for new feeds
while (my @result = $main_query->fetchrow_array())
{
	my $channel_id = $result[0];
	my $channel_modified = $result[1];
	my $channel_link = $result[2];

	if($DEBUG_ENABLE)
	{	
		print $channel_id. " ".$channel_modified." ".$channel_link."\n";
	}
	
	# check for parameters: $content_type, $document_length, $modified_time, $expires, $server 
	#my @channel_head = head($channel_link);
	#
	my $channel_current_modified = `lwp-request -e $channel_link | grep ^Last-Modified | sed -e s/Last-Modified://`;
	chomp($channel_current_modified);
	if($DEBUG_ENABLE)
	{
		print "Last modified time: ".$channel_modified."\n";
		print "Current modified time: ".$channel_current_modified."\n";
	}
	if(length($channel_current_modified) < 1) 
	{
		$channel_current_modified = `date`;
		chomp($channel_current_modified);
	}
#	if ($channel_head[2] > $channel_modified)
	if ($channel_current_modified !~  /$channel_modified/)
	{
		if($DEBUG_ENABLE)
		{
			print "Updating ".$channel_link." with time ".$channel_current_modified."\n";
			print "SQL QUERY --> UPDATE channels set modified = '".$channel_current_modified."' where id = ".$channel_id."\n";
		}
		my $update_query = $db->prepare("UPDATE channels set modified = '".$channel_current_modified."' where id = ".$channel_id);
		$update_query->execute or die $update_query->errstr;
		$update_query->finish;

		#print "channel - $channel_link\n";
		my $feed = XMLin(get($channel_link));
		
		my $items_count = @{$feed->{channel}->{item}};
		my $i = $items_count - 1;
		while($i > -1)
		{
       	        	my $feed_link = $feed->{channel}->{item}[$i]->{link};
			
			my $feed_title = escape_chars($feed->{channel}->{item}[$i]->{title});
			my $feed_description = escape_chars(isdefined($feed->{channel}->{item}[$i]->{description}));
			my $feed_pubdate = $feed->{channel}->{item}[$i]->{pubDate};

			
			if($DEBUG_ENABLE)
			{
				print "link - ".$feed_link."\n";
				print "title - ".$feed_title."\n";
				print "description - ".$feed_description."\n";
				print "pubdate - ".$feed_pubdate."\n";
				print "SQL QUERY --> SELECT chanid, link from feeds where chanid = ".$channel_id." and link = '".$feed_link."'\n";
			}
			my $feed_query = $db->prepare("SELECT chanid, link from feeds where chanid = ".$channel_id." and link = '".$feed_link."'");
		 
			$feed_query->execute;
			if(!$feed_query->fetchrow_array())
			{
				print "New feed has been added to the database: ". $feed_link."\n";
				if($DEBUG_ENABLE)
				{
					print $channel_id.", ".$feed_head[2].", '".$feed_link."'\n";
					print "SQL QUERY --> insert into feeds (chanid, modified, link, title, description, pubdate) values (".$channel_id.", 0, '".$feed_link."', '".$feed_title."', '".$feed_description."', '".$feed_pubdate."')\n";
				}
				my $feed_insert_query = $db->prepare("insert into feeds (chanid, modified, link, title, description, pubdate) values (".$channel_id.", 0, '".$feed_link."', '".$feed_title."', '".$feed_description."', '".$feed_pubdate."')");
				$feed_insert_query->execute;
				$feed_insert_query->finish;
			}
			$i--;
		}	
	}
}
$main_query->finish;
