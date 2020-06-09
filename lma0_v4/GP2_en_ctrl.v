module GP2_en_ctrl(
	input mul_GP2_en,
	input GP5,
	input MSB,
	output GP2_en
);

assign GP2_en = (MSB|GP5)&mul_GP2_en;

endmodule