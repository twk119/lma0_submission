// p1/g1 are the larger number.
module pg_graycell(
	input p1, 
	input g1, 
	input g2,
	output gout
);

// Gray cell takes the current generate and propagate terms and the previous generate term.
// It then sees if the current bit will generate a carry.
assign gout = g1 | (p1 & g2) ;
	
endmodule
