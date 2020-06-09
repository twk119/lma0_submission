module fulladder(a, b, cin, q);

// one-bit full adder. Does not compute carry out as it is already handled elsewhere.

input a, b, cin;
output q;

assign q = (a ^ b) ^ cin;

endmodule