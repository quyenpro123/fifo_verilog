`timescale 1ns / 1ps


module fifo_top #(
        parameter data_size = 8                                 ,//kich thuoc du lieu
        parameter address_size = 3                               //kich thuoc dia chi  
    )
    (
        input [data_size - 1:0] write_data_i                    ,//du lieu ghi dau vao 
        input write_increment_i                                 ,//gia tri tang dia chi ghi
        input write_clk_i                                       ,//clk mien ghi
        input write_reset_n_i                                   ,//reset mien ghi
        input read_increment_i                                  ,// gia tri tang dia chi doc
        input read_clk_i                                        ,//clk mien doc
        input read_reset_n_i                                    ,//reset mien doc
        output [data_size - 1:0] read_data_o                    ,//du lieu doc dau ra
        output write_full_o                                     ,//tin hieu buffer full
        output read_empty_o                                     //tin hieu buffer empty 
    );
    wire [address_size - 1:0] write_address                     ;//dia chi ghi du lieu
    wire [address_size - 1:0] read_address                      ;//dia chi doc du lieu
    wire [address_size:0] write_pointer                         ;//con tro mien ghi
    wire [address_size:0] read_pointer                          ;//con tro mien doc
    wire [address_size:0] write_to_read_pointer                 ;//con tro dong bo tu mien ghi sang mien doc
    wire [address_size:0] read_to_write_pointer                 ;//con tro dong bo tu mien doc sang ghi
    
    fifo_memory  #(data_size, address_size)                      //khoi fifo mem
                fifo_mem (
                             .write_clk_i(write_clk_i)          ,
                             .write_clk_en_i(write_increment_i) ,
                             .write_data_i(write_data_i)        ,
                             .write_address_i(write_address)    ,
                             .read_address_i(read_address)      ,
                             .write_full_i(write_full_o)        ,
                             .read_data_o(read_data_o)          
                        );
    rdpt_empty #(address_size)                                     //khoi kiem tra buffer empty     
                rdpt_empty(
                             .read_reset_n_i(read_reset_n_i)                  , 
                             .read_clk_i(read_clk_i)                          , 
                             .read_increment_i(read_increment_i)              , 
                             .write_to_read_pointer_i(write_to_read_pointer)  ,
                             .read_address_o(read_address)                    , 
                             .read_pointer_o(read_pointer)                    , 
                             .read_empty_o(read_empty_o)                               
                        );
    wrpt_full #()                                                   //khoi kiem tra buffer full    
                wrpt_full(  
                             .read_to_write_pointer_i(read_to_write_pointer)  ,
                             .write_clk_i(write_clk_i)                        ,
                             .write_increment_i(write_increment_i)            ,
                             .write_reset_n_i(write_reset_n_i)                ,
                             .write_address_o(write_address)                  ,
                             .write_full_o(write_full_o)                                          
                        );
    read_to_write_syn #()                                             //khoi dong bo tu mien doc sang ghi
                read_to_write_syn(
                             .read_pointer_i(read_pointer)                    , 
                             .write_clk_i(write_clk_i)                        , 
                             .write_reset_n_i(write_reset_n_i)                , 
                             .read_to_write_pointer_o(read_to_write_pointer)   
                        );
    write_to_read_syn #()                                             //khoi dong bo tu mien ghi sang doc
                write_to_read_syn(
                            .write_pointer_i(write_pointer)                   , 
                             .read_clk_i(read_clk_i)                          , 
                             .read_reset_n_i(read_reset_n_i)                  , 
                             .write_to_read_pointer_o(write_to_read_pointer)   
                        );                        
endmodule
