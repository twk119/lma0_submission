module shift6_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:14] = 2'b0;
assign out[13:6] = a&{8{en}};
assign out[5:0] = 6'b0;

endmodule
