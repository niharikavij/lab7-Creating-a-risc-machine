module lab7_tb();
  reg clk,write,reset;


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
	
	
	
	$stop;

end 


endmodule
