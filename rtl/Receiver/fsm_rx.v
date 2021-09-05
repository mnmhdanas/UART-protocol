
  module fsm_rx(i_parityerror,i_onedetected,i_zerodetected,i_clk,i_reset,i_countreached,
                o_shift,o_startcount,o_resetcounter,o_outputenable);
				
				
		input i_clk,i_countreached,i_parityerror;
        input i_reset,i_onedetected,i_zerodetected;

        output reg o_shift,o_outputenable,o_resetcounter,o_startcount;
		
		parameter IDLE = 2'b00,
		          DATA = 2'b01,
				  PARITYCHECK = 2'b10,
				  STOPCHECK   = 2'b11;
		
        reg [1:0]  PS,NS;

        //-------  Present state logic ------------		
		
		always@(posedge i_clk,negedge i_reset)
		   begin
		        if(!i_reset)
				   PS <= IDLE;
				else 
                   PS <= NS;			
		   end
		   
		//------- Next state logic (decoder) ------------

        always@(PS,i_onedetected,i_zerodetected,i_countreached)
            begin
			   case(PS)
			      IDLE 		  :  begin
				                  if(i_zerodetected)
				                       NS = DATA;
								   else
                                       NS = IDLE;								   
				                  end
				  DATA 		  :  begin
				                  if(i_countreached)
				                       NS = PARITYCHECK;
								   else
                                       NS = DATA;								   
				                  end
				  
				  
				  PARITYCHECK :  NS = STOPCHECK ;
				  STOPCHECK   :  NS = IDLE;
				  default :  NS = IDLE;
				endcase  
            end			
			
			
		//------ Output logic -------------	
	always @ (posedge i_clk)
        begin
		   case(PS)
		    IDLE    :   begin
			               	o_outputenable = 1'b0;			  
			             if(i_zerodetected)
						    begin
                              o_startcount = 1'b1;
							  o_resetcounter = 1'b0;
							  o_shift = 1'b1;
							 
							 end
                         else 
						    o_resetcounter = 1'b1;		
					    end								

			
			DATA    :   begin
			               
						   if(i_countreached)
						     begin
						      o_shift = 1'b0;
							 end 
					    end
			
			STOPCHECK  :   begin
			                   o_shift        = 1'b0;
			                   if(i_onedetected)
							     o_outputenable = 1'b1;
	                        end
					
			default :   begin
			               o_shift        = 1'b0;
						   o_resetcounter = 1'b1;
						   o_startcount   = 1'b0;
						   o_outputenable = 1'b0;
                        end		
           endcase			
		end
		
   endmodule	