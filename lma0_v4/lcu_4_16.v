module lcu(p0, g0, p1, g1, p2, g2, p3, g3, cin, c1, c2, c3, c4);

// Implementation of a LCU unit for a 4-unit CLA adder of variable proporitons.
// Is also included into the current implementation of the 4-bit CLA adder as well.

input p0, g0, p1, g1, p2, g2, p3, g3, cin;
output c1, c2, c3, c4;
assign c1 = g0 | cin & p0;
assign c2 = g1 | g0 & p1 | cin & p1 & p0;
assign c3 = g2 | g1 & p2 | g0 & p2 & p1 | cin & p2 & p1 & p0;
assign c4 = g3 | g2 & p3 | g1 & p3 & p2 | g0 & p3 & p2 & p1 | cin & p3 & p2 & p1 & p0;

endmodule
