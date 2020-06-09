module shift4_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:12] = 4'b0;
assign out[11:4] = a&{8{en}};
assign out[3:0] = 4'b0;

endmodule
