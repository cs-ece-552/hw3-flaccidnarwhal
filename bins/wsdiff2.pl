#!/s/std/bin/perl

use strict;

if ($#ARGV < 3) {
  print_usage();
  exit 0;
}

my $minimize_trace;
my $global_halt_line;

if ($ARGV[0] eq "-relax") {
  $minimize_trace = 1;
  shift @ARGV;
}

my $asm_file = $ARGV[0];
my $arch_trace_file = $ARGV[1];
my $arch_ptrace_file = $ARGV[2];
my $verilog_trace_file = $ARGV[3];
my $list_file = "loadfile.lst";
my %prog_binary;

my $bin_root="/u/s/i/sinclair/public/html/courses/cs552/spring2019/handouts/bins";

&compile_assemble($asm_file);

&read_list_file();
my @arch_trace;
my @arch_ptrace;
my @verilog_trace;
my $n_arch_entries = &read_trace($arch_trace_file, \@arch_trace, 0);
my $n_verilog_entries = &read_trace($verilog_trace_file, \@verilog_trace, $minimize_trace );
my $n_parch_entries = &read_trace($arch_ptrace_file, \@arch_ptrace, $minimize_trace);


my $n_max = $n_arch_entries;
my $j = 0;
my $N_DIFFS = 0;
for (my $i = 0; $i < $n_max; $i++) {
  my $s = $arch_trace[$i];

  my @w = split(' ', $s);
  my $pc = $w[3];
  $pc =~ s/^0x//;
  my $inst_data;
  if (! defined $prog_binary{$pc} ) {
    print "Warning: Arch trace has a PC not defined in binary image. Assuming it is a halt. Bad binary \"$asm_file\". Panic.\n";
    print "$pc $s\n";
    $inst_data = $global_halt_line;
  } else {
    $inst_data = $prog_binary{$pc};
  }
  @w = split(' ', $inst_data);

  my $inst_bits = $w[0]; shift @w;
  my $inst_asm = "@w";
  my $n_pipe_lines = 1;
  if ( ($inst_asm =~ /^ld/) || ($inst_asm =~ /^stu/) ) {
    $n_pipe_lines = 2;
  }
  if ( ($inst_asm =~ /^jal/) ||
       ($inst_asm =~ /^jalr/) ) {
# do nothing; n_pipe_lines is set to 1
  } elsif ( ($inst_asm =~ /^beqz/) ||
       ($inst_asm =~ /^bnez/) ||
       ($inst_asm =~ /^bltz/) ||
       ($inst_asm =~ /^bgez/) ||
       ($inst_asm =~ /^j/) ||
       ($inst_asm =~ /^jr/) ||
       ($inst_asm =~ /^nop/) ||
       ($inst_asm =~ /^halt/)) {
    $n_pipe_lines = 0;
  }
  my $q = sprintf("INST:   %20s %s\n",
                      &hextobinary($inst_bits), $inst_asm );
  print "$q";


  for (my $k = 0; $k < $n_pipe_lines; $k++) {
    my $s0 = $arch_ptrace[$j];
    my $s1 = $verilog_trace[$j];
    $j++;
    my $diff;
    if ($s0 eq $s1) {
      $diff = " ";
    } else {
      $diff = "***DIFF***";
      $N_DIFFS++;
    }
    $q = sprintf("ARCH:    %s $diff\nVERILOG: %s\n",
                 $s0, $s1);
    print $q;
  }
}

if ($N_DIFFS == 0) {
  print "SUCCESS: No differences\n";
  exit 0;
} else {
  print "FAIL: $N_DIFFS differences\n";
  exit 1;
}

sub read_trace() {
  my ($fname, $A_ref, $minimize) = @_;
  my @array;
  open(F1, $fname);
  @array = <F1>;
  chomp @array;
  close F1;
  
  if ($minimize) {
    my @array2;
    my $prev = "";
    foreach my $a (@array) {
      if ($prev ne $a) {
        push @array2, $a;
      }
      $prev = $a;
    }
    @array = @array2;
  }

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
    if ($w[2] =~ /halt/) {
      $global_halt_line = $data;
    }
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

