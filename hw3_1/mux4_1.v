/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 1

    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output       Out;

    // YOUR CODE HERE
    //assign Out = S[1] : mux2_1(InC,InD,S[0],Out) ?
    //                    mux2_1(InA,InB,S[0],Out);

    wire outa, outb; //intermediates

    mux2_1 muxab(.InA(InA),.InB(InB),.S(S[0]),.Out(outa)); //choose A or B based on lower select
    mux2_1 muxcd(.InA(InC),.InB(InD),.S(S[0]),.Out(outb)); //choose C or D based on lower select
    mux2_1 muxout(.InA(outa),.InB(outb),.S(S[1]),.Out(Out)); //choose outa or outb based on upper select

endmodule
