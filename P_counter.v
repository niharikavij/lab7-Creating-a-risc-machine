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

module memory(pc_out, addr_sel, mem_addr, clk, datapath_out, load_addr);
  input [8:0] pc_out;
  input addr_sel, clk;
  input load_addr;
  input [15:0]datapath_out;
  output wire [8:0] mem_addr;
  reg [8:0] mux_in;
 

  always@(posedge clk)begin
  mux_in = (load_addr) ? datapath_out[8:0] : mux_in;
  end

assign mem_addr = (addr_sel)? pc_out : mux_in;
endmodule 