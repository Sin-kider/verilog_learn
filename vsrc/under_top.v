module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,key_count,key_down);
    input clk,clrn,ps2_clk,ps2_data;
    output reg [7:0] data,key_count;
    output reg key_down;
    reg [9:0] buffer; // ps2_data bits
    reg [3:0] count; // count ps2_data bits
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync;
    reg keyup_flag;
    always @(posedge clk) begin
       ps2_clk_sync <= {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
       if (clrn == 0) begin // reset
          count <= 0; 
       end else begin
          if (sampling) begin
             if (count == 4'd10) begin
                if ((buffer[0] == 0) && // start bit
                    (ps2_data) && // stop bit
                    (^buffer[9:1])) begin // odd parity
                    data <= buffer[8:1]; // kbd scan code
                    if (buffer[8:1] == 8'hF0) begin
                        key_count <= key_count + 1;
                        keyup_flag <= 1;
                    end
                    else begin
                        if (keyup_flag == 1) begin
                            key_down <= 0;
                            keyup_flag <= 0;
                        end
                        else begin
                            key_down <= 1;
                        end
                    end
                end
                count <= 0; // for next
             end else begin
                buffer[count] <= ps2_data; // store ps2_data
                count <= count + 3'b1;
             end
          end
       end
    end

endmodule


module seg(
  input [4:0] in,
  output reg [7:0] seg
);
    always @(*) begin
        case (in)
            5'b10000: seg = 8'b0000_0011;
            5'b10001: seg = 8'b1001_1111;
            5'b10010: seg = 8'b0010_0101;
            5'b10011: seg = 8'b0000_1101;
            5'b10100: seg = 8'b1001_1001;
            5'b10101: seg = 8'b0100_1001;
            5'b10110: seg = 8'b0100_0001;
            5'b10111: seg = 8'b0001_1111;
            5'b11000: seg = 8'b0000_0001;
            5'b11001: seg = 8'b0000_1001;
            5'b11010: seg = 8'b0001_0001;
            5'b11011: seg = 8'b1100_0001;
            5'b11100: seg = 8'b0110_0011;
            5'b11101: seg = 8'b1000_0101;
            5'b11110: seg = 8'b0110_0001;
            5'b11111: seg = 8'b0111_0001;
            default: seg = 8'b1111_1111;
        endcase
    end
endmodule