module shift(
	input [15:0] in,
	input en,
	output reg [15:0] front,
	output reg [15:0] back
);

// Splits the bits to their MSB and LSB components:
// Because we multiply and get [24:9] of the [31:0] number.
// Shift to the relevant positions.

always @*
begin
	if (en) begin
		front[7:0] = in[15:8];
		front[15:8] = 8'b0;
		back[7:0] = 8'b0;
		back[15:8] = in[7:0];
	end else begin
		front= 16'b0;
		back = in;
	end
end

endmodule