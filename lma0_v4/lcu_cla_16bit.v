module lcu_cla_16bit (a, b, cin, cout, sum);

// Implements 4 CLA adders with an intermediate LCU module for a faster 16-bit adder experience.

input [15:0] a;
input [15:0] b;
input cin;
output [15:0] sum;
output cout;

// Intermediate group prop/generate
wire pg0, gg0, pg4, gg4, pg8, gg8, pg12, gg12;
// carries
wire c1, c2, c3, c4;

lcu lookahead(pg0, gg0, pg4, gg4, pg8, gg8, pg12, gg12, cin, c1, c2, c3, c4);

CLA_4bit add30(a[3:0], b[3:0], cin, sum[3:0], gg0, pg0);
CLA_4bit add74(a[7:4], b[7:4], c1, sum[7:4], gg4, pg4);
CLA_4bit add118(a[11:8], b[11:8], c2, sum[11:8], gg8, pg8);
CLA_4bit add1512(a[15:12], b[15:12], c3, sum[15:12], gg12, pg12);

assign cout = c4;

endmodule