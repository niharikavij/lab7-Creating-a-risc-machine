module lab7_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 1; #5;
    KEY[0] = 0; #5;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    // check if program from Figure 6 in Lab 7 handout can be found loaded in memory
	  if (DUT.MEM.mem[0] !== 16'b1101000000000010)begin err = 1; $display("FAILED: mem[0] wrong"); $stop; end
	  if (DUT.MEM.mem[1] !== 16'b0110000010000011)begin err = 1; $display("FAILED: mem[1] wrong"); $stop; end
	  if (DUT.MEM.mem[2] !== 16'b1101001100000010)begin err = 1; $display("FAILED: mem[2] wrong"); $stop; end
	  if (DUT.MEM.mem[3] !== 16'b1000000001100010)begin err = 1; $display("FAILED: mem[2] wrong"); $stop; end
	  if (DUT.MEM.mem[5] !== 16'b1000000000000000)begin err = 1; $display("FAILED: mem[2] wrong"); $stop; end

    #10; // wait until next falling edge of clock
	  
    KEY[1] = 1'b1; // reset de-asserted
	  
    #10; // waiting for RST state to cause reset of PC

    
    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X

    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 2 *after* executing MOV R0, X

    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2."); $stop; end
	  if (DUT.CPU.DP.REGFILE.R4 !== 16'b1000000000000000) begin err = 1; $display("FAILED: R4 should be value in R5."); $stop; end  

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 3 *after* executing LDR R1, [R0]

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 3."); $stop; end
	  if (DUT.MEM.mem[5] !== 16'0000000000000010) begin err = 1; $display("FAILED: memory should be 2 (value stored in R3"); $stop; end

   
    if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule
