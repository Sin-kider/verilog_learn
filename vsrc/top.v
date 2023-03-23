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
encode83 encode83_1(sw[7:0],sw[8],ledr[2:0]);
seg seg_1(ledr[2:0], seg0[7:0]);
endmodule
