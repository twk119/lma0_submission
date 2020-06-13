module pipelined_ALU_decoder (
	input [15:0] instr,	// Current instruction
	input carrystatus,	// Status of Carry DFF
	input RsMSB,			// MSB of Rs
	input [15:0] din,		// Data in
	input loadIn,			// last instr a load?
	input [2:0] Rd,		// Current registers
	input [2:0] Rs,		// 
	input [2:0] RPrev,	
	
	output invert,			// Add or subtract control to adder
	output carryen,		// Write enable for the Carry DFF
	output carry_in,
	
	output addload,		// load with the adder output or din?
	output aluread,		// should result returned from datapath be taken from ALU or registers?
	output addmov,			// MOV is implemetned as letting rd=0 and then taking the addition.
	output xsrSelect,		// should output be XSR or addition?
	output bitSelect,		// output be Bitwise or addition?
	
	output load,			// Save current load for next cycle
	output RdGetFromRAM,	// if past instr was a load, bad things will happen.
	output RsGetFromRAM,	// 
	
	output [15:0] imm,	// immediate val for ADDI/SUBI
	output regImm,			// choose between Rd+Rs or Rd+Imm
	output regOffset,		// choose between Rd+Rs or Rs+offset
	
	output mul_en,			// Enable the whole multiplier
	output MUL,				// GP5 is don't care
	output loop,			//	Loop will not occur/ GP3 is don't care
	output MSB				// MSB of product 
);

wire [6:0]inst = instr[15:9];
wire [2:0]cin = instr[8:6];

// cin values
wire C0 = (~cin[2] & ~cin[1]);	//00
wire C1 = (~cin[2] & cin[1]);		//01
wire CMSB = (cin[2] & ~cin[1]);	//10
wire CC = (cin[2] & cin[1]);		//11

// R Opcodes
wire ADD = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & ~inst[0] );	//0000000
wire SUB = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & inst[0] );		//0000001
wire MOV = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & ~inst[0] );		//0000010
wire XSR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & inst[0] );	   //0000011
wire LCG = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] );		//0000100
wire LDR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & inst[0] );	   //0000101
wire STR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & inst[1] & ~inst[0] );	   //0000110
wire BIT = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & inst[1] & inst[0] );	   //0000111
//// LCG variants
//wire LCG_GP5 = instr[8];	// Utilises GP5 for addition/accumulation
//wire LCG_Loop = instr[7];	// Loops more than once
//wire LCG_32 = instr[6];		// 32 or 16-bit product
// BIT variants
//wire NOT = C0;
//wire OR = C1;
//wire AND = CMSB;
//wire XOR = CC;

// I Opcodes
wire ADDI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & ~inst[1] );	//000100
wire SUBI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & inst[1] );	//000101
//wire LDI =  ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & inst[2] & ~inst[1] );	//000110

// STOP Opcodes
//wire STP =  ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & inst[2] & inst[1] );	//000111

// L/S Opcodes
wire LDA = ( ~inst[6] & inst[5] & ~inst[4] );	//010
//wire STA =  ( ~inst[6] & inst[5] & inst[4] );	//011

// J Opcodes
//wire JEQ = ( inst[6] & ~inst[5] & ~inst[4] );	//100
//wire JLT = ( inst[6] & ~inst[5] & inst[4] );		//101
//wire JAL =  ( inst[6] & inst[5] & ~inst[4] );	//110
//wire JR =  ( inst[6] & inst[5] & inst[4] );		//111

/*Assignments*/

// Immediate values
// ADDI/SUBI: 7-bit value in the instruction
// LDR/STR: 3-bit offset in the instruction
// LCG: 1 always.
assign imm[15:12] = 4'b0;	// imm first 4 bits will always be 0.
assign imm[11:0] = {5'b0, {7{(ADDI|SUBI)}}&instr[9:3]} | {9'b0, {3{LDR|STR}}&instr[8:6]} | {11'b0, LCG&1'b1};

// Only invert when we are meant to subtract
assign invert = SUB | SUBI | LCG;

// Carryen is controlled by the s bit.
assign carryen = cin[0] & (ADD|SUB|MOV|XSR|ADDI|SUBI);

// carry in as assigned.
// SUBI, LCG_Loop both decrement, thus requiring cin=1 always.
assign carry_in = ( ~C0 & (C1 | CMSB&RsMSB | CC&carrystatus) )&~(LCG|LDR|STR) | SUBI | LCG;

// Regfile input should be ALU result after a mathematical operation.
assign addload = ADD | SUB | MOV | XSR | BIT | ADDI | SUBI | LCG;

// read from ALU after a mathematical operation
assign aluread = !(ADD | SUB | MOV | XSR | BIT | ADDI | SUBI | LDR | STR | LCG);

// Set rd = 0; for MOV (0+rs) or JAL (0+Imm+c1)
assign addmov = MOV;

// when xsr
assign xsrSelect = XSR;

// when Bitwise
assign bitSelect = BIT;

// when addi/subi, we pick from imm instead of rs. for JAL, we set Imm = 0
assign regImm = ADDI | SUBI | LDR | STR | LCG;

// when we are loading or storing direct, adderDataA = input1.
assign regOffset = LDR | STR;

// consider if past instruction was a load, to get the correct data out.
assign load = LDR | LDA;
assign RdGetFromRAM = loadIn & (Rd==RPrev);	// If Rd = previously loaded register, then take data straight from RAM
assign RsGetFromRAM = loadIn & (Rs==RPrev);

// Enable multiplier.
assign mul_en = LCG;
assign MUL = ~instr[8]&LCG;		//HIGH if GP5 is don't care or in MUL instr
assign loop = instr[7]&LCG;		//HIGH if loop
assign MSB = instr[6]&LCG;			//HIGH if MSB is included

endmodule
