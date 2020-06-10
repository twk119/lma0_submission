module add16(
	input [15:0] a,
	input [15:0] b,
	input cin,
	output [15:0] q,
	output cout
);

assign {cout,q} = {a} + {b} + {cin};

endmodule