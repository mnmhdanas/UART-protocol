
  module mux41_tx(i_sel_1,i_sel_0,i_data_0,i_data_1,i_data_2,i_data_3,
                  o_data);
				  
		input i_sel_1,i_sel_0;
        input i_data_0,i_data_1,i_data_2,i_data_3;
        output reg o_data;

        always@(*)
           begin
		     case({i_sel_1,i_sel_0})
			   2'b00  : o_data = i_data_0;
			   2'b01  : o_data = i_data_1;
			   2'b10  : o_data = i_data_2;
			   2'b11  : o_data = i_data_3;
			  default : o_data = 1'b0;
		  endcase 
            end	
   endmodule			