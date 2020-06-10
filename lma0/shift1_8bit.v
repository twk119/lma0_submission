module shift1_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:9] = 7'b0;
assign out[8:1] = a&{8{en}};
assign out[0] = 1'b0;

endmodule
