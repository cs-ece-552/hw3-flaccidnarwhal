module fullAdder_tb;

  reg  A, B;
  reg C_in;
  wire S;
  wire C_out;

  wire Clk;
  //2 dummy wires
  wire rst;
  wire err;

  //clkrst module instantiation
  clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));

  //full adder module instantiation
  fullAdder_1b DUT (.A(A), .B(B), .C_in(C_in), .S(S), .C_out(C_out));

  initial begin
    A = 0;
    B = 0;
    C_in = 0;

    #200;
  end

  always@(posedge Clk) begin
    #10;
    if (S == 1 || C_out == 1) $display("ERROR 0!");

    A = 0;
    B = 0;
    C_in = 1;
    #10;
    if (S == 0 || C_out == 1) $display("ERROR 1!");

    A = 0;
    B = 1;
    C_in = 0;
    #10;
    if (S == 0 || C_out == 1) $display("ERROR 2!");

    A = 0;
    B = 1;
    C_in = 1;
    #10;
    if (S == 1|| C_out == 0) $display("ERROR 3!");

    A = 1;
    B = 0;
    C_in = 0;
    #10;
    if (S == 0 || C_out == 1) $display("ERROR 4!");

    A = 1;
    B = 0;
    C_in = 1;
    #10;
    if (S == 1 || C_out == 0) $display("ERROR 5!");

    A = 1;
    B = 1;
    C_in = 0;
    #10;
    if (S == 1 || C_out == 0) $display("ERROR 6!");

    A = 1;
    B = 1;
    C_in = 1;
    #10;
    if (S == 0 || C_out == 0) $display("ERROR 7!");

    $stop;
  end
endmodule
