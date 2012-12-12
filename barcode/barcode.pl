#!/usr/bin/perl
use GD;
use Barcode::Code128;
$assets_file = './list.txt';
open(ASSETS, $assets_file) or die 'neshto si';
$count = 1;
while($line = <ASSETS>)
{
	$image = new GD::Image(203,65);
	$black = $image->colorAllocate(0,0,0);
	$white = $image->colorAllocate(255,255,255);
	$image->fill(0,0,$white);
	$barcode = new Barcode::Code128;
	$barcode->scale(1);
	$datetag = substr($line,0,index($line,' '));
	$department = substr($line,(index($line,' ')+1)); 
	$department = substr($department,0,-1);
	open(TMP,">assets/TMP.png") or die "Cannot open assets/TMP.png file!\n";
	binmode(TMP);
	print TMP $barcode->png($datetag) or die "Cannot modify assets/TMP.png file!\n";
	close(TMP);
	$barcode = newFromPng GD::Image('assets/TMP.png') or die "Cannot modify assets/TMP.png file!\n";
	$image->copy($barcode,0,0,0,0,203,50);
	$image->string(gdSmallFont,1,51,$department,$black);
	

	open(PNG,">assets/$count.png") or die "Cant write $count.png file!\n";
	binmode(PNG);
	print PNG $image->png;
	close(PNG);
#	unlink('assets/TMP.png');
	print $datetag." - ".$department."\n";
	$count++;
}
unlink('assets/TMP.png');
close(ASSETS);
