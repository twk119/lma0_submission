module bka_16_nocincout(a, b, q);

input [15:0] a;
input [15:0] b;

output [15:0] q;

wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14;

wire p1, g1, p2, g2, p3, g3, p4, g4, p5, g5, p6, g6, p7, g7;
wire p8, g8, p9, g9, p10, g10, p11, g11, p12, g12, p13, g13, p14, g14, p15, g15;
wire p32, g32, p54, g54, p76, g76, p74, g74;
wire p98, g98, p1110, g1110, p118, g118, p1312, g1312, p1514, g1514, p1512, g1512, p158, g158;

// Calculate one-bit processes
//pg_onebit pg0(a[0], b[0], p0, g0);
pg_onebit pg1(a[1], b[1], p1, g1);
pg_onebit pg2(a[2], b[2], p2, g2);
pg_onebit pg3(a[3], b[3], p3, g3);
pg_onebit pg4(a[4], b[4], p4, g4);
pg_onebit pg5(a[5], b[5], p5, g5);
pg_onebit pg6(a[6], b[6], p6, g6);
pg_onebit pg7(a[7], b[7], p7, g7);
pg_onebit pg8(a[8], b[8], p8, g8);
pg_onebit pg9(a[9], b[9], p9, g9);
pg_onebit pg10(a[10], b[10], p10, g10);
pg_onebit pg11(a[11], b[11], p11, g11);
pg_onebit pg12(a[12], b[12], p12, g12);
pg_onebit pg13(a[13], b[13], p13, g13);
pg_onebit pg14(a[14], b[14], p14, g14);
pg_onebit pg15(a[15], b[15], p15, g15);

// Calculate
assign c0 = a[0] & b[0];
pg_graycell gc1(p1, g1, c0, c1);
pg_graycell gc2(p2, g2, c1, c2);

pg_blackcell bc32(p3, g3, p2, g2, p32, g32);
pg_graycell gc3(p32, g32, c1, c3);
pg_graycell gc4(p4, g4, c3, c4);

pg_blackcell bc54(p5, g5, p4, g4, p54, g54);
pg_graycell gc5(p54, g54, c3, c5);
pg_graycell gc6(p6, g6, c5, c6);

pg_blackcell bc76(p7, g7, p6, g6, p76, g76);
pg_blackcell bc74(p76, g76, p54, g54, p74, g74);
pg_graycell gc7(p74, g74, c3, c7);

pg_blackcell bc98(p9, g9, p8, g8, p98, g98);
pg_graycell gc8(p8, g8, c7, c8);
pg_graycell gc9(p9, g9, c7, c9);

pg_blackcell bc1110(p11, g11, p10, g10, p1110, g1110);
pg_blackcell bc118(p1110, g1110, p98, g98, p118, g118);
pg_graycell gc11(p118, g118, c7, c11);
pg_graycell gc10(p10, g10, c9, c10);

pg_blackcell bc1312(p13, g13, p12, g12, p1312, g1312);
pg_graycell gc13(p1312, g1312, c11, c13);
pg_graycell gc12(p12, g12, c11, c12);

//pg_blackcell bc1514(p15, g15, p14, g14, p1514, g1514);
//pg_blackcell bc1512(p1514, g1514, p1312, g1312, p1512, g1512);
//pg_blackcell bc158(p1512, g1512, p118, g118, p158, g158);
//pg_graycell gc15(p158, g158, c7, cout);
pg_graycell gc14(p14, g14, c13, c14);

// Add
assign q[0] = a[0] ^ b[0];
//adder a0(a[0], b[0], cin, q[0]);
adder a1(a[1], b[1], c0, q[1]);
adder a2(a[2], b[2], c1, q[2]);
adder a3(a[3], b[3], c2, q[3]);
adder a4(a[4], b[4], c3, q[4]);
adder a5(a[5], b[5], c4, q[5]);
adder a6(a[6], b[6], c5, q[6]);
adder a7(a[7], b[7], c6, q[7]);
adder a8(a[8], b[8], c7, q[8]);
adder a9(a[9], b[9], c8, q[9]);
adder a10(a[10], b[10], c9, q[10]);
adder a11(a[11], b[11], c10, q[11]);
adder a12(a[12], b[12], c11, q[12]);
adder a13(a[13], b[13], c12, q[13]);
adder a14(a[14], b[14], c13, q[14]);
adder a15(a[15], b[15], c14, q[15]);

endmodule
