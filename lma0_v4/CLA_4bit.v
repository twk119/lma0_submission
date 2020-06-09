module CLA_4bit(a, b, cin, sum, gg, pg);

// Implementation of a 4-bit CLA adder.

input [3:0] a;
input [3:0] b;
input cin;
output [3:0] sum;
output gg, pg;	// cout is equivalent to group generate

// One-bit
wire p0, p1, p2, p3, g0, g1, g2, g3; 
wire c1, c2, c3, c4;

// Compute P and G for all 4 bits:
pg_onebit pg0(a[0], b[0], p0, g0);
pg_onebit pg1(a[1], b[1], p1, g1);
pg_onebit pg2(a[2], b[2], p2, g2);
pg_onebit pg3(a[3], b[3], p3, g3);

// Compute carry for the thing using LCU module
lcu look_ahead(p0, g0, p1, g1, p2, g2, p3, g3, cin, c1, c2, c3, c4);

// Assign group generate and propogate
assign gg = c4;
assign pg = p3 & p2 & p1 & p0;

// Addition
fulladder fa0(a[0], b[0], cin, sum[0]);
fulladder fa1(a[1], b[1], c1, sum[1]);
fulladder fa2(a[2], b[2], c2, sum[2]);
fulladder fa3(a[3], b[3], c3, sum[3]);

endmodule
