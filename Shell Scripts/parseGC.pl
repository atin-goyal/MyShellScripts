#!/usr/bin/perl
#use strict;

$cnt = 0;
$tmpcnt = 3;
$outGC="";

while ($cnt lt $ARGV[0]){

my @tl = `tail -$ARGV[1] $ARGV[2]$ARGV[$tmpcnt]`;
$cnt=$cnt+1;
$tmpcnt=$tmpcnt+1;
#my @af = ();
#print @tl;

$tmp = "";
$bflg= "";
$final= "";

foreach my $element (@tl) {

	if($element =~ /<af type/){
		#if( $bflg eq ""){
			#print "Found Start:",$element;
			$bflg="true";
			#$tmp = "$tmp$element";
		#}
	}

	if( $bflg eq "true"){
		$tmp = "$tmp$element";
	}

	if($element =~ /<\/af>/) {
		if( $bflg eq "true"){
			#print "Found End:",$element;
			$bflg="false";
			$final=$tmp;
			$tmp="";
		}
	}

}

#print $final;

$nur_id="";
$nur_FreeBytesBefore="-1";
$nur_TotalBytesBefore="-1";
$nur_FreePercentBefore="-1";
$nur_FreeBytesAfter="-1";
$nur_TotalBytesAfter="-1";
$nur_FreePercentAfter="-1";

$tenured_FreeBytesBefore="-1";
$tenured_TotalBytesBefore="-1";
$tenured_FreePercentBefore="-1";
$tenured_FreeBytesAfter="-1";
$tenured_TotalBytesAfter="-1";
$tenured_FreePercentAfter="-1";

$gctime="-1";

$nur_first="true";
$tenured_first="true";
$gctime_first="true";

my @final = split(/\n/,$final);

foreach my $element (@final) {
	#print $element;
	if($element =~ /<af type=\"nursery\" id=\"(\d+)/){
		$nur_id=$1;
	}
	if($element =~ /\s+<nursery\s+freebytes=\"(\d+)\"\s+totalbytes=\"(\d+)\"\s+percent=\"(\d+)\"\s+\/>/){
		if($nur_first eq "true"){
			$nur_FreeBytesBefore=$1;
			$nur_TotalBytesBefore=$2;
			$nur_FreePercentBefore=$3;
			
			$nur_first="false";
		}else{
			$nur_FreeBytesAfter=$1;
			$nur_TotalBytesAfter=$2;
			$nur_FreePercentAfter=$3;
		}
	}
	if($element =~ /\s+<tenured\s+freebytes=\"(\d+)\"\s+totalbytes=\"(\d+)\"\s+percent=\"(\d+)\"\s+>/){
		if($tenured_first eq "true"){
			$tenured_FreeBytesBefore=$1;
			$tenured_TotalBytesBefore=$2;
			$tenured_FreePercentBefore=$3;
			
			$tenured_first="false";
		}else{
			$tenured_FreeBytesAfter=$1;
			$tenured_TotalBytesAfter=$2;
			$tenured_FreePercentAfter=$3;
		}
	}
	if($element =~ /\s+<time\s+totalms=\"(\d+.\d+)\"\s+\/>/){
		if($gctime_first eq "true"){
			$gctime_first="false";
		}else{
			$gctime=$1;
		}
	}
}


$outGC="$outGC$nur_id,$nur_FreeBytesBefore,$nur_TotalBytesBefore,$nur_FreePercentBefore,$nur_FreeBytesAfter,$nur_TotalBytesAfter,$nur_FreePercentAfter,$tenured_FreeBytesBefore,$tenured_TotalBytesBefore,$tenured_FreePercentBefore,$tenured_FreeBytesAfter,$tenured_TotalBytesAfter,$tenured_FreePercentAfter,$gctime,";


}

print $outGC;

