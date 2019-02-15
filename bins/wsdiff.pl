#!/s/std/bin/perl

use strict;

my $asm_file = $ARGV[0];
my $arch_trace_file = $ARGV[1];
my $verilog_trace_file = $ARGV[2];
my $list_file = "loadfile.lst";
my %prog_binary;

my $bin_root="/u/s/i/sinclair/public/html/courses/cs552/spring2019/handouts/bins";

if ($#ARGV != 2) {
  print_usage();
  exit 0;
}

&compile_assemble($asm_file);

&read_list_file();
my @arch_trace;
my @verilog_trace;
my $n_arch_entries = &read_trace($arch_trace_file, \@arch_trace);
my $n_verilog_entries = &read_trace($verilog_trace_file, \@verilog_trace);

my $i = 0; 
my $n_max = $n_verilog_entries;
if ($n_arch_entries > $n_verilog_entries) {
  $n_max = $n_arch_entries;
}

for ($i = 0; $i < $n_max; $i++) {
  my $s0 = $arch_trace[$i];
  my $s1 = $verilog_trace[$i];
  my @w = split(' ', $s0);
  my $pc = $w[3];
  $pc =~ s/^0x//;
  if (! defined $prog_binary{$pc} ) {
    print "Arch trace has a PC not defined in binary image. Panic.\n";
    print "$pc $s0\n";
    exit -1;
  }
  my $inst_data = $prog_binary{$pc};
  @w = split(' ', $inst_data);
  my $inst_bits = $w[0]; shift @w;
  my $inst_asm = "@w";
  my $diff;
  if ($s0 eq $s1) {
    $diff = " ";
  } else {
    $diff = "***DIFF***";
  }
  my $s = sprintf("INST:   %20s %s %s\nARCH:    %s\nVERILOG: %s\n",
                      &hextobinary($inst_bits), $inst_asm, $diff, $s0, $s1);
  print "$s";

}


sub read_trace() {
  my ($fname, $A_ref) = @_;
  my @array;
  open(F1, $fname);
  @array = <F1>;
  chomp @array;
  close F1;
  push @$A_ref, @array;
  return ($#array + 1);
}

sub read_list_file() {
  if (! -r $list_file) {
    print "Assembling program did not create loadfile.list. Cannot proceed\n";
    exit -1;
  }
  open(F1, $list_file);
  my @list_file_data = <F1>;
  close F1;
  foreach my $a (@list_file_data) {
    my @w = split(' ', $a);
    my $pc = $w[0]; shift @w;
    my $data = "@w";
    $data =~ s/\/\/.*//g;
    $data =~ s/\s+$//g;
    $prog_binary{$pc} = $data;
  }
  
}

sub compile_assemble() {
  my $prog_file = @_;
  my $retval = bin_exists("$bin_root/assemble.sh");
  if ( ($retval == 0) && (-r $asm_file) ) {
    my $c0 = "$bin_root/assemble.sh $asm_file > /dev/null";
    system($c0);
  } elsif (! -r $asm_file) {
    print "Did not find program to compile $asm_file\n";
    die "";
  } else {
    print "Could not find the assembler assemble.sh in your PATH\n";
    die "";
  }
}

sub bin_exists() {
  return 0;
  my ($name) = @_;
  my $retval;
  system("which $name > /dev/null"); $retval = ($? >> 8);
  return $retval;
}

sub hextobinary() {
  my ($c) = @_;
    my %hextobinary_map;
      $hextobinary_map{"0"} = "0000";
        $hextobinary_map{"1"} = "0001";
	  $hextobinary_map{"2"} = "0010";
	    $hextobinary_map{"3"} = "0011";
	      $hextobinary_map{"4"} = "0100";
	        $hextobinary_map{"5"} = "0101";
		  $hextobinary_map{"6"} = "0110";
		    $hextobinary_map{"7"} = "0111";
		      $hextobinary_map{"8"} = "1000";
		        $hextobinary_map{"9"} = "1001";
			  $hextobinary_map{"a"} = "1010";
			    $hextobinary_map{"b"} = "1011";
			      $hextobinary_map{"c"} = "1100";
			        $hextobinary_map{"d"} = "1101";
				  $hextobinary_map{"e"} = "1110";
				    $hextobinary_map{"f"} = "1111";

				      my $i = 0;
				        my $s = "";
					  for ($i = 0 ; $i < length($c); $i++) {
					          my $x = lc(substr($c, $i, 1));
						          $s = $s." ".$hextobinary_map{$x};
							    }
							      return $s;
							      }

