module write_to_read_syn #(
        parameter address_size = 3                              //kich thuoc dia chi
    )
    (
        input [address_size:0] write_pointer_i                  , //con tro ghi dung de dong bo voi mien doc
        input read_reset_n_i                                    , //tin hieu reset vi tri 
        input read_clk_i                                        , //xung clock mien doc
        output reg [address_size - 1:0] write_to_read_pointer_o   //con tro dong bo
    );
    
    reg [address_size:0] tmp_write_pointer;                       //bien tam de thuc hien dong bo 2 ff
    
    always @(posedge read_clk_i, negedge read_reset_n_i)          //xu ly dong bo
    begin
        if (~read_reset_n_i) 
            {write_to_read_pointer_o, tmp_write_pointer} <= 0    ;
        else
            {write_to_read_pointer_o, tmp_write_pointer} <= 
            {tmp_write_pointer, write_pointer_i}                 ; //dong bo tin hieu tu mien write sang mien read        
    end
    
    
endmodule