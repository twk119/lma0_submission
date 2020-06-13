module shift4(
	input cout,
	output [15:0] shifted
);

assign shifted[15:9] = 7'b0;
assign shifted[8] = cout;
assign shifted[7:0] = 8'b0;

endmodule