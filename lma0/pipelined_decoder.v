// DECODER
module pipelined_decoder(
	input wire [15:0] instr,	// Current opcode
	input wire EQ,
	input wire LT,
	input multLast,	// If the multiplier is on the last stage of multiplication
	
	output pc_sload,	// sload for instruction register
	output pc_cnten,	// enable increment of counter
	output pcInstrReg,	// Take PC input from register or from instruction?

	output dataSelMux,	// to select reading from instructions (0) or from registers (1)
	
	output wr_en,		// Enable writing to RAM content
	output reg_en,		// edits the Regfile

	output clk_en		// disables further clocking after STP.
);

wire [6:0]inst = instr[15:9];
//wire [2:0]cin = instr[8:6];

// R Opcodes
wire ADD = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & ~inst[0] );	//0000000
wire SUB = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & ~inst[1] & inst[0] );		//0000001
wire MOV = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & ~inst[0] );		//0000010
wire XSR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & ~inst[2] & inst[1] & inst[0] );	   //0000011
wire LCG = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0] );		//0000100
wire LDR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & inst[0] );	   //0000101
wire STR = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & inst[1] & ~inst[0] );	   //0000110
wire BIT = ( ~inst[6] & ~inst[5] & ~inst[4] & ~inst[3] & inst[2] & inst[1] & inst[0] );	   //0000111
// LCG variants
//wire LCG_GP5 = instr[8];	// Utilises GP5 for addition/accumulation
//wire LCG_Loop = instr[7];	// Loops more than once
//wire LCG_32 = instr[6];		// 32 or 16-bit product

// Variations

// I Opcodes
wire ADDI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & ~inst[1] );	//000100
wire SUBI = ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & ~inst[2] & inst[1] );	//000101
wire LDI =  ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & inst[2] & ~inst[1] );	//000110

// STOP Opcodes
wire STP =  ( ~inst[6] & ~inst[5] & ~inst[4] & inst[3] & inst[2] & inst[1] );	//000111

// L/S Opcodes
//wire LDA = ( ~inst[6] & inst[5] & ~inst[4] );	//010
wire STA =  ( ~inst[6] & inst[5] & inst[4] );	//011

// J Opcodes
wire JEQ = ( inst[6] & ~inst[5] & ~inst[4] );	//100
wire JLT = ( inst[6] & ~inst[5] & inst[4] );		//101
wire JAL =  ( inst[6] & inst[5] & ~inst[4] );	//110
wire JR =  ( inst[6] & inst[5] & inst[4] );		//111

/* output assignments */
// We would only loop if the current opcode is correct and the clearing condtions are not met:
// - If the 'loop' instr bit is set
// - If we reach multLast on a non-looped operation, we know we can go to FETCH
//assign loopStart = (LCG & LCG_Loop & ~EQ) | (LCG & ~LCG_Loop & ~multLast);
//assign loopStart = (LCG & LCG_Loop & ~LT) | (LCG & ~LCG_Loop & (~multLast|~prevMult));

// We only want to load PC during jumps.
// JAL and JR are unconditional jumps, no condition requried for prefix.
// JEQ and JLT are conditional.
assign pc_sload = JEQ&EQ | JLT&LT | JAL | JR ;

// We will want to count up the PC when not in STP.
// JEQ and JLT are conditional jumps so PC should count up when condition not met.
// Do not increment PC when we are looping!
assign pc_cnten = !(STP | JEQ&EQ | JLT&LT | LCG&~multLast);

// Only time we load instruction to PC from register $ra is during JR.
assign pcInstrReg = JR;

// Choose register output for address of data memory in these cases.
assign dataSelMux = LDR | STR;

// Enable writing to RAM content, only occurs during STA.
assign wr_en = STA | STR;

// enables editing of register file, when an assignment needs to be made.
// Only increment GP3 when multLast is high, for a LCG16 instruction.
// Other LCG instructions do not require GP3.
assign reg_en = ADD|SUB|XSR|MOV|BIT|ADDI|SUBI|LDI|JAL;

// disable clocking after STP, but if skip is high, we don't need to stop
 assign clk_en = ~STP;

endmodule
