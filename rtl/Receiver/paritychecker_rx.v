
  module paritychecker ( i_datain,i_zerodetected,i_onedetected,
                         o_parityerror );
	
	input i_onedetected,i_zerodetected;
	input [7:0]i_datain;
	output reg o_parityerror;
	
	wire parity = ^(i_datain);
	
	always@(parity,i_onedetected,i_zerodetected)
	   begin
	      if(( parity && i_zerodetected ) || ( !parity && i_onedetected ))
		     o_parityerror = 1'b1;
          else 
             o_parityerror = 1'b0;  
	    end
	
  endmodule
  