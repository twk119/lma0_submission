module shift2_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:10] = 6'b0;
assign out[9:2] = a&{8{en}};
assign out[1:0] = 2'b0;

endmodule
