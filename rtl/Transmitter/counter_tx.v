 
  module counter_tx(i_reset,i_clk,i_up,
                    o_countreached);
					
	input i_clk,i_reset,i_up;
    output o_countreached;	
					
     reg [3:0]  count;
	 assign o_countreached = !count[3]&(count[2])&(count[1])&(count[0]);   //8 - 1000
	 always@(posedge i_clk, posedge i_reset)  //for counter module ,reset is active high
	   begin
	      if(i_reset)
	         count <= 4'b0000;
	      else if(i_up)
	         count <= count + 1'b1;			
		end
   endmodule
   