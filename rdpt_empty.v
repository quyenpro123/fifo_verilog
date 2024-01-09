module rdpt_empty #(
        parameter address_size = 3                            //kich thuoc dia chi  
    )
    (
        input read_reset_n_i                                , //tin hieu reset mien doc
        input read_clk_i                                    , //xung clk mien doc
        input read_increment_i                              , //gia tri tang dia chi den o nho tiep theo
        input [address_size:0] write_to_read_pointer_i      , //con tro dong bo tu mien ghi sang mien doc
        output reg [address_size - 1:0] read_address_o      , //dia chi doc du lieu
        output reg [address_size:0] read_pointer_o          , //con tro mien doc de dong bo voi mien ghi 
        output reg read_empty_o                               //tin hieu buffer empty
    );
    reg [address_size:0] read_binary                        ; //bien tam, tinh dia chi binary 
    reg [address_size:0] read_gray_next                     ; //bien tam, tinh gia chi dia chi gray tiep theo cho con tro
    reg [address_size:0] read_binary_next                   ; //bien tam, tinh gia tri dia chi binary tiep theo  
    
    always @*
    begin
        read_address_o = read_binary[address_size - 1:0]    ; //gan dia chi doc
        read_binary_next = read_binary + (read_increment_i
        & ~read_empty_o)                                    ; //tang dia chi doc neu buffer khong trong
        read_gray_next = (read_binary_next >> 1) ^ 
        read_binary_next                                    ; //tinh toan gia tri dia chi ma gray 
                                                              //G3 = B3, G2 = B3 ^ B2, G1 = B2 ^ B1, G0 = B1 ^ B0
    end
    
    always @(posedge read_clk_i, negedge read_reset_n_i)      //khoi cap nhat gia tri dia chi, con tro
    begin
        if (~read_reset_n_i)
            {read_binary, read_pointer_o} <= 0              ;
        else
            {read_binary, read_pointer_o} <= 
            {read_binary_next, read_gray_next}              ; 
    end
    
    always @(posedge read_clk_i, negedge read_reset_n_i)      //khoi kiem tra buffer empty
    begin
        if (~read_reset_n_i)
            read_empty_o <= 1'b1                            ;
        else
            read_empty_o <= (read_gray_next == 
            write_to_read_pointer_i)                        ; //neu dia chi doc = dia chi ghi thi day
    end
endmodule