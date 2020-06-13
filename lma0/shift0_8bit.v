module shift0_8bit(
	input [7:0] a,
	input en,
	output [15:0] out
);

assign out[15:8] = 8'b0;
assign out[7:0] = a&{8{en}};

endmodule
