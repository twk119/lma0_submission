module loopInstruction (
	input [15:0] prevInstr,
	input loopCondition,
	
	output sel
);

/* If the previous instruction was a LCG-type and requires looping, 
and the loop exit condition has not been met, then we know that
we need to take the instruction from IR.
*/

wire LCG = ( ~prevInstr[6] & ~prevInstr[5] & ~prevInstr[4] & ~prevInstr[3] & 
				prevInstr[2] & ~prevInstr[1] & ~prevInstr[0] );		//0000100

assign sel = LCG & ~loopCondition;

endmodule
