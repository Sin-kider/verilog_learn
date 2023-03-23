module encode83 (
    input [7:0] in,
    input en,
    output reg [2:0] out
);
    always @(in or en) begin
        if (en) begin
            for (integer i = 0; i < 8; i = i + 1) begin
                if (in[i] == 1) begin
                    out = i[2:0];
                end
            end
        end
        else begin
            out = 0;
        end
    end 
endmodule

module seg(
  input [2:0] in,
  output [7:0] seg
);
    MuxKey #(8, 3, 8) MuxKey_1(seg, in, {
        3'b000, 8'b00000011,
        3'b001, 8'b10011111,
        3'b010, 8'b00100101,
        3'b011, 8'b00001101,
        3'b100, 8'b10011001,
        3'b101, 8'b01001001,
        3'b110, 8'b01000001,
        3'b111, 8'b00011111
    });
endmodule