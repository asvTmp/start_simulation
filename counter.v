`timescale 1ns / 1ns
module counter (
    input wire clk, 
    input wire reset,
    output wire [7:0] count
);

    reg [7:0] count_r;
    always @ (posedge clk or posedge reset)
        if (reset)
            count_r = 8'h00;
        else
            count_r <= count_r + 8'h01;
    
    assign count = count_r;

endmodule