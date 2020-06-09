module pg_onebitx(a, b, p, g);

// Generates carry propogate and generate for individual bits.

input a;
input b;
output p;
output g;

assign g = a & b;	// if g=true, then cout=1
assign p = a | b;	// use OR instead of XOR as it is cheaper

endmodule

