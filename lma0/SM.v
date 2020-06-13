module SM (
	input [15:0] a_in,
	input [15:0] b_in,
	input [1:0] state,
	input en,					// Enable input
	input MSB,					// control input; HIGH if include the MSBs are to be calculated.
	output [7:0] a_mul,		// Operands to be multiplied (A[15:8]/A[7:0])
	output [7:0] b_mul,		// operands to be multiplied (B[15:8]/B[7:0])
	output [1:0] nextstate,	// Next State Output
	output shiften,			//	Shifts the product 8 bits to the left.
	output backregload,		//	(LSB) - Write to the LSB register-GP3; but only if need the full MSB precision
	output frontregload,		// (MSB) - Write to the MSB register-GP2
	output addcin,				// 
	output [1:0] muxs,		// [1:0]. 00-GND; 01-cout; 10-front shifted 16 bits; 11-product.
	output reset,				// ACLR GP2 if we are using it to store the MSBs of the product. Should we leave this to the programmmer?
	output last,				// goes HIGH for the last state and idle state
	output idle					// LOW when in stateidle
);

wire state00en = ~state[0]&~state[1]&en;
wire stateidle = ~state[0]&~state[1]&~en;
wire state01 = state[0]&~state[1];
wire state10 = ~state[0]&state[1];
wire state11 = state[0]&state[1];

//values that will be inputted into the 8-bit multiplier
assign a_mul = (a_in[15:8]&{8{state00en|state11}}) | (a_in[7:0]&{8{state01|state10}});
assign b_mul = (b_in[15:8]&{8{state01|state11}}) | (b_in[7:0]&{8{state00en|state10}});

//next state
assign nextstate = (2'b01&{2{state00en}}) | (2'b10&{2{state01}}) | (2'b11&{2{state10&MSB}});

//shift enable for the shift block
assign shiften = state10;

//sload of LSB and MSB register respectively
assign backregload = state00en|state01|state10;
assign frontregload = (state01|state10|state11)&MSB;

//enable of cin of adder in MSB reg
assign addcin = state10&MSB;

//mux select of MSB reg 00-GND; 01-shifted cout; 10-shfited LSB; 11-product
assign muxs = state&{2{MSB}};

//reset of MSB register in 32bit result
//should only reset when MSB HIGH but is don't care as it will not be connected to the register when its LOW
assign reset = state00en;

//tell external hardware that this is the last cycle of multiplication
//can sload value
assign last = stateidle|(state10&~MSB)|state11;

//tell external hardware that it is in idle state
//goes low in idle to disable sload
assign idle = ~stateidle;

endmodule
