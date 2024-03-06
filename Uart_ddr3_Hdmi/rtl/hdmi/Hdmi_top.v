module Hdmi_top ( 
    input   wire    Pixl_CLK                    ,
    input   wire    Pixl_5xCLK                  ,
    input   wire    Rst_n                       ,
    //RD_hdmi_data
    output  wire            rdata_fifo_rd_en    ,
    input   wire    [15:0]  rdata_fifo_rd_data  ,
    //Tmds
    output  wire            Tmds_Clk_p          ,
    output  wire            Tmds_Clk_n          ,
    output  wire    [2:0]   Tmds_data_p         ,
    output  wire    [2:0]   Tmds_data_n 
);
    //VGA Ports
            wire    [7:0]   RGB_Red_Sign        ;
            wire    [7:0]   RGB_Green_Sign      ;
            wire    [7:0]   RGB_Blue_Sign       ;
            wire            H_Sync_sign         ;
            wire            V_Sync_sign         ;
    //HDMI Encode   
            wire    [9:0]   Encode_Red_10Bit    ;
            wire    [9:0]   Encode_Green_10Bit  ;
            wire    [9:0]   Encode_Blue_10Bit   ;
            wire    [9:0]   Encode_CLK_10Bit    ;
        //serializer Done   
            wire            Pre_Red             ;
            wire            Pre_Green           ;
            wire            Pre_Blue            ;
            wire            Pre_Clk             ;
        //Rst   
            wire            Rst_Posedge         ;
            wire            Rst_Negedge         ;
            wire            VGA_Data_Enable     ;

    assign  rdata_fifo_rd_en = VGA_Data_Enable  ;
    assign  Encode_CLK_10Bit = 10'b11111_00000  ;
    assign  Rst_Negedge      = (!Rst_Posedge)   ;
asyn_rst_syn reset_syn(
    .reset_n    ( Rst_n                 ),
    .clk        ( Pixl_CLK              ),
    .syn_reset  ( Rst_Posedge           )
    );
VGA_Control VGA_Control(
    .Sys_clk                 ( Pixl_CLK                   ),
    .Rst_n                   ( Rst_Negedge                ),

    .rdata_fifo_rd_en        ( VGA_Data_Enable            ),
    .rdata_fifo_rd_data      ( rdata_fifo_rd_data         ),

    .Red_Sign                ( RGB_Red_Sign               ),
    .Green_Sign              ( RGB_Green_Sign             ),
    .Blue_Sign               ( RGB_Blue_Sign              ),
    .H_Sync_sign             ( H_Sync_sign                ),
    .V_Sync_sign             ( V_Sync_sign                ),
    .H_addr                  (                            ),
    .V_addr                  (                            )
);
//Encode VGA_Pixl_2_Tmds
encode Inst0_Blue_EnCode (
	.clkin		( Pixl_CLK          ),
	.rstin		( Rst_Posedge         ),
	.din		( RGB_Blue_Sign     ),
	.c0			( H_Sync_sign       ),
	.c1			( V_Sync_sign       ),
	.de			( VGA_Data_Enable   ),
	.dout		( Encode_Blue_10Bit )) ;

encode Inst0_Green_EnCode (
	.clkin		( Pixl_CLK          ),
	.rstin		( Rst_Posedge       ),
	.din	    ( RGB_Green_Sign    ),
	.c0		    ( 1'b0              ),
	.c1		    ( 1'b0              ),
	.de			( VGA_Data_Enable   ),
	.dout	    ( Encode_Green_10Bit)) ;
	
encode Inst0_Red_EnCode (
	.clkin		( Pixl_CLK          ),
	.rstin		( Rst_Posedge         ),
	.din		( RGB_Red_Sign      ),
	.c0			( 1'b0              ),
	.c1			( 1'b0              ),
	.de			( VGA_Data_Enable   ),
	.dout		( Encode_Red_10Bit  )) ;
//serializer == SelectIO 5:1 == OSERDESE2
serializer_10_to_1 serializer_Blue(
    .reset              ( Rst_Posedge             ), 
    .paralell_clk       ( Pixl_CLK                ), 
    .serial_clk_5x      ( Pixl_5xCLK              ), 
    .paralell_data      ( Encode_Blue_10Bit       ), 

    .serial_data_out    ( Pre_Blue                )  
    );    
    
serializer_10_to_1 serializer_Green(
    .reset              ( Rst_Posedge             ), 
    .paralell_clk       ( Pixl_CLK                ), 
    .serial_clk_5x      ( Pixl_5xCLK              ), 
    .paralell_data      ( Encode_Green_10Bit      ),

    .serial_data_out    ( Pre_Green               )
    );
    
serializer_10_to_1 serializer_Red(
    .reset              ( Rst_Posedge             ), 
    .paralell_clk       ( Pixl_CLK                ), 
    .serial_clk_5x      ( Pixl_5xCLK              ), 
    .paralell_data      ( Encode_Red_10Bit        ),

    .serial_data_out    ( Pre_Red                 )
    );
//CLK
serializer_10_to_1 serializer_Clk(
    .reset              ( Rst_Posedge             ), 
    .paralell_clk       ( Pixl_CLK                ), 
    .serial_clk_5x      ( Pixl_5xCLK              ), 
    .paralell_data      ( Encode_CLK_10Bit        ),

    .serial_data_out    ( Pre_Clk                 )
    );
//OBUFDS
OBUFDS #(
    .IOSTANDARD         ("TMDS_33")    
) TMDS0 (
    .I                  ( Pre_Blue       ),
    .O                  ( Tmds_data_p[0] ),
    .OB                 ( Tmds_data_n[0] ) 
);

OBUFDS #(
    .IOSTANDARD         ("TMDS_33")    
) TMDS1 (
    .I                  ( Pre_Green    ),
    .O                  ( Tmds_data_p[1]),
    .OB                 ( Tmds_data_n[1] ) 
);

OBUFDS #(
    .IOSTANDARD         ("TMDS_33")    
) TMDS2 (
    .I                  ( Pre_Red        ), 
    .O                  ( Tmds_data_p[2] ), 
    .OB                 ( Tmds_data_n[2] )  
);

OBUFDS #(
    .IOSTANDARD         ("TMDS_33")    
) TMDS3 (
    .I                  ( Pre_Clk    ), 
    .O                  ( Tmds_Clk_p ),
    .OB                 ( Tmds_Clk_n ) 
);
endmodule