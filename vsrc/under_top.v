module mux241 (
    input [7:0] X,
    input [1:0] Y,
    output [1:0] F
);
    MuxKey #(4, 2, 2) i0 (F, Y, {
        2'b00, X[1:0],
        2'b01, X[3:2],
        2'b10, X[5:4],
        2'b11, X[7:6]
    }); // #(4, 2, 2) 4个键值对 2位输入 2位输出
endmodule