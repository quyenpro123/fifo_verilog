module read_to_write_syn #(
        parameter address_size = 3                               //kich thuoc dia chi
    )
    (
        input [address_size:0] read_pointer_i                   , //con tro doc
        input write_clk_i                                       , //xung clk mien ghi
        input write_reset_n_i                                   , //reset mien ghi
        output reg [address_size - 1:0] read_to_write_pointer_o   //con tro dong bo tu mien doc sang mien ghi
    );
    
    reg [address_size - 1:0] tmp_read_to_write                  ; //bien tam de thuc hien dong do 2ff
    
    always @(posedge write_clk_i)
    begin
        if (~write_reset_n_i)
            {read_to_write_pointer_o, tmp_read_to_write} <= 0     ;
        else
            {read_to_write_pointer_o, tmp_read_to_write} <= 
            {tmp_read_to_write, read_pointer_i}                 ; //dong bo tin hieu tu mien doc sang mien ghi
    end
    
endmodule