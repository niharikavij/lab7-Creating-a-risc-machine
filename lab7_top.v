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

	cpu CPU(.clk(~KEY[0]),.reset(~KEY[1]),read_data,mem_cmd,mem_addr,write_data);
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

module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

  always @(*) begin 
  	case(in) 
		4'b0000: segs = 7'b1000000; // display 0 
		4'b0001: segs = 7'b1111001; // display 1
		4'b0010: segs = 7'b0100100; // display 2 
		4'b0011: segs = 7'b0110000; // display 3 
		4'b0100: segs = 7'b0011001; // display 4 
		4'b0101: segs = 7'b0010010; // display 5 
		4'b0110: segs = 7'b0000010; // display 6 
		4'b0111: segs = 7'b1111000; // display 7 
		4'b1000: segs = 7'b0000000; // display 8 
		4'b1001: segs = 7'b0011000; // display 9 
		4'b1010: segs = 7'b0001000;//display 10-A
		4'b1011: segs = 7'b0000011;//display 11-b
		4'b1100: segs = 7'b1000110;//display 12-C
		4'b1101: segs = 7'b0100001;//display 13-d
		4'b1110: segs = 7'b0000110;//display 14-E
		4'b1111: segs = 7'b0001110;//display 15-F
		default: segs = 7'b1000000;  // display nothing 
	endcase
  end 
