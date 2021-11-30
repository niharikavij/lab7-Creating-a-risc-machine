module lab7_tb();
  reg clk,write,reset;
  reg [1:0] read_address, write_address;
  reg [15:0] din;
  reg [15:0] dout;
  reg [15:0] read_data;
  reg [1:0] mem_cmd;
  reg [8:0] mem_addr;

lab7_top DUT(clk,reset, write);
initial begin 
	clk = 0;
	reset = 1;
	#5;
	clk = 1;
	#5;
	clk = 0;
	#5;
	reset = 0; 
	clk = 1;
	#5;
	clk = 0; 
	#5;
	clk = 1;
	#5;
	clk = 0; 
	#5;
	clk = 1;
	#5;
	clk = 0; 
	#5;
	clk = 1;
	#5;
	clk = 0; 
	$stop;

end 


endmodule


