/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 2

    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    // YOUR CODE HERE
    wire cout_n;
    wire and_ab;
    wire and_ac;
    wire and_bc;

    //sum = A ^ B ^ C_in
    xor3 xor(A,B,C_in,S);

    //AND(A,B)
    nand2 nand1(A,B,and_ab);
    not1 not1(and_ab,and_ab);
    //AND(A,C_in)
    nand2 nand2(A,C_in,and_ac);
    not1 not2(and_ac,and_ac);
    //AND(B,C_in)
    nand2 nand3(B,C_in,and_bc);
    not1 not3(and_bc,and_bc);


endmodule
