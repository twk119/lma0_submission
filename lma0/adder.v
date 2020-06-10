module adder(
	input a,
	input b,
	input cin,
	
	output q
);

assign q = a ^ b ^ cin;

endmodule
