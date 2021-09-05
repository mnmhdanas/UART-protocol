
  
 
  module transmitter(i_Txstart,i_clk,i_reset,i_datain,
                     o_Txdataout);
					 
	input i_Txstart,i_clk,i_reset;
    input [7:0] i_datain;
    output o_Txdataout;
	
	parameter startBit = 1'b0,
	          stopBit  = 1'b1;
	

    wire countreached,shift,load,sel_1,sel_0,startcounter,resetcounter; // fsm intermediate signals
	wire serial_dataout; // piso intermediate signal
	wire parityBit ; // Paritygen  intermediate signal
	
	
    //-------- Baud clock generator ----- F/8 of i_clk -----
	
	reg [2:0] count_clk; 
	wire baud_clk;
	assign baud_clk = (count_clk[2] == 1);
	
	always@(posedge i_clk,negedge i_reset)
	   begin
	      if(!i_reset)
		      count_clk <= 1'b0;
		  else 
              count_clk <= count_clk + 1'b1;		  
	   end
	   
	   
	// --------- Module instantiations ------------------------
	
	fsm_tx FSM_t(.i_Txstart(i_Txstart),
	             .i_clk(baud_clk),
				 .i_reset(i_reset),
				 .i_countreached(countreached),
                 .o_shift(shift),
				 .o_load(load),
				 .o_sel_1(sel_1),
				 .o_sel_0(sel_0),
				 .o_startcounter(startcounter),
				 .o_resetcounter(resetcounter));
				 
	piso_tx  PISO_t(.i_datain(i_datain),
	                .i_shift(shift),
			        .i_load(load),
			        .i_clk(baud_clk),
                    .o_serialdata(serial_dataout));		

    paritygen_tx  PARGEN_t(.i_datain(i_datain),
	                       .i_load(load),
						   .o_parity(parityBit));		
   
    mux41_tx   MUX_t(.i_sel_1(sel_1),
	                 .i_sel_0(sel_0),
					 .i_data_0(1'b0),
					 .i_data_1(serial_dataout),
					 .i_data_2(parityBit),
					 .i_data_3(1'b1),
                     .o_data(o_Txdataout));  

    counter_tx COUNTER_t(.i_reset(resetcounter),
	                     .i_clk(baud_clk),
						 .i_up(startcounter),
                         .o_countreached(countreached));					 
				 
				 
	endmodule
	
