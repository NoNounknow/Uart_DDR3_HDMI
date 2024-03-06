module wdata_rdata_fifo (
    input   wire            Rst_n               ,

    input   wire            wdata_fifo_wr_clk   ,
    input   wire            wdata_fifo_rd_clk   ,
    input   wire            rx_done             ,
    input   wire    [7:0]   rx_data             ,
    input   wire            wdata_fifo_rd_en    ,
    output  wire    [127:0] wdata_fifo_rd_data  ,

    input   wire            rdata_fifo_wr_clk   ,
    input   wire            rdata_fifo_rd_clk   ,
    input   wire            rdata_fifo_wr_en    ,
    input   wire    [127:0] rdata_fifo_wr_data  ,
    input   wire            rdata_fifo_rd_en    ,
    output  wire    [15:0]  rdata_fifo_rd_data  ,

    output  wire            Wr_req              ,
    output  wire            Rd_req              
);
            reg     [4:0]   Data_length         ;
            reg     [127:0] Concat_Data         ;
            reg             Concat_Done         ;
            wire    [5 : 0] rd_data_count       ;
            wire    [5 : 0] wr_data_count       ;
    assign Wr_req = (rd_data_count >= 16)?1'b1:1'b0;
    assign Rd_req = (wr_data_count < 16) ?1'b1:1'b0;
always @(posedge wdata_fifo_wr_clk or negedge Rst_n) begin
    if(Rst_n == 'd0) begin
        Data_length <= 'd0;
    end else if(Data_length == 'd15 && rx_done) begin
        Data_length <= 'd0;
    end else if(rx_done) begin
        Data_length <= Data_length + 1'b1;
    end
end
always @(posedge wdata_fifo_wr_clk or negedge Rst_n) begin
    if(Rst_n == 'd0) begin
        Concat_Data <= 'd0;
    end else if(rx_done) begin
        Concat_Data <= {Concat_Data[119:0],rx_data};
    end
end
always @(posedge wdata_fifo_wr_clk or negedge Rst_n) begin
    if(Rst_n == 'd0) begin
        Concat_Done <= 'd0;
    end else if(Data_length == 'd15 && rx_done) begin
        Concat_Done <= 1'b1;
    end else begin
        Concat_Done <= 'd0;
    end
end
wdata_fifo wdata_fifo (
  .rst          ( !Rst_n               ), // input wire rst
  .wr_clk       ( wdata_fifo_wr_clk    ), // input wire wr_clk
  .rd_clk       ( wdata_fifo_rd_clk    ), // input wire rd_clk
  .din          ( Concat_Data          ), // input wire [127 : 0] din
  .wr_en        ( Concat_Done          ), // input wire wr_en
  .rd_en        (  wdata_fifo_rd_en    ), // input wire rd_en
  .dout         (  wdata_fifo_rd_data  ), // output wire [127 : 0] dout
  .full         (                      ), // output wire full
  .empty        (                      ), // output wire empty
  .rd_data_count(rd_data_count),          // output wire [5 : 0] rd_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);
rdata_fifo rdata_fifo (
  .rst          ( !Rst_n                ), // input wire rst
  .wr_clk       ( rdata_fifo_wr_clk     ), // input wire wr_clk
  .rd_clk       ( rdata_fifo_rd_clk     ), // input wire rd_clk
  .din          ( rdata_fifo_wr_data    ), // input wire [127 : 0] din
  .wr_en        ( rdata_fifo_wr_en      ), // input wire wr_en
  .rd_en        ( rdata_fifo_rd_en      ), // input wire rd_en
  .dout         ( rdata_fifo_rd_data    ), // output wire [15 : 0] dout
  .full         (                       ), // output wire full
  .empty        (                       ), // output wire empty
  .wr_data_count(wr_data_count),    // output wire [5 : 0] wr_data_count
  .wr_rst_busy(),                   // output wire wr_rst_busy
  .rd_rst_busy()                    // output wire rd_rst_busy
);
endmodule