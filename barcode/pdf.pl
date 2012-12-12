#!/usr/bin/perl
    use PDF::API2;
    chomp;
    if(grep(/\D/, $ARGV[0]))
    {
	print "pdf.pl: wrong parameter!\n";
	exit 1;
    }
    $number = $ARGV[0];
    $pdf = PDF::API2->new;
    if(!( -r 'assets/page'.$number.'.png'))
    {
	print ("Cannot find file: assets/page".$number.".png!\n");
	exit 1;
    }
    $img = $pdf->image_png('assets/page'.$number.'.png');
    $page = $pdf->page;
    $page->mediabox($img->width,$img->height);
    $gfx=$page->gfx;
    $gfx->image($img,0,0,1);
    $pdf->saveas('print'.$number.'.pdf');
    print "Create print".$number.".pdf\n";

