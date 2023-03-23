module top (
    input clk,
    input rst,
    input [15:0] sw,
    input [4:0] button,
    input ps2_clk,
    input ps2_data,
    output [15:0] ledr,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output [7:0] seg0,
    output [7:0] seg1,
    output [7:0] seg2,
    output [7:0] seg3,
    output [7:0] seg4,
    output [7:0] seg5,
    output [7:0] seg6,
    output [7:0] seg7
);
    reg [7:0] data,key_count;
    reg key_down;
    seg seg_1({key_down,data[3:0]}, seg0);
    seg seg_2({key_down,data[7:4]}, seg1);
    seg seg_3({key_down,key_count[3:0]}, seg2);
    seg seg_4({key_down,key_count[7:4]}, seg3);
    ps2_keyboard ps2_keyboard_1(
      .clk(clk),
      .clrn(~rst),
      .ps2_clk(ps2_clk),
      .ps2_data(ps2_data),
      .data(data),
      .key_count(key_count),
      .key_down(key_down)
   );
endmodule
