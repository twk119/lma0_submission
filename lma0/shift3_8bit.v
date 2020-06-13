module shift3_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:11] = 5'b0;
assign out[10:3] = a&{8{en}};
assign out[2:0] = 3'b0;

endmodule
