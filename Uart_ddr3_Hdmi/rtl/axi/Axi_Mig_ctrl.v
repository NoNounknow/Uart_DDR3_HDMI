`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 16:03:50
// Design Name: 
// Module Name: Axi_Mig_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Axi_Mig_ctrl #(
        parameter   Brust_Length         = 'd16,//Brust_Size * Brust_Length = transcation size
        parameter   Brust_Size           = 'd4 ,//2^4 = 16   
        parameter   w_Brust_Cnt_Max      = ($clog2(Brust_Length)),
        parameter   r_Brust_Cnt_Max      = ($clog2(Brust_Length)),
        parameter   Awaddr_Offset        = 1<<(Brust_Size)<<(w_Brust_Cnt_Max),
        parameter   Araddr_Offset        = 1<<(Brust_Size)<<(r_Brust_Cnt_Max),
        parameter   Image_width          = 1920 ,
        parameter   Image_high           = 1080 ,
        parameter   Image_channel        = 16 ,//RGB565
        parameter   Awaddr_max           = (Image_width)*(Image_high)*2 - (Awaddr_Offset),
        parameter   Araddr_max           = (Image_width)*(Image_high)*2 - (Araddr_Offset)
        )(                    
        input	wire    		    ui_clk                      ,
        input	wire    		    Rst_INIT_DONE               ,
        //Aw
        output  wire    [3:0]	    m_axi_awid                  ,
        output  reg    [27:0]	    m_axi_awaddr                ,
        output  wire    [7:0]	    m_axi_awlen                 ,
        output  wire    [2:0]	    m_axi_awsize                ,
        output  wire    [1:0]	    m_axi_awburst               ,
        output  wire        	    m_axi_awlock                ,
        output  wire    [3:0]	    m_axi_awcache               ,
        output  wire    [2:0]	    m_axi_awprot                ,
        output  wire    [3:0]	    m_axi_awqos                 ,
        output	reg     		    m_axi_awvalid               ,
        input   wire			    m_axi_awready               ,
        //w
        output  wire    [127:0]	    m_axi_wdata                 ,
        output  wire    [15:0]	    m_axi_wstrb                 ,
        output  wire			    m_axi_wlast                 ,
        output  reg 			    m_axi_wvalid                ,
        input	wire	    	    m_axi_wready                ,
        //b
        input   wire    [3:0]	    m_axi_bid                   ,
        input   wire    [1:0]	    m_axi_bresp                 ,
        input	wire    		    m_axi_bvalid                ,
        output  reg 			    m_axi_bready                ,
        //Ar
        output  wire    [3:0]	    m_axi_arid                  ,
        output  reg    [26:0]	    m_axi_araddr                ,
        output  wire    [7:0]	    m_axi_arlen                 ,
        output  wire    [2:0]	    m_axi_arsize                ,
        output  wire    [1:0]	    m_axi_arburst               ,
        output  wire        	    m_axi_arlock                ,
        output  wire    [3:0]	    m_axi_arcache               ,
        output  wire    [2:0]	    m_axi_arprot                ,
        output  wire    [3:0]	    m_axi_arqos                 ,
        output  reg 			    m_axi_arvalid               ,
        input	wire    		    m_axi_arready               ,
        //r
        input   wire    [3:0]	    m_axi_rid                   ,
        input   wire    [127:0]	    m_axi_rdata                 ,
        input   wire    [1:0]	    m_axi_rresp                 ,//Read response
        input   wire			    m_axi_rlast                 ,
        input   wire			    m_axi_rvalid                ,
        output	reg     		    m_axi_rready                ,
        //FIFO_wdata
        input   wire                Aw_Wr_trigger               ,
        output  wire                wdata_fifo_Rd_en            ,
        input   wire    [127:0]     wdata_fifo_Rd_data          ,
        //FIFO_rdata
        input   wire                R_Rd_trigger                ,
        output  wire                rdata_fifo_Wr_en            ,
        output  wire    [127:0]     rdata_fifo_wr_data                           
    );
        //Aw
                reg     [w_Brust_Cnt_Max-1:0]   w_brust_cnt;
                reg                             Aw_running ;
                reg                             Ar_running ;
    //Aw ConFig
    assign   m_axi_awid     =    1'b0                   ;
    assign   m_axi_awlen    =    Brust_Length - 1'b1    ;
    assign   m_axi_awsize   =    Brust_Size             ;
    assign   m_axi_awburst  =    1'b1                   ;
    assign   m_axi_awlock   =    1'b0                   ;
    assign   m_axi_awcache  =    1'b0                   ;
    assign   m_axi_awprot   =    1'b0                   ;
    assign   m_axi_awqos    =    1'b0                   ; 
    //Aw_running
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            Aw_running <= 'd0;
        end else if(m_axi_bvalid == 1'b1 && m_axi_bready == 1'b1) begin
            Aw_running <= 1'b0;
        end else if(Aw_Wr_trigger == 1'b1 && Aw_running == 1'b0) begin
            Aw_running <= 1'b1;
        end
    end
    //m_axi_awvalid
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_awvalid <= 1'b0;
        end else if(m_axi_awvalid == 1'b1 && m_axi_awready == 1'b1) begin
            m_axi_awvalid <= 1'b0;
        end else if(Aw_Wr_trigger == 1'b1 && Aw_running == 1'b0) begin
            m_axi_awvalid <= 1'b1;
        end
    end
    //m_axi_awaddr  
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_awaddr <= 'd0;
        end else if(m_axi_awvalid == 1'b1 && m_axi_awready && m_axi_awaddr == Awaddr_max) begin
            m_axi_awaddr <= 'd0;
        end else if(m_axi_awvalid == 1'b1 && m_axi_awready == 1'b1) begin
            m_axi_awaddr <= m_axi_awaddr + Awaddr_Offset;
        end
    end
    //w
    assign  m_axi_wdata      = wdata_fifo_Rd_data;
    assign  wdata_fifo_Rd_en = ((m_axi_wvalid == 1'b1)&&(m_axi_wready == 1'b1))?1'b1:1'b0;
    assign  m_axi_wstrb      = 16'hffff;
    assign  m_axi_wlast      = (w_brust_cnt == Brust_Length - 1'b1)?1'b1:1'b0;
    //w_brust_cnt
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            w_brust_cnt <= 'd0;
        end else if((m_axi_wvalid == 1'b1)&&(m_axi_wready == 1'b1)) begin
            if(w_brust_cnt == Brust_Length - 1'b1) begin
                w_brust_cnt <= 'd0;
            end else begin
                w_brust_cnt <= w_brust_cnt + 1'b1;
            end
        end else begin
            w_brust_cnt <= w_brust_cnt;
        end
    end
    //m_axi_wvalid
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_wvalid <= 'd0;
        end else if(m_axi_wvalid == 1'b1 && m_axi_wready == 1'b1 && m_axi_wlast == 1'b1) begin
            m_axi_wvalid <= 'd0;
        end else if(m_axi_awvalid == 1'b1 && m_axi_awready == 1'b1) begin
        // end else if(Aw_Wr_trigger == 1'b1 && Aw_running == 1'b0) begin
            m_axi_wvalid <= 1'b1;
        end
    end
    //m_axi_bready
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_bready <= 'd0;
        end else if(m_axi_bready == 1'b1 && m_axi_bvalid == 1'b1) begin
            m_axi_bready <= 'd0;
        end else if(m_axi_wvalid == 1'b1 && m_axi_wready == 1'b1 && m_axi_wlast == 1'b1) begin
            m_axi_bready <= 1'b1;
        end
    end
    //Ar ConFig
    assign  m_axi_arid     =  'd0                   ;
    assign  m_axi_arlen    =  Brust_Length - 1'b1   ;
    assign  m_axi_arsize   =  Brust_Size            ;
    assign  m_axi_arburst  =  1'b1                  ;
    assign  m_axi_arlock   =   'd0                  ;
    assign  m_axi_arcache  =   'd0                  ;
    assign  m_axi_arprot   =   'd0                  ;
    assign  m_axi_arqos    =   'd0                  ;
    //Ar_running
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            Ar_running <= 'd0;
        end else if(m_axi_rlast == 1'b1 && m_axi_rvalid == 1'b1 && m_axi_rready == 1'b1) begin
            Ar_running <= 'd0;
        end else if(R_Rd_trigger == 1'b1 && Ar_running == 'd0) begin
            Ar_running <= 1'b1;
        end
    end
    //m_axi_araddr
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_araddr <= 'd0;
        end else if(m_axi_arvalid == 1'b1 && m_axi_arready == 1'b1 && m_axi_araddr == Araddr_max) begin
            m_axi_araddr <= 'd0; 
        end else if(m_axi_arvalid == 1'b1 && m_axi_arready == 1'b1)
            m_axi_araddr <= m_axi_araddr + Araddr_Offset;
    end
    //m_axi_arvalid
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_arvalid <= 'd0;
        end else if(m_axi_arvalid == 1'b1 && m_axi_arready == 1'b1) begin
            m_axi_arvalid <= 'd0; 
        end else if(R_Rd_trigger == 1'b1 && Ar_running == 'd0) begin
            m_axi_arvalid <= 1'b1;
        end
    end
    //r
    assign  rdata_fifo_Wr_en    =   ((m_axi_rvalid == 1'b1) && (m_axi_rready == 1'b1))?1'b1:1'b0;
    assign  rdata_fifo_wr_data  =   m_axi_rdata;
    always @(posedge ui_clk or negedge Rst_INIT_DONE) begin
        if(Rst_INIT_DONE == 0) begin
            m_axi_rready <= 'd0;
        end else if(m_axi_rready == 1'b1 && m_axi_rvalid == 1'b1 && m_axi_rlast == 1'b1) begin
            m_axi_rready <= 'd0;
        end else if(m_axi_arvalid == 1'b1 && m_axi_arready == 1'b1) begin
            m_axi_rready <= 1'b1;
        end
    end
endmodule
