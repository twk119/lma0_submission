module AND16(
	input bit0,
	input [15:0] data,
	output [15:0] b
);

assign b = (data&({16{bit0}}));

endmodule