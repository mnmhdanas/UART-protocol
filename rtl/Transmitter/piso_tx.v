
   module piso_tx(i_datain,i_shift,i_load,i_clk,
                  o_serialdata);
				  
				  
		input [7:0] i_datain;
		input i_clk,i_load,i_shift;
		output reg o_serialdata;
		
		reg [7:0] tempreg;
		
		always@(posedge i_clk)
		   begin
		     if(i_load)
			     tempreg <= i_datain;
		     else if(i_shift)
                begin
				   o_serialdata <= tempreg[0];
				   tempreg      <= tempreg >> 1;
                end				
		   end
	endmodule
	