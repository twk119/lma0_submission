module pg_onebit(
	input a,
	input b,
	output p,
	output g
);

assign p = a | b; // Propagate term
assign g = a & b;	// Generate term

endmodule
