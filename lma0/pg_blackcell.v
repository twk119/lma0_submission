// p1/g1 are the larger number.
module pg_blackcell(
	input p1,
	input g1,
	input p2,
	input g2,
	
	output pout,
	output gout
);

// Black cells contain the group generate and propagate terms.
assign gout = g1 | (p1 & g2);
assign pout = p1 & p2;

endmodule
