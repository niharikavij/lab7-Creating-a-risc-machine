module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [3:0] KEY;
input [9:0] SW;
output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

wire [1:0]mem_cmd;
wire [8:0]mem_addr;
wire [15:0]dout,write_data,datapath_out,mdata;
reg [8:0]write_address,read_address; 
wire clk;

reg [15:0]read_data,din;
reg write;

cpu CPU(clk,reset,read_data,mem_cmd,mem_addr,write_data);
RAM MEM(clk,read_address,write_address,write,din,dout);
always @(*)begin
	read_address = mem_addr;
	write_address = mem_addr; 
	write = ((mem_cmd == 2'b10) & (mem_addr[8] == 1'b0)) ? 1'b1 : 1'b0;
	read_data = ((mem_cmd == 2'b01) & (mem_addr[8] == 1'b0)) ? dout : {16{1'bz}};
	din = write_data;
end 

always@(*) begin
	if (mem_addr == 9'h100)begin
		if(mem_cmd == 2'b10) begin
			LEDR[7:0] = write_data;
		end
		else LEDR[7:0] = LEDR[7:0];
	end
	else LEDR[7:0] = LEDR[7:0];
end
	
always @(*) begin
	load_input = ((mem_cmd == 2'b01) & (mem_addr == 9'h140)) ? 1'b1 : 1'b0;
	read_data [7:0] = (load_input == 1'b1) ? SW[7:0] : read_data;
	read_data [15:8] = (load_input == 1'b1) ? {8'h00} : read_data; 
	
end 
endmodule				
