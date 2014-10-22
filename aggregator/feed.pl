#!/usr/bin/perl

use LWP::Simple;
use XML::RSS::Parser::Lite;

my $feed = new XML::RSS::Parser::Lite;
# then check it for new feeds
@array = ('http://url/path/?feed=rss2');
foreach $url (@array)
{
#	my $feed = new XML::RSS::Parser::Lite;
	$feed->parse(get($url));
	for (my $i = 0; $i < $feed->count(); $i++)
	{
		my $item = $feed->get($i);
                my $item_title = $item->get('title');
                my $item_link = $item->get('url');
                my $item_content = $item->get('description');

		my @feed_head = head($item_link);
		print $url.", ".$feed_head[2].", '".$item_link."', '".$item_content."'\n";
	}
}	
