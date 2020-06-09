module bka_optimised(
	input [15:0] a,
	input [15:0] b,
	input cin,
	output [15:0] sum,
	output cout
);

wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14;

wire p0, g0, p1, g1, p2, g2, p3, g3, p4, g4, p5, g5, p6, g6, p7, g7;
wire p8, g8, p9, g9, p10, g10, p11, g11, p12, g12, p13, g13, p14, g14, p15, g15;
wire p32, g32, p54, g54, p76, g76, p74, g74;
wire p98, g98, p1110, g1110, p118, g118, p1312, g1312, p1514, g1514, p1512, g1512, p158, g158;


assign p0 = a[0] ^ b[0];	// first level zero bit start
assign g0 = a[0] & b[0];
assign p1 = a[1] ^ b[1];
assign g1 = a[1] & b[1];
assign p2 = a[2] ^ b[2];
assign g2 = a[2] & b[2];
assign p3 = a[3] ^ b[3];
assign g3 = a[3] & b[3];
assign p4 = a[4] ^ b[4];
assign g4 = a[4] & b[4];
assign p5 = a[5] ^ b[5];
assign g5 = a[5] & b[5];
assign p6 = a[6] ^ b[6];
assign g6 = a[6] & b[6];
assign p7 = a[7] ^ b[7];
assign g7 = a[7] & b[7];
assign p8 = a[8] ^ b[8];
assign g8 = a[8] & b[8];
assign p9 = a[9] ^ b[9];
assign g9 = a[9] & b[9];
assign p10 = a[10] ^ b[10];
assign g10 = a[10] & b[10];
assign p11 = a[11] ^ b[11];
assign g11 = a[11] & b[11];
assign p12 = a[12] ^ b[12];
assign g12 = a[12] & b[12];
assign p13 = a[13] ^ b[13];
assign g13 = a[13] & b[13];
assign p14 = a[14] ^ b[14];
assign g14 = a[14] & b[14];
assign p15 = a[15] ^ b[15];
assign g15 = a[15] & b[15];

assign c0 = g0 | p0 & cin;	// Add in cin
assign c1 = g1 | p1 & c0;
assign c2 = g2 | p2 & c1;

assign p32 = p3 & p2;
assign g32 = p3 & g2 | g3;
assign p54 = p5 & p4;
assign g54 = p5 & g4 | g5;
assign p76 = p7 & p6;
assign g76 = p7 & g6 | g7;
assign p98 = p9 & p8;
assign g98 = p9 & g8 | g9;
assign p1110 = p11 & p10;
assign g1110 = p11 & g10 | g11;
assign p1312 = p13 & p12;
assign g1312 = p13 & g12 | g13;
assign cp1514 = p15 & p14;
assign cg1514 = p15 & g14 | g15;

// Following known numbers
assign c3 = g32 | p32 & c1;
assign c4 = g4 | p4 & c3;
assign c5 = g54 | p54 & c3;
assign c6 = g6 | p6 & c5;

assign p74 = p76 & p54;
assign g74 = g76 | p76 & g54;
assign c7 = 
assign c8 = 
assign c9 = 

// 7:4
assign cg27 = (cp1[7] & cg1[5]) | cg1[7];
assign cp27 = cp1[7] & cp1[5];

// Third layer, 4:0
assign cg34 = (cp1[4] & cg23) | cg1[4];
assign cp34 = cp1[4] & cp23;
// Third layer, 5:0
assign cg35 = (cp1[5] & cg23) | cg1[5];
assign cp35 = cp1[5] & cp23;
// Third layer, 6:0, 7:0
assign cg36 = (cp1[6] & cg35) | cg1[6];
assign cp36 = cp1[6] & cp35;
assign cg37 = (cp27 & cg23) | cg27;
assign cp37 = cp27 & cp23;
// Second layer, 11:8
assign cg211 = (cp1[11] & cg1[9]) | cg1[11];
assign cp211 = cp1[11] & cp1[9];
// Second layer, 15:12
assign cg215 = (cp1[15] & cg1[13]) | cg1[15];
assign cp215 = cp1[15] & cp1[13];
// Third layer, 15:8
assign cg315 = (cp215 & cg211) | cg215;
assign cp315 = cp215 & cp211;
// Fourth layer, 11:0
assign cg411 = (cp211 & cg37) | cg211;
assign cp411 = cp211 & cp37;
// Fourth layer, 15:0
assign cg415 = (cp315 & cg37) | cg315;
assign cp415 = cp315 & cp37;
// Fifth Layer, 9:0
assign cg59 = (cp1[9] & cg37) | cg1[9];
assign cp59 = cp1[9] & cp37;
// Fifth layer, 13:0
assign cg513 = (cp1[13] & cg411) | cg1[13];
assign cp513 = cp1[13] & cp411;
// Sixth Layer, 8:0
assign cg68 = (cp1[8] & cg37) | cg1[8];
assign cp68 = cp1[8] & cp37;
// Sixth Layer, 10:0
assign cg610 = (cp1[10] & cg59) | cg1[10];
assign cp610 = cp1[10] & cp59;
// Sixth Layer, 12:0
assign cg612 = (cp1[12] & cg411) | cg1[12];
assign cp612 = cp1[12] & cp411;
// Sixth Layer, 14:0
assign cg614 = (cp1[14] & cg513) | cg1[14];
assign cp614 = cp1[14] & cp513;


// Assign sums: s[n] = a[n] ^ b[n] ^ cin.
// cin = previous generate term
assign s[0] = p[0];
assign s[1] = p[1] ^ cg1[0];
assign s[2] = p[2] ^ cg1[1];
assign s[3] = p[3] ^ cg22;
assign s[4] = p[4] ^ cg23;
assign s[5] = p[5] ^ cg34;
assign s[6] = p[6] ^ cg35;
assign s[7] = p[7] ^ cg36;
assign s[8] = p[8] ^ cg37;
assign s[9] = p[9] ^ cg68;
assign s[10] = p[10] ^ cg59;
assign s[11] = p[11] ^ cg610;
assign s[12] = p[12] ^ cg411;
assign s[13] = p[13] ^ cg612;
assign s[14] = p[14] ^ cg513;
assign s[15] = p[15] ^ cg614;
assign s[16] = cg415;
assign sum = {s[15:0]};
assign cout = s[16];

endmodule