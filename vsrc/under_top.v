module ALU (
    input wire signed [3:0] a,
    input wire signed [3:0] b,
    input [2:0] cmd,
    output reg signed [3:0] out
);
always @(*) begin
    case (cmd)
        3'b000: out = a + b;
        3'b001: out = a - b;
        3'b010: out = ~a;
        3'b011: out = a & b;
        3'b100: out = a | b;
        3'b101: out = a ^ b;
        3'b110: out = (a < b) ? 1 : 0;
        3'b111: out = (a == b) ? 1 : 0;
        default: out = 0;
    endcase
end
endmodule