set_property PACKAGE_PIN      Y9 [get_ports Sys_Rst_n]
set_property IOSTANDARD LVCMOS15 [get_ports Sys_Rst_n]

set_property PACKAGE_PIN     W19 [get_ports Sys_clk_50mhz]
set_property IOSTANDARD LVCMOS33 [get_ports Sys_clk_50mhz]

set_property PACKAGE_PIN     F16 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

set_property PACKAGE_PIN    C18 [get_ports Tmds_Clk_p]
set_property IOSTANDARD TMDS_33 [get_ports Tmds_Clk_p]
set_property IOSTANDARD TMDS_33 [get_ports Tmds_Clk_n]

set_property PACKAGE_PIN E16 [get_ports {Tmds_data_p[2]}]
set_property PACKAGE_PIN E22 [get_ports {Tmds_data_p[1]}]
set_property PACKAGE_PIN G21 [get_ports {Tmds_data_p[0]}]

set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_n[2]}]

set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_n[1]}]

set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {Tmds_data_n[0]}]

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets PLL_0/inst/Sys_50MHZ_clk_wiz_0]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PLL_0/inst/Sys_50MHZ_clk_wiz_0]





