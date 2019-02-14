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
    wire nand_ab;
    wire and_ac;
    wire nand_ac;
    wire and_bc;
    wire nand_bc;
    wire nor_abc;
    wire or_abc;

    //sum = A ^ B ^ C_in
    xor3 xorabc(A,B,C_in,S);

    //C_out = (A&B) + (A&C_in) + (B&C_in)
    //AND(A,B)
    nand2 nand1(A,B,nand_ab);
    not1 not1(nand_ab,and_ab);
    //AND(A,C_in)
    nand2 nand2(A,C_in,nand_ac);
    not1 not2(nand_ac,and_ac);
    //AND(B,C_in)
    nand2 nand3(B,C_in,nand_bc);
    not1 not3(nand_bc,and_bc);

    //NOT NOR ABC = (A&B) + (A&C_in) + (B&C_in)
    nor3 norandabc(.in1(and_ab),.in2(and_ac),.in3(and_bc),.out(nor_abc));
    not1 cout(.in1(nor_abc),.out(C_out));

endmodule
