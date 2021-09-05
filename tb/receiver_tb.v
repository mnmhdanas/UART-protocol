
  module receiver_tb();
  
  reg i_datain,i_clk,i_reset;
  wire [7:0] o_dataout;
  
  receiver DUT(i_datain,i_clk,i_reset,o_dataout);
  
        initial
		   begin
		   i_clk = 1'b1;
		   forever #5 i_clk = ~i_clk;
		   end
		   
		task initialize_t();
		    begin
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
		
				
				  
		initial 
			   begin
			      initialize_t;
				  reset_t;
				  #50; 
				  
				  
				  

				  
				  #1200 $finish;
			   end
			   
			   
		 initial 
                begin
				  #50     i_datain = 1'b0;
				  
				  #80     i_datain = 1'b0;
				  #80     i_datain = 1'b1;
				  #80     i_datain = 1'b0;
				  #80     i_datain = 1'b1;
				  #80     i_datain = 1'b1;
				  #80     i_datain = 1'b0;
				  #80     i_datain = 1'b1;
				  #80     i_datain = 1'b1;  //0 01011011 1   11011010
				  
				  #80     i_datain = 1'b0;
				  #80     i_datain = 1'b1;
                end				
		endmodule
		
