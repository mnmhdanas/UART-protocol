

  module fsm_tx(i_Txstart,i_clk,i_reset,i_countreached,
                o_shift,o_load,o_sel_1,o_sel_0,o_startcounter,o_resetcounter);

   input i_Txstart,i_clk,i_reset,i_countreached;
   output reg o_load,o_resetcounter,o_sel_0,o_sel_1,o_shift,o_startcounter;

   parameter IDLE   = 3'b000,
             START  = 3'b001,
             DATA   = 3'b010,
             PARITY = 3'b011,
             STOP	= 3'b100;

   reg [2:0] PS,NS;


   //------ Present state logic -------------
   always@(posedge i_clk,negedge i_reset)   
      begin
	      if(!i_reset)
		      PS <= IDLE;
          else
              PS <= NS;		  
      end	  
	  
	//------ Next state decoder logic -------------
    always @ (PS,i_Txstart,i_countreached)
       begin

		 case(PS)
		    IDLE    :   NS = (i_Txstart) ? START : IDLE;
			
			START   :   NS = DATA;
			
			DATA    :   NS = (i_countreached) ? PARITY : DATA;
			
			PARITY  :   NS = STOP;
			
			STOP    :   NS = IDLE;
			
			default :   NS = IDLE;
		 endcase
        end	   
	
    //------ Output logic -------------	
	always @ (posedge i_clk)
        begin
		   case(PS)
		    IDLE    :   begin
			               o_sel_1 = 1'b1;
                           o_sel_0 = 1'b1;   // to assign one(stopBit) to output		
                           if(i_Txstart)
						     begin
							    o_resetcounter = 1'b1;
                                o_load = 1'b1;
                             end								
			            end
			
			START   :   begin
			               o_sel_1 = 1'b0;
                           o_sel_0 = 1'b0;   // to assign zero(startBit) to output	
			               o_shift = 1'b1;
						   o_load  = 1'b0;
						   o_startcounter = 1'b1;
						   o_resetcounter = 1'b0;
			            end
			
			DATA    :   begin
			               o_sel_1 = 1'b0;
                           o_sel_0 = 1'b1;   // to assign data to output	
			               if(!i_countreached)
						     begin
						       o_startcounter = 1'b1;
							   o_shift = 1'b1;
							 end  
					    end
			
			PARITY  :   begin
			              o_sel_1 = 1'b1;
                          o_sel_0 = 1'b0;   // to assign parity to output	
			            end
			
			STOP    :   begin
			              o_sel_1 = 1'b1;
                          o_sel_0 = 1'b1;   // to assign one(stopBit) to output	
			            end
			
			default :   begin
			               o_sel_1 = 1'b1;
						   o_sel_0 = 1'b1;
						   o_load  = 1'b0;
						   o_shift = 1'b0;
						   o_startcounter = 1'b0;
						   o_resetcounter = 1'b1;
                        end		
           endcase			
		end
		
   endmodule
		