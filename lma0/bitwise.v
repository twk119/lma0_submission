module bitwise(
	input [15:0] Rd,
	input [15:0] Rs,
	input [1:0] opr,
	output reg [15:0] out
);

always @*
begin
	case (opr)
		2'b00:
		out = ~Rd;
		
		2'b01:
		out = Rd | Rs;
		
		2'b10:
		out = Rd & Rs;
		
		2'b11:
		out = Rd ^ Rs;
	endcase
end
	
endmodule
