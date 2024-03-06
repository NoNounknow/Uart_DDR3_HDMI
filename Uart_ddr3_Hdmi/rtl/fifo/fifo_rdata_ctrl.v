module fifo_rdata_ctrl #(
    parameter   Brust_Length         = 'd16
    //Brust_Size * Brust_Length = transcation size
)(
    input   wire                Sys_clk_Pixl,
    input   wire                Rst_n       ,
    input   wire                ui_clk_100MHZ,
    //FIFO  wr
    input   wire [127:0]        FIFO_WR_rdata        ,
    input   wire                rdata_fifo_Wr_en     ,  
    //FIFO  rd  
    input   wire                Pixl_FIFO_rdata_RdEn ,  

    output  wire                rdata_req            ,
    output  wire [15:0]         rdata_fifo_RGB_data                  
);
            wire                full                 ;
            wire                empty                ;
            wire [8 : 0]        rd_data_count        ;
            wire [5 : 0]        wr_data_count        ;
    assign rdata_req = (wr_data_count <= Brust_Length)?1'b1:1'b0;

FIFO_rdata_w128x64_r16x512 Inst0_FIFO_rdata_w128x64_r16x512 (
  .wr_clk   ( ui_clk_100MHZ        ), // input wire wr_clk
  .rd_clk   ( Sys_clk_Pixl         ), // input wire rd_clk
  .din      ( FIFO_WR_rdata        ), // input wire [127 : 0] din
  .wr_en    ( rdata_fifo_Wr_en     ), // input wire wr_en
  .rd_en    ( Pixl_FIFO_rdata_RdEn ), // input wire rd_en
  .dout     ( rdata_fifo_RGB_data  ), // output wire [15 : 0] dout
  .full     ( full                 ), // output wire full
  .empty    ( empty                ), // output wire empty
  .rd_data_count(rd_data_count),  // output wire [8 : 0] rd_data_count
  .wr_data_count(wr_data_count)   // output wire [5 : 0] wr_data_count
);
endmodule