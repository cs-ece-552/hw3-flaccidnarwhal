module rca_4b_bench;

  reg [3: 0] A, B;
  reg C_in;
  wire [3:0] S;
  wire C_out;

  wire Clk;
  //2 dummy wires
  wire rst;
  wire err;

  //clkrst module instantiation
  clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));

  //full adder module instantiation
  rca_4b DUT (.A(A), .B(B), .C_in(C_in), .S(S), .C_out(C_out));

  initial begin
    A = 0;
    B = 0;
    C_in = 0;

    #200;
  end

  always@(posedge Clk) begin
    #10;
    if (S != 0 || C_out != 0) $display("ERROR 0!");

    A = 0x8;
    B = 0x2;
    C_in = 0;
    #10;
    if (S != 0xA || C_out != 0) $display("ERROR 1!");

    A = 0xF;
    B = 0x1;
    C_in = 0;
    #10;
    if (S != 0x0 || C_out != 1) $display("ERROR 2!");

    A = 0xA;
    B = 0x5;
    C_in = 1;
    #10;
    if (S != 0x0 || C_out != 1) $display("ERROR 3!");

    $stop;
  end
endmodule
