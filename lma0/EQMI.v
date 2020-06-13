module EQMI(
	input [15:0] acc,
	output EQ,
	output LT
);

wire mostZero = ~acc[15] & ~acc[14] & ~acc[13] & ~acc[12] & ~acc[11] & ~acc[10] 
				& ~acc[9] & ~acc[8] & ~acc[7] & ~acc[6] & ~acc[5] & ~acc[4] 
				& ~acc[3] & ~acc[2] & ~acc[1];

assign EQ = mostZero & ~acc[0];
				
assign LT = mostZero | acc[15];	// Either 0000...0000 (0) or 0000...0001 (1) or 1....xxx (-ve).
		
endmodule
