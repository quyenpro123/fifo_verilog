module fifo_memory #(
        parameter data_size = 8                     , //kich thuoc 1 du lieu trong buffer
        parameter address_size = 3                    //kich thuoc dia chi = so luong o nho trong buffer
    )
    (
        input [data_size - 1:0] write_data_i        , //du lieu ghi vao buffer
        input [address_size - 1:0] write_address_i  , //dia chi ghi du lieu
        input [address_size - 1:0] read_address_i   , //dia chi doc du lieu
        input write_clk_en_i                        , //tin hieu cho phep ghi du lieu
        input write_full_i                          , //tin hieu cho biet buffer day hay chua
        input write_clk_i                           , //tin hieu clock mien ghi
        output [data_size - 1:0] read_data_o          //du lieu doc
    );
    
    localparam fifo_depth = 1 << address_size       ; //kich thuoc cua bo dem
    reg [data_size - 1:0] mem [0:fifo_depth]        ; //khai bao buffer
    
    assign read_data_o = mem[read_address_i]        ; //doc du lieu
    
    always @(posedge write_clk_i)                     //khoi ghi du lieu  
    begin
        if (write_clk_en_i && !write_full_i)          //neu co tin hieu cho phep va buffer khong full  
        begin
            mem[write_address_i] <= write_data_i    ; // ghi du lieu vao dia chi tuong ung
        end 
    end
    
endmodule            