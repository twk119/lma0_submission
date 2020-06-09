module ctrl_en_counter(
	input en,
	input last,
	input loop,
	input EQLT,
	input idle,
	
	output wire en_mul,	//HIGH at last multiplication cycle 
	output multilast,
	output GP1_en,
	output GP3_en
);

assign en_mul = en&last;
assign multilast = (EQLT|~loop)&last&idle;
assign GP1_en = last&(~EQLT|~loop)&idle;
assign GP3_en = loop&~EQLT&en_mul&idle;

endmodule
