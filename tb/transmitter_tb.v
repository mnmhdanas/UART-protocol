
  module transmitter_tb();
       
	   reg i_Txstart,i_clk,i_reset;
	   reg [7:0] i_datain;
	   wire o_Txdataout;
	   
	   transmitter DUT (i_Txstart,i_clk,i_reset,i_datain,
                     o_Txdataout);
					 
	    initial
		   begin
		   i_clk = 1'b1;
		   forever #5 i_clk = ~i_clk;
		   end
		   
		
		task initialize_t();
		    begin
			   i_Txstart = 1'b0;
			   i_clk     = 1'b1;
			   i_reset   = 1'b1;
			end
		endtask
		
		
		task reset_t();
            begin
			   @(negedge i_clk)
			        i_reset = 1'b0;
			   @(negedge i_clk)
			        i_reset = 1'b1;	 
		    end	
        endtask
		
		task assigndata_t(input [7:0] tempdata);
		   begin
		       @(negedge i_clk)
			      i_Txstart = 1'b1;
			      i_datain = tempdata;
				  
				wait(DUT.COUNTER_t.count == 4'b1010)
			   @(negedge i_clk)
			      i_Txstart = 1'b0;
		   end
		endtask   
     		
			
			initial 
			   begin
			      initialize_t;
				  reset_t;
				  #50 
				  assigndata_t({$random}%256);

				  
				  #150 assigndata_t(8'b01011000);

				  #150 assigndata_t({$random}%256);
				  
				  #200 $finish;
			   end
			   
		endmodule
		