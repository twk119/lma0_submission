module shift7_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15] = 1'b0;
assign out[14:7] = a&{8{en}};
assign out[6:0] = 7'b0;

endmodule
