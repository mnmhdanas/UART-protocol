

     module sipo_rx(i_onedetected,i_zerodetected,i_baudclk,i_shift,
	                o_parallelout);
	 
	 input i_baudclk,i_onedetected,i_zerodetected,i_shift;
	 output reg [7:0] o_parallelout = 0;
	 
	 always@(posedge i_baudclk)
	    begin
		  if(i_shift && i_onedetected)
		      o_parallelout <= {1'b1,o_parallelout[7:1]};
		  else if(i_shift && i_zerodetected)  
		      o_parallelout <= {1'b0,o_parallelout[7:1]};
		end
		
	 endmodule
	 