

   module UARTtb();
   
   
   reg [7:0]Txdatain;
   reg clk,Txstart,reset;
   wire  Txdataout;
   wire [7:0]Rxdataout;
   

	   
	   
	   
	   
	   
	   
   transmitter  TxDUT(.i_Txstart(Txstart),
                      .i_clk(clk),
					  .i_reset(reset),
					  .i_datain(Txdatain),
                      .o_Txdataout(Txdataout));
					 
   receiver     RxDUT(.i_datain(Txdataout),
                      .i_clk(clk),
					  .i_reset(reset),
                      .o_dataout(Rxdataout));			

    task resett();
	 begin
	     @(negedge clk)
			reset = 0;
	     @(negedge clk)
             reset = 1;  	 
	 end
    endtask
	
	
	initial
        begin
		   
		   clk = 1'b0;
		   forever #5 clk = ~ clk;
		end
				  
				  
	initial  
        begin
             
			resett;
		  		     
		   #18 Txstart=1; Txdatain=8'b10010101; 
		   #100 Txstart = 0;
		   
	       #944 Txstart=1; Txdatain=8'b10111001; 
		   #100 Txstart = 0;
	       #944 Txstart=1; Txdatain=8'b11000011;
		   #100 Txstart = 0;
	       #944 Txstart=1; Txdatain=8'b11001100;
		   #100 Txstart = 0;
	 
           #1000 $finish;  

	    end
    	
	endmodule			  