module reg_addr(
	input [15:0] memout,	
	input [15:0] instr,
	input [10:0] pcOut,
	output [2:0] r0addr,
	output reg [15:0] din
);

// Different kinds of instruction
wire rType = ~instr[15] & ~instr[14] & ~instr[13] & ~instr[12];	// 0000
wire LCG = ~instr[15] & ~instr[14] & ~instr[13] & ~instr[12] & instr[11] & ~instr[10] & ~instr[9];			//0000100
wire iType = ~instr[15] & ~instr[14] & ~instr[13] & instr[12];		// 0001
wire lType = ~instr[15] & instr[14]; 	// 01
wire jEQLT = instr[15] & ~instr[14] ; // 10x
wire jALR = instr[15] & instr[14]; // 11x

// But also remember that LCG will always r/w to GP3.

// write r0 depending on the kind of instruction. r0 = rd
// {} is bit concatenation operator
// JEQ/JLT: reg addr 0xx. JAL/JR: reg addr 111 always. (Return Address)
assign r0addr = {3{rType&~LCG|iType}}&instr[2:0] | {3{lType|jEQLT}}&{1'b0,instr[1:0]} | {3{jALR}}&3'b111 | {3{LCG}}&3'b011 ;

// din: used for LDA / LDR / LDI / ADDI / SUBI and JAL; but JAL would be taking from pcOut isntead of memout.
// Sign extension occurs @ LDI.
// use the casez function allows us to don't care the value of instr bit 10 (ADDI/SUBI)
always @ (*)
begin
	casez (instr[15:10])
		6'b000110:	// LDI
			din = {{9{instr[9]}},instr[9:3]};
		6'b00010?:	// ADDI/SUBI
			din = {9'b000000000,instr[9:3]};
		6'b110???:	// JAL
			din = {5'b0000, pcOut};
		default:
			din = memout;
	endcase
end

endmodule
