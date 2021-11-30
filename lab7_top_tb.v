module lab7_to_tb();
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  
  lab7_top DUT(
