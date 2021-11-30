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
datapath DP(sximm8,sximm5,vsel,loada,loadb,shift,bsel,asel,ALUop,loads,loadc,clk,writenum,write,readnum,Z_out,datapath_out);
Mux_pc MPC(pc_out, reset_pc, next_pc);
Mux_memory MMEM(pc_out, addr_sel, mem_addr);
PC PC(next_pc, pc_out, load_pc);

endmodule 
