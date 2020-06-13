module shift5_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:13] = 3'b0;
assign out[12:5] = a&{8{en}};
assign out[4:0] = 5'b0;

endmodule
