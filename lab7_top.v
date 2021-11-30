module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [3:0] KEY;
input [9:0] SW;
output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

wire [1:0]mem_cmd;
wire [8:0]mem_addr;
wire [15:0]read_data,dout,din;
wire [8:0]write_address,read_address; 
wire write,clk;

cpu CPU(clk,reset,read_data,mem_cmd,mem_addr);
RAM MEM(.clk(~KEY[0]),.read_address(SW),.read_address(SW),write,din,dout);
tri_state TS(dout, AND_out, read_data);
ANDgate  AND(mem_cmd, mem_addr, AND_out);
endmodule



module tri_state(dout, AND_out, read_data);
  input [15:0] dout;
  input AND_out;
  output [15: 0] read_data;
  
  assign read_data = (AND_out) ? dout : {16{1'bz}};
  
endmodule


module ANDgate(mem_cmd, mem_addr, AND_out);
  input [1:0] mem_cmd;
  input [8:0] mem_addr;
  output wire AND_out;
  
  assign AND_out = ((mem_cmd == 2'b01) & (mem_addr[8] == 1'b1))? 1'b1 : 1'b0 ;
endmodule 
