#!/usr/bin/perl
use GD;
#$back = newFromPng GD::Image('files/A4.png') or die "Cannot open files/A4.png file!\n";
$DIR = './assets/';
$barcode_x = 203;
$barcode_y = 65;
#@x_value = (0,5, 248, 495, 725);
@x_value = (0, 0, 235, 485, 730);
@y_value = (0,
		58,
		130,
		202,
		274,
		346,
		418,
		490,
		560,
		632,
		704,
		776,
		848,
		920,
		992,
		1064,
		1138,
		1208,
		1280);
sub copy_barcode {
	($barcode,$x,$y) = @_;
	$back->copy($barcode,$x,$y,0,0,$barcode_x,$barcode_y);		
}
opendir(DIR,$DIR) or die "Cannot open $DIR directory!\n";
#print $DIR."\n";
@files = readdir(DIR);
$x_pos = 1;
$y_pos = 1;
$count = 1;
$page = 1;
foreach $file (@files)
{
	if($count == 1)
	{
		$back = newFromPng GD::Image('files/A4.png') or die "Cant get image A4!\n";
	}
#	print $file."\n";
	if(($file !~ '^page') && ($file !~ '^.$') && ($file !~ '^..$') && ($file !~ '^list.txt$'))
	{
#		print $file." ";
		$barcode = newFromPng GD::Image('assets/'.$file);
		copy_barcode($barcode,@x_value[$x_pos],@y_value[$y_pos]);
		$x_pos++;
		if($x_pos == 5)
		{
			$x_pos = 1;
			$y_pos++;
		}
		$count++;
		$last = 0;
		if($count == 73)
		{
			open(PNG, ">assets/page$page.png") or die "Cant create image file page$page.png!\n";
			binmode(PNG);
			print PNG $back->png;
			close(PNG);
			print "Create image file page$page.png!\n"; 
			$count = 1;
			$x_pos = 1;
			$y_pos = 1;
			$page++;
			$last = 1;
			
		}
		#print $x_pos." - ".$y_pos."\n";
	}
}
if(!$last)
{ 
	open(PNG, ">assets/page$page.png") or die "Cannot open assets/page$page.png file!\n";
	# make sure we are writing to a binary stream
	binmode(PNG);
	# Convert the image to PNG and print it on standard output
	print PNG $back->png;
	close(PNG);
	print "Create image file page$page.png!\n";
}
