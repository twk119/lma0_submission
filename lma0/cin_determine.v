// Combinational logic for the operation of the carry in
module cin_det(
	input [1:0] cin_instr,
	input cmsb,
	input cout,
	output reg cin
);

always @ (*)
begin
	case (cin_instr[1:0])
	2'b00:
		cin = 0;
	2'b01:
		cin = 1;
	2'b10:
		cin = cmsb;
	2'b11:
		cin = cout;
	endcase
end

endmodule
