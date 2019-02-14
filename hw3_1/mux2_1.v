/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    // YOUR CODE HERE
    // Out = S ? InB : InA;

    wire ina, inb, s_n; //temp signals

    not1 nota(.in1(S),.out(s_n)); //get inverse not signal
    nand2 nanda(.in1(s_n),.in2(InA),.out(ina)); //if select is 0, choose A
    nand2 nandb(.in1(S),.in2(InB),.out(inb)); //if select is 1, choose B
    nand2 nando(.in1(ina),.in2(inb),.out(Out)); //set Out to correct choice

endmodule
