`timescale 1ns / 1ps
module Sim_NoUart(
        input   wire                Sys_clk_50mhz       ,
        input   wire                Sys_Rst_n           ,
    //rx                    
        input   wire    [7:0]       data_receive        ,
        input   wire                rx_done             ,
    //ddr3                  
        output  wire    [12:0]	    ddr3_addr           ,        
        output  wire    [2:0]	    ddr3_ba             ,    
        output  wire   			    ddr3_cas_n          ,        
        output  wire    [0:0]	    ddr3_ck_n           ,        
        output  wire    [0:0]	    ddr3_ck_p           ,        
        output  wire    [0:0]	    ddr3_cke            ,        
        output  wire   			    ddr3_ras_n          ,        
        output  wire   			    ddr3_reset_n        ,            
        output  wire   			    ddr3_we_n           ,        
        inout   wire    [15:0]	    ddr3_dq             ,    
        inout   wire    [1:0]		ddr3_dqs_n          ,        
        inout   wire    [1:0]		ddr3_dqs_p          ,                   
        output  wire    [0:0]	    ddr3_cs_n           ,    
        output  wire    [1:0]	    ddr3_dm             ,
        output  wire    [0:0]	    ddr3_odt            ,
        //Tmds
        output  wire                Tmds_Clk_p          ,
        output  wire                Tmds_Clk_n          ,
        output  wire    [2:0]       Tmds_data_p         ,
        output  wire    [2:0]       Tmds_data_n         
    );
            //rx
                wire    [7:0]       data_receive         ;
                wire                rx_done              ;

            //ddr3
                wire			    ui_clk_100MHZ        ;   
                wire			    ui_clk_sync_rst      ;  
                //ui         
                wire			    mmcm_locked          ;       
                wire			    aresetn              ;  
                wire   			    init_calib_complete  ;
                //app
                wire			    app_sr_req           ;       
                wire			    app_ref_req          ;       
                wire			    app_zq_req           ;       
                wire			    app_sr_active        ;           
                wire			    app_ref_ack          ;       
                wire			    app_zq_ack           ;  
                //aw     
                wire  [3:0]		    s_axi_awid           ;       
                wire  [26:0]	    s_axi_awaddr         ;           
                wire  [7:0]		    s_axi_awlen          ;       
                wire  [2:0]		    s_axi_awsize         ;           
                wire  [1:0]		    s_axi_awburst        ;           
                wire  [0:0]		    s_axi_awlock         ;           
                wire  [3:0]		    s_axi_awcache        ;           
                wire  [2:0]		    s_axi_awprot         ;           
                wire  [3:0]		    s_axi_awqos          ;       
                wire  			    s_axi_awvalid        ;           
                wire  			    s_axi_awready        ; 
                //w          
                wire  [127:0]	    s_axi_wdata          ;       
                wire  [15:0]		s_axi_wstrb          ;       
                wire  			    s_axi_wlast          ;       
                wire  			    s_axi_wvalid         ;           
                wire  			    s_axi_wready         ; 
                //b          
                wire   [3:0]		s_axi_bid            ;       
                wire   [1:0]		s_axi_bresp          ;       
                wire  			    s_axi_bvalid         ;           
                wire  			    s_axi_bready         ; 
                //ar          
                wire  [3:0]		    s_axi_arid           ;       
                wire  [26:0]		s_axi_araddr         ;           
                wire  [7:0]		    s_axi_arlen          ;       
                wire  [2:0]		    s_axi_arsize         ;           
                wire  [1:0]		    s_axi_arburst        ;           
                wire  [0:0]		    s_axi_arlock         ;           
                wire  [3:0]		    s_axi_arcache        ;           
                wire  [2:0]		    s_axi_arprot         ;           
                wire  [3:0]		    s_axi_arqos          ;       
                wire  			    s_axi_arvalid        ;           
                wire  			    s_axi_arready        ; 
                //r          
                wire   [3:0]	    s_axi_rid            ;       
                wire   [127:0]	    s_axi_rdata          ;       
                wire   [1:0]		s_axi_rresp          ;       
                wire  			    s_axi_rlast          ;       
                wire  			    s_axi_rvalid         ;           
                wire  			    s_axi_rready         ;                 
                wire                sys_rst              ;  
            //PLL
                wire                PLL_200MHZ           ;
                wire                PLL_50MHZ            ;
                wire                PLL_100MHZ           ;
                wire                Pixl_CLK             ;
                wire                Pixl_5xCLK           ;
                wire                lock_0               ;
                wire                lock_1               ;
            //FIFO
                wire                wdata_fifo_Rd_en     ;
                wire  [127:0]       rdata_fifo_wdata     ;
                wire                rdata_fifo_Wr_en     ;
                wire                rdata_fifo_rd_en     ;
                wire  [127:0]       FIFO_RD_wdata        ;
                wire  [15:0]        rdata_fifo_rdata     ;
                wire                Aw_Rd_trigger        ;
                wire                Aw_Wr_trigger        ;
//PLL
    PLL_Pixl Inst0_PLL_Pixl
    (
        // Clock out ports
            .CLK_7425   (   Pixl_CLK    ),     // output CLK_7425
            .CLK_37125  (   Pixl_5xCLK  ),     // output CLK_37125

            .resetn     (   Sys_Rst_n   ), 
            .locked     (   lock_0      ), 
        // Clock in ports
            .CLK_100MHZ (   PLL_100MHZ  )      // input CLK_100MHZ
    );
    PLL_Wizard Inst0_PLL_Wizard(
        // Clock out ports
        .resetn         ( Sys_Rst_n     ), 
        .locked         ( lock_1        ), 
        .PLL_200MHZ     ( PLL_200MHZ    ),     // output PLL_200MHZ
        .PLL_50MHZ      ( PLL_50MHZ     ),     // output PLL_50MHZ
        .PLL_100MHZ     ( PLL_100MHZ    ),     // output PLL_100MHZ
        // Clock in ports
        .SYS_CLK_50MHZ  ( Sys_clk_50mhz )                // input SYS_CLK_50MHZ
    );
    Tmds_hdmi_out  Inst0_HDMI_top (
        .Pixl_CLK                 ( Pixl_CLK                ),
        .Pixl_5xCLK               ( Pixl_5xCLK              ),
        .Rst_n                    ( init_calib_complete &&  lock_1),
        .rdata_fifo_RGB_data      ( rdata_fifo_rdata        ),

        .VGA_Data_Enable          ( rdata_fifo_rd_en        ),
        .Tmds_Clk_p               ( Tmds_Clk_p              ),
        .Tmds_Clk_n               ( Tmds_Clk_n              ),
        .Tmds_data_p              ( Tmds_data_p             ),
        .Tmds_data_n              ( Tmds_data_n             )
    );  
    FIFO_Ctrl FIFO_Ctrl(
        .Sys_Rst_n               ( lock_1                       ),
        .Sys_clk_50mhz           ( PLL_50MHZ                    ),
        .UI_clock_100mhz         ( ui_clk_100MHZ                ),
        .Sys_clk_Pixl            ( Pixl_CLK                     ),

        .data_receive            ( data_receive                 ),
        .rx_done                 ( rx_done                      ),
        .wdata_fifo_Rd_en        ( wdata_fifo_Rd_en             ),
        .rdata_fifo_wdata        ( rdata_fifo_wdata             ),
        .rdata_fifo_Wr_en        ( rdata_fifo_Wr_en             ),
        .rdata_fifo_rd_en        ( rdata_fifo_rd_en             ),

        .FIFO_RD_wdata           ( FIFO_RD_wdata                ),
        .rdata_fifo_rdata        ( rdata_fifo_rdata             ),
        .Aw_Rd_trigger           ( Aw_Rd_trigger                ),
        .Aw_Wr_trigger           ( Aw_Wr_trigger                )
    );
    Axi_Mig_ctrl  Inst0_Axi_Mig_ctrl (
        .ui_clk                  ( ui_clk_100MHZ            ),
        .ui_clk_sync_rst         ( init_calib_complete      ),

        //FIFO wdata
        .wdata_fifo_Rd_en        ( wdata_fifo_Rd_en         ),
        .Aw_Wr_trigger           ( Aw_Wr_trigger            ),
        .FIFO_RD_wdata           ( FIFO_RD_wdata            ),
        //FIFO rdata
        .rdata_fifo_Wr_en        ( rdata_fifo_Wr_en         ),
        .rdata_fifo_wr_data      ( rdata_fifo_wdata         ),
        .rdata_trigger           ( Aw_Rd_trigger            ),
        //app
        .app_sr_active           ( app_sr_active            ),
        .app_ref_ack             ( app_ref_ack              ),
        .app_zq_ack              ( app_zq_ack               ),
        .m_axi_awready           ( s_axi_awready            ),
        .m_axi_wready            ( s_axi_wready             ),
        .m_axi_bid               ( s_axi_bid                ),
        .m_axi_bresp             ( s_axi_bresp              ),
        .m_axi_bvalid            ( s_axi_bvalid             ),
        .m_axi_arready           ( s_axi_arready            ),

        .m_axi_rid               ( s_axi_rid                ),
        .m_axi_rdata             ( s_axi_rdata              ),
        .m_axi_rresp             ( s_axi_rresp              ),
        .m_axi_rlast             ( s_axi_rlast              ),
        .m_axi_rvalid            ( s_axi_rvalid             ),

        .app_sr_req              ( app_sr_req               ),
        .app_ref_req             ( app_ref_req              ),
        .app_zq_req              ( app_zq_req               ),
        .m_axi_awid              ( s_axi_awid               ),
        .m_axi_awaddr            ( s_axi_awaddr             ),
        .m_axi_awlen             ( s_axi_awlen              ),
        .m_axi_awsize            ( s_axi_awsize             ),
        .m_axi_awburst           ( s_axi_awburst            ),
        .m_axi_awlock            ( s_axi_awlock             ),
        .m_axi_awcache           ( s_axi_awcache            ),
        .m_axi_awprot            ( s_axi_awprot             ),
        .m_axi_awqos             ( s_axi_awqos              ),
        .m_axi_awvalid           ( s_axi_awvalid            ),
        .m_axi_wdata             ( s_axi_wdata              ),
        .m_axi_wstrb             ( s_axi_wstrb              ),
        .m_axi_wlast             ( s_axi_wlast              ),
        .m_axi_wvalid            ( s_axi_wvalid             ),
        .m_axi_bready            ( s_axi_bready             ),

        .m_axi_arid              ( s_axi_arid               ),
        .m_axi_araddr            ( s_axi_araddr             ),
        .m_axi_arlen             ( s_axi_arlen              ),
        .m_axi_arsize            ( s_axi_arsize             ),
        .m_axi_arburst           ( s_axi_arburst            ),
        .m_axi_arlock            ( s_axi_arlock             ),
        .m_axi_arcache           ( s_axi_arcache            ),
        .m_axi_arprot            ( s_axi_arprot             ),
        .m_axi_arqos             ( s_axi_arqos              ),
        .m_axi_arvalid           ( s_axi_arvalid            ),

        .m_axi_rready            ( s_axi_rready             )
    );
    MIG_Axi_400Mhz Inst0_MIG_Axi_400Mhz (
        // Memory interface ports
        .ddr3_addr                      (ddr3_addr),            // output [12:0]	ddr3_addr
        .ddr3_ba                        (ddr3_ba),              // output [2:0]		ddr3_ba
        .ddr3_cas_n                     (ddr3_cas_n),           // output			ddr3_cas_n
        .ddr3_ck_n                      (ddr3_ck_n),            // output [0:0]		ddr3_ck_n
        .ddr3_ck_p                      (ddr3_ck_p),            // output [0:0]		ddr3_ck_p
        .ddr3_cke                       (ddr3_cke),             // output [0:0]		ddr3_cke
        .ddr3_ras_n                     (ddr3_ras_n),           // output			ddr3_ras_n
        .ddr3_reset_n                   (ddr3_reset_n),         // output			ddr3_reset_n
        .ddr3_we_n                      (ddr3_we_n),            // output			ddr3_we_n
        .ddr3_dq                        (ddr3_dq),              // inout [15:0]		ddr3_dq
        .ddr3_dqs_n                     (ddr3_dqs_n),           // inout [1:0]		ddr3_dqs_n
        .ddr3_dqs_p                     (ddr3_dqs_p),           // inout [1:0]		ddr3_dqs_p
        .init_calib_complete            (init_calib_complete),  // output			init_calib_complete
        .ddr3_cs_n                      (ddr3_cs_n),            // output [0:0]		ddr3_cs_n
        .ddr3_dm                        (ddr3_dm),              // output [1:0]		ddr3_dm
        .ddr3_odt                       (ddr3_odt),             // output [0:0]		ddr3_odt
        // Application interface ports
        .ui_clk                         (ui_clk_100MHZ),        // output			ui_clk
        .ui_clk_sync_rst                (ui_clk_sync_rst),      // output			ui_clk_sync_rst
        .mmcm_locked                    (mmcm_locked),          // output			mmcm_locked
        .aresetn                        (Sys_Rst_n  ),          // input			aresetn
        .app_sr_req                     (app_sr_req),           // input			app_sr_req
        .app_ref_req                    (app_ref_req),          // input			app_ref_req
        .app_zq_req                     (app_zq_req),           // input			app_zq_req
        .app_sr_active                  (app_sr_active),        // output			app_sr_active
        .app_ref_ack                    (app_ref_ack),          // output			app_ref_ack
        .app_zq_ack                     (app_zq_ack),           // output			app_zq_ack
        // Slave Interface Write Address Ports
        .s_axi_awid                     (s_axi_awid),           // input [3:0]		s_axi_awid
        .s_axi_awaddr                   (s_axi_awaddr),         // input [26:0]		s_axi_awaddr
        .s_axi_awlen                    (s_axi_awlen),          // input [7:0]		s_axi_awlen
        .s_axi_awsize                   (s_axi_awsize),         // input [2:0]		s_axi_awsize
        .s_axi_awburst                  (s_axi_awburst),        // input [1:0]		s_axi_awburst
        .s_axi_awlock                   (s_axi_awlock),         // input [0:0]		s_axi_awlock
        .s_axi_awcache                  (s_axi_awcache),        // input [3:0]		s_axi_awcache
        .s_axi_awprot                   (s_axi_awprot),         // input [2:0]		s_axi_awprot
        .s_axi_awqos                    (s_axi_awqos),          // input [3:0]		s_axi_awqos
        .s_axi_awvalid                  (s_axi_awvalid),        // input			s_axi_awvalid
        .s_axi_awready                  (s_axi_awready),        // output			s_axi_awready
        // Slave Interface Write Data Ports
        .s_axi_wdata                    (s_axi_wdata),          // input [127:0]	s_axi_wdata
        .s_axi_wstrb                    (s_axi_wstrb),          // input [15:0]		s_axi_wstrb
        .s_axi_wlast                    (s_axi_wlast),          // input			s_axi_wlast
        .s_axi_wvalid                   (s_axi_wvalid),         // input			s_axi_wvalid
        .s_axi_wready                   (s_axi_wready),         // output			s_axi_wready
        // Slave Interface Write Response Ports
        .s_axi_bid                      (s_axi_bid),            // output [3:0]		s_axi_bid
        .s_axi_bresp                    (s_axi_bresp),          // output [1:0]		s_axi_bresp
        .s_axi_bvalid                   (s_axi_bvalid),         // output			s_axi_bvalid
        .s_axi_bready                   (s_axi_bready),         // input			s_axi_bready
        // Slave Interface Read Address Ports
        .s_axi_arid                     (s_axi_arid),           // input [3:0]		s_axi_arid
        .s_axi_araddr                   (s_axi_araddr),         // input [26:0]		s_axi_araddr
        .s_axi_arlen                    (s_axi_arlen),          // input [7:0]		s_axi_arlen
        .s_axi_arsize                   (s_axi_arsize),         // input [2:0]		s_axi_arsize
        .s_axi_arburst                  (s_axi_arburst),        // input [1:0]		s_axi_arburst
        .s_axi_arlock                   (s_axi_arlock),         // input [0:0]		s_axi_arlock
        .s_axi_arcache                  (s_axi_arcache),        // input [3:0]		s_axi_arcache
        .s_axi_arprot                   (s_axi_arprot),         // input [2:0]		s_axi_arprot
        .s_axi_arqos                    (s_axi_arqos),          // input [3:0]		s_axi_arqos
        .s_axi_arvalid                  (s_axi_arvalid),        // input			s_axi_arvalid
        .s_axi_arready                  (s_axi_arready),        // output			s_axi_arready
        // Slave Interface Read Data Ports  
        .s_axi_rid                      (s_axi_rid),            // output [3:0]		s_axi_rid
        .s_axi_rdata                    (s_axi_rdata),          // output [127:0]	s_axi_rdata
        .s_axi_rresp                    (s_axi_rresp),          // output [1:0]		s_axi_rresp
        .s_axi_rlast                    (s_axi_rlast),          // output			s_axi_rlast
        .s_axi_rvalid                   (s_axi_rvalid),         // output			s_axi_rvalid
        .s_axi_rready                   (s_axi_rready),         // input			s_axi_rready
        // System Clock Ports
        .sys_clk_i                      (PLL_200MHZ  ),         // input			sys_clk_i
        .sys_rst                        (lock_1      )          // input            sys_rst
    );
endmodule
