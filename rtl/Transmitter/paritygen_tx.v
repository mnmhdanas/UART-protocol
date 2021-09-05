
  module paritygen_tx(i_datain,i_load,o_parity);
     input [7:0] i_datain;
	 input i_load;
	 output reg o_parity;
	  
	 always@(i_load,i_datain)
        begin
		    if(i_load)
			   o_parity = ^ (i_datain) ; // reduction operation of XOR
        end    		  
  endmodule
  