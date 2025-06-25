`timescale 1ns / 1ns
module tb_counter;

logic clk, reset;
logic [7:0] count;

counter dut (
    .clk(clk),
    .reset(reset),
    .count(count)
);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end
  
initial	// Test stimulus
  begin
    reset = 0;
    #5 reset = 1;
    #49 reset = 0;
    #1;
    #200;
    $stop();
  end
  
initial
    $monitor("[$monitor] time=%0t reset=%b clk=%b count=0x%02h" ,$stime, reset, clk, count); 
    
endmodule 