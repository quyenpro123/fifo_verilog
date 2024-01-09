module wrpt_full #(
        parameter address_size = 3                                      //kich thuoc dia chi
    )
    (
        input [address_size:0] read_to_write_pointer_i                  ,//con tro dong bo tu mien doc sang mien ghi
        input write_clk_i                                               ,//clk mien doc
        input write_increment_i                                         ,//tang dia chi den o nho tiep
        input write_reset_n_i                                           ,//reset mien ghi
        output reg [address_size - 1:0] write_address_o                 ,//dia chi ghi du lieu
        output reg [address_size:0] write_pointer_o                     ,//con tro mien ghi
        output reg write_full_o                                          //tin hieu buffer full
    );
    reg [address_size:0] write_binary                                   ;//bien tam, tinh dia chi binary 
    reg [address_size:0] write_gray_next                                ;//bien tam, tinh gia chi dia chi gray tiep theo cho con tro
    reg [address_size:0] write_binary_next                              ;//bien tam, tinh gia tri dia chi binary tiep theo 
       
    always @*
    begin
        write_address_o = write_binary[address_size - 1:0]              ;
        write_binary_next = write_binary + 
        (write_increment_i & ~write_full_o)                             ;
        write_gray_next = (write_binary_next >> 1) ^ 
        write_binary_next                                               ; //tinh toan gia tri dia chi ma gray 
                                                                          //G3 = B3, G2 = B3 ^ B2, G1 = B2 ^ B1, G0 = B1 ^ B0
    end
    
    always @(posedge write_clk_i, negedge write_reset_n_i)                //khoi cap nhat gia tri dia chi, con tro
    begin
        if (~write_reset_n_i)
            {write_binary, write_pointer_o} <= 0                        ;
        else 
            {write_binary, write_pointer_o} <= 
            {write_binary_next, write_gray_next}                        ;
    end
    
    always @(posedge write_clk_i, negedge write_reset_n_i)                //khoi kiem tra buffer full
    begin
        if (~write_reset_n_i)
            write_full_o <= 1'b0                                        ;
        else
            write_full_o <= (write_gray_next == 
            {~read_to_write_pointer_i[address_size:address_size - 1],
            read_to_write_pointer_i[address_size - 2:0]})               ; //gray 3 bit  000  001  011  010  110  111  101  100 - vong dau tien
    end                                                                   //gray 4 bit 1100 1101 1111 1110 1010 1011 1001 1000 - vong thu 2
        
endmodule