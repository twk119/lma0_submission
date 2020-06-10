module add(
	input [15:0] a,
	input [15:0] b,
	output [15:0] q
);

assign q = {a}+{b};

endmodule