#!/usr/bin/perl -w

use warnings "all";
use strict;
use Getopt::Long;

my $script_name = $0;
my $help = 0;
my $tarball = "";
my $opt_result;
my $tempfolder;
my @filelist;

$opt_result = GetOptions (
  "tarball=s"  => \$tarball,
  "help"       => \$help
);

if(!$opt_result)
{
  print STDERR "$script_name: Invalid command line options!\n";
  print STDERR "$script_name: Use -help for assistance.\n";
  die;
}
if($tarball eq "")
{
  print STDERR "$script_name: Compulsory option -t is missing\n";
  print STDERR "$script_name: Use -help for assistance.\n";
  die;
}
if(! -e $tarball)
{
  print STDERR "$script_name: Tarball $tarball does not exist!\n";
  print STDERR "$script_name: Use -help for assistance.\n";
  die;
}
if($help)
{
  print_help();
  exit 0;
}

if($tarball !~ m/^demo3\.tar$/)
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Tarball should be named demo3.tar\n";
  print STDOUT "$script_name: Use the following command to generate the tarball:\n";
  print STDOUT "$script_name: tar -cvf demo3.tar verilog verification synthesis\n";
  die;
}

$tempfolder = `mktemp -d`;
chomp($tempfolder);
#print "$tempfolder\n";

`cp $tarball $tempfolder/.`;

`cd $tempfolder && tar -xvf demo3.tar`;
if(! -d "$tempfolder/verilog")
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Cannot find the folder verilog\n";
  print STDOUT "$script_name: (Maybe there is a wrapper directory around the required folders)\n";
  print STDOUT "$script_name: Use the following command to generate the tarball:\n";
  print STDOUT "$script_name: tar -cvf demo3.tar verilog verification synthesis\n";
  die;
}
if(! -d "$tempfolder/synthesis")
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Cannot find the folder synthesis\n";
  print STDOUT "$script_name: (Maybe there is a wrapper directory around the required folders)\n";
  print STDOUT "$script_name: Use the following command to generate the tarball:\n";
  print STDOUT "$script_name: tar -cvf demo3.tar verilog verification synthesis\n";
  die;
}
if(! -d "$tempfolder/verification")
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Cannot find the folder verification\n";
  print STDOUT "$script_name: (Maybe there is a wrapper directory around the required folders)\n";
  print STDOUT "$script_name: Use the following command to generate the tarball:\n";
  print STDOUT "$script_name: tar -cvf demo3.tar verilog verification synthesis\n";
  die;
}
if(! -d "$tempfolder/verification/mytests")
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Cannot find the folder verification/mytests\n";
  die;
}
if(! -d "$tempfolder/verification/results")
{
  print STDOUT "$script_name: Naming convention violation!\n";
  print STDOUT "$script_name: Cannot find the folder verification/results\n";
  die;
}

@filelist = ();
@filelist = `ls $tempfolder/verilog/*.v`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate verilog files in $tempfolder/verilog\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/mytests/*.asm`;
chomp(@filelist);
if (scalar(@filelist) <= 1)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate two .asm files in $tempfolder/verification/mytests\n";
}

@filelist = ();
@filelist = `ls $tempfolder/synthesis/area_report.txt`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate area report $tempfolder/synthesis/area_report.txt\n";
}

@filelist = ();
@filelist = `ls $tempfolder/synthesis/timing_report.txt`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate timing report $tempfolder/synthesis/timing_report.txt\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/perf.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/perf.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/complex_demofinal.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/complex_demofinal.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_final.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_final.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_ldst.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_ldst.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_idcache.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_idcache.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_icache.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_icache.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_dcache.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_dcache.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/complex_demo1.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/complex_demo1.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/complex_demo2.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/complex_demo2.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_complex.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_complex.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/rand_ctrl.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/rand_ctrl.summary.log\n";
}

@filelist = ();
@filelist = `ls $tempfolder/verification/results/inst_tests.summary.log`;
chomp(@filelist);
if (scalar(@filelist) == 0)
{
  print STDOUT "$script_name: MISSING FILE: Cannot locate summary file $tempfolder/verification/results/inst_tests.summary.log\n";
}

`rm -rf $tempfolder`;

sub print_help
{
print STDOUT qq{$script_name:
USAGE:
	$script_name -t <tarball name> [-h]

DESCRIPTION:
	This script tests the tarfile naming, folder hierarchy and file naming for the demo3 submission for CS552 (Fall 2012). If there are no warnings/errors on running the script, the tarball meets all the requirements.

OPTIONS:
	-t <tarball name>	Used to specify the tarball which is to be tested
	-h for viewing this help message

};
}
