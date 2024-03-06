// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Sat Nov  4 22:35:51 2023
// Host        : LAPTOP-H1858A6E running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/three_verilog/Uart_ddr3_Hdmi/project_1/project_1.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_50MHZ, clk_100MHZ, clk_200MHZ, reset, locked, 
  Sys_50MHZ)
/* synthesis syn_black_box black_box_pad_pin="clk_50MHZ,clk_100MHZ,clk_200MHZ,reset,locked,Sys_50MHZ" */;
  output clk_50MHZ;
  output clk_100MHZ;
  output clk_200MHZ;
  input reset;
  output locked;
  input Sys_50MHZ;
endmodule