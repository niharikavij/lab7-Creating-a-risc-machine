module RAM(clk,read_address,write_address,write,din,dout);
  parameter data_width = 32; 
  parameter addr_width = 4;
  parameter filename = "data.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule
 
module PC(next_pc, pc_out, load_pc, clk); // logic for program counter
  input [8:0] next_pc;
  input load_pc, clk;
  output reg [8:0] pc_out;
  
  always@(posedge clk) begin //dependent on clock
   pc_out = (load_pc) ? next_pc: pc_out;
  end 
  
endmodule

module Mux_pc(pc_out, reset_pc, next_pc); // logic for multiplexer before the PC
  input [8:0] pc_out;
  input reset_pc;
  output wire [8:0] next_pc;
  
  assign next_pc = (reset_pc) ? 8'b00000000 : (pc_out + 1'b1) ; // when reset  = 0 , value going int0 PC is incremented, such that PC stores address of next instruction

endmodule

module Mux_memory(pc_out, addr_sel, mem_addr);
  input [8:0] pc_out;
  input addr_sel;
  output wire [8:0] mem_addr;
  
  assign mem_addr = (addr_sel)? pc_out : 8'b00000000;
endmodule