
  module receiver(i_datain,i_clk,i_reset,
                  o_dataout);
				  
		input i_clk,i_datain,i_reset;
        output [7:0] o_dataout;
        
		wire zerodetected,onedetected,parityerror,countreached,shift,startcount,resetcounter,outputenable; //fsm intermediate signals
		wire [7:0] pardataout;
		
		assign o_dataout = (outputenable) ? pardataout : 8'bz;
		
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
	   		
	// ---------- Module instantiations -------------------------

     fsm_rx FSM_r(.i_zerodetected(zerodetected),
	              .i_onedetected(onedetected),
				  .i_parityerror(parityerror),
				  .i_clk(baud_clk),
				  .i_reset(i_reset),
				  .i_countreached(countreached),
                  .o_shift(shift),
				  .o_startcount(startcount),
				  .o_resetcounter(resetcounter),
				  .o_outputenable(outputenable));	
				  
				  
				  
    sipo_rx  SIPO_r(.i_onedetected(onedetected),
	                .i_zerodetected(zerodetected),
					.i_baudclk(baud_clk),
					.i_shift(shift),
	                .o_parallelout(pardataout));
					
					
	bitchecker_rx  BITCHK_r(.i_data(i_datain),
	                        .i_clk(i_clk),
							.i_baudclk(baud_clk),
	                        .o_zerodetected(zerodetected),
							.o_onedetected(onedetected));	

    
    counter_rx  COUNTER_r(.i_reset(resetcounter),
	                      .i_clk(baud_clk),
						  .i_up(startcount),
	                      .o_countreached(countreached));	
						  
    paritychecker PARCHK_r( .i_datain(pardataout),
	                        .i_zerodetected(zerodetected),
							.i_onedetected(onedetected),
                            .o_parityerror(parityerror) );
							
	endmodule
	
