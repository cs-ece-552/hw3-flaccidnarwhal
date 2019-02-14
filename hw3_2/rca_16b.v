/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 2

    a 16-bit RCA module
*/
module rca_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    // YOUR CODE HERE
    wire C0, C1, C2;

    rca_4b rc0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .C_out(C0));
    rca_4b rc1(.A(A[7:4]), .B(B[7:4]), .C_in(C0), .S(S[7:4]), .C_out(C1));
    rca_4b rc2(.A(A[11:8]), .B(B[11:8]), .C_in(C1), .S(S[11:8]), .C_out(C2));
    rca_4b rc3(.A(A[15:12]), .B(B[15:12]), .C_in(C2), .S(S[15:12]), .C_out(C_out));

endmodule
