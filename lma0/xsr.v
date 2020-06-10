module xsr(
	input [15:1] rs,
	input cin,
	output [15:0] rd
);

assign rd[15] = cin;
assign rd[14:0] = rs[15:1];

endmodule
