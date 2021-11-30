module cpu(clk,reset,read_data,mem_cmd,mem_addr);
input wire clk, reset;
input [15:0] read_data;

output [1:0] mem_cmd;
output [8:0] mem_addr;

wire[15:0] datapath_out;
wire[2:0] Z_out;
wire write, loada, loadb, loadc, loads, vsel,asel,bsel, load_ir,reset_pc, load_pc, addr_sel;
wire [1:0] shift, ALUop,op;
wire [2:0] nsel,Rd,Rn,Rm,readnum,writenum,opcode;
wire [8:0] next_pc,pc_out;
reg [4:0] imm5;
reg [7:0] imm8;
wire [15:0] sximm8, sximm5,in_out;

ins_register IR(read_data,load_ir,clk,in_out);
ins_decoder ID(in_out,nsel,sximm5,sximm8,opcode,op,shift,ALUop,readnum,writenum);
state_machine SM(reset,clk,opcode,op,write,vsel,loada,loadb,loadc,loads,asel,bsel,nsel,load_pc,reset_pc,load_ir,addr_sel,mem_cmd);
datapath DP(mdata,sximm8,sximm5,vsel,loada,loadb,shift,bsel,asel,ALUop,loads,loadc,clk,writenum,write,readnum,Z_out,datapath_out);
Mux_pc MPC(pc_out, reset_pc, next_pc);
Mux_memory MMEM(pc_out, addr_sel, mem_addr);
PC PC(next_pc, pc_out, load_pc, clk);

assign mdata = read_data;
assign datapath_out = write_data; 
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
