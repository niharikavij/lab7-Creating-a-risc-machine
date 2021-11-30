module lab7_top(clk,reset,write);
input clk, reset, write; 

wire [1:0]mem_cmd;
wire [8:0]mem_addr;
wire [15:0]read_data,dout,din;
wire [8:0]write_address,read_address; 
wire write,clk;

cpu CPU(clk,reset,read_data,mem_cmd,mem_addr);
RAM MEM(clk,read_address,write_address,write,din,dout);

assign read_address = mem_addr;
assign write_address = mem_addr; 
assign read_data = ((mem_cmd == 2'b01) & (mem_addr[8] == 1'b0)) ? dout : {16{1'bz}};

endmodule
