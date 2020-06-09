module alu_decode(
	input [15:0] instr,	// Current instruction
	input carrystatus,	// Status of Carry DFF
	input RsMSB,			// MSB of Rs
	input [15:0] din,		// Data in
	
	output invert,			// Add or subtract control to adder
	output carryen,		// Write enable for the Carry DFF
	output carry_in,
	
	output addload,		// load with the adder output or din?
	output aluread,		// should result returned from datapath be taken from ALU or registers?
	output addmov,			// MOV is implemetned as letting rd=0 and then taking the addition.
	output addshift,		// should output be XSR or addition?
	
	output [15:0] imm,	// immediate val for ADDI/SUBI
	output regImm,			// choose between Rd+Rs or Rd+Imm
	output regOffset,		// choose between Rd+Rs or Rs+offset
	
	output mul_en,			// Enable the whole multiplier
	output mul_msb,		// If we are evaluating full 32-bit or truncated 16-bit vals
	output mul_rst			// Reset the multiplier state machine; just pull low when not multiplying.
);

wire [6:0]inst = instr[15:9];
wire [2:0]cin = instr[8:6];

// cin values
wire C0 = (~cin[2] & ~cin[1]);	//00
wire C1 = (~cin[2] & cin[1]);		//01
wire CMSB = (cin[2] & ~cin[1]);	//10
wire CC = (cin[2] & cin[1]);		//11

wire s = cin[0];

// R Opcodes
wire rType = ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3];	//0000
wire ADD = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & ~inst[0] );	//0000000
wire SUB = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & inst[0] );		//0000001
wire MOV = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & ~inst[0] );		//0000010
wire XSR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & inst[0] );	   //0000011
wire LCG = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] );		//0000100
wire LDR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & inst[0] );	   //0000101
wire STR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & inst[1] & ~inst[0] );	   //0000110
//wire MUL16 = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] & C0 );		//0000100 00
wire LCG16 = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] & C1 );			//0000100 01
wire MUL32 = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] & CMSB );		//0000100 10
wire MAC = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] & CC );			//0000100 11

// I Opcodes
wire ADDI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & ~inst[1] );	//000100
wire SUBI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & inst[1] );	//000101

// Jump opcodes
wire JAL =  ( inst[6] & inst[5] & ~inst[4] );	// 110 Means $RA = din+1.
//wire JR =  ( inst[6] & inst[5] & inst[4] );	//111 Is a fancy way of reading $RA. No additional logic here.

// Imm values:
// JAL: Current value of PC
// ADDI/SUBI: 7-bit value in the instruction
// LDR/STR: 3-bit offset in the instruction
// LCG16: 1 always.
assign imm[15:12] = 1'h0;	// imm first 4 bits will always be 0.
assign imm[11:0] = ( {12{JAL}}&din[11:0] ) | {5'b0, {7{(ADDI|SUBI)}}&instr[9:3]} | {9'b0, {3{LDR|STR}}&instr[8:6]} | {11'b0, LCG16&1'b1};

// Only invert when we are meant to subtract
assign invert = SUB | SUBI | LCG16;	
// Carryen is controlled by the s bit.
assign carryen = s & rType;
// carry in as assigned. SUBI is always gonna have a carry in of 1. JAL increments so should have a carry of 1.
// SUBI, LCG16 both decrement, thus requiring cin=1 always. Meanwhile JAL increments.
assign carry_in = ( ~C0 & (C1 | CMSB&RsMSB | CC&carrystatus) )&~(LCG|LDR|STR) | SUBI | JAL | LCG16;
// Regfile input should be ALU result after a mathematical operation.
assign addload = ADD | SUB | MOV | XSR | ADDI | SUBI | JAL | LCG16;
// read from ALU after a mathematical operation
assign aluread = !(ADD | SUB | MOV | XSR | ADDI | SUBI | LDR | STR | LCG16);
// Set rd = 0; for MOV (0+rs) or JAL (0+Imm+c1)
assign addmov = MOV | JAL;
// when xsr
assign addshift = XSR;
// when addi/subi, we pick from imm instead of rs. for JAL, we set Imm = 0
assign regImm = ADDI | SUBI | LDR | STR | JAL | LCG16;
// when we are loading or storing direct...
assign regOffset = LDR | STR;

// Enable multiplier
assign mul_en = LCG;
assign mul_msb = MUL32 | MAC;
assign mul_rst = !LCG;

endmodule
