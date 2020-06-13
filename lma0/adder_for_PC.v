module adder_for_PC(
	input[10:0] a,
	input cin,
	output[10:0] q
);

// A ripple carry design should be sufficient?
wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10;

assign q[0] = a[0] ^ cin;
assign c1 = a[0] & cin;
assign q[1] = a[1] ^ c1;
assign c2 = a[1] & c1;
assign q[2] = a[2] ^ c2;
assign c3 = a[2] & c2;
assign q[3] = a[3] ^ c3;
assign c4 = a[3] & c3;
assign q[4] = a[4] ^ c4;
assign c5 = a[4] & c4;
assign q[5] = a[5] ^ c5;
assign c6 = a[5] & c5;
assign q[6] = a[6] ^ c6;
assign c7 = a[6] & c6;
assign q[7] = a[7] ^ c7;
assign c8 = a[7] & c7;
assign q[8] = a[7] ^ c8;
assign c9 = a[8] & c8;
assign q[9] = a[9] ^ c9;
assign c10 = a[9] & c9;
assign q[10] = a[10] ^ c10;

endmodule
