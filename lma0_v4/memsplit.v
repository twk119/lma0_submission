module memsplit(
	input [10:0] rawAddr,
	input instrData,
	output [11:0] ramAddr
);


// Sign extend the RAM R/W address based on the type of instruction.
assign ramAddr[10:0] = rawAddr[10:0];
assign ramAddr[11] = instrData;

endmodule

