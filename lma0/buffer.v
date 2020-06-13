module buffer(
	input[10:0] x,
	output [10:0] y
);
// straight through buffer because connecting two bus wires is a pain.
assign y = x;
endmodule