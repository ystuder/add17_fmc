################################################################
# Project: ADD Lab 2
# Entity : lab_2_top
# Author : Waj
################################################################

################################################################
# Physical Constraints
################################################################
# GPIO_0 (8 inputs from ZYBO, one already used as reset)
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[0]}]; # SW_0
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[1]}]; # SW_1
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[2]}]; # SW_2
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[3]}]; # SW_3
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[4]}]; # BTN_0
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[5]}]; # BTN_1
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[6]}]; # BTN_2
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[7]}]; # BTN_3

# GPIO_1 (8 outputs to ZYBO
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[0]}]; # LED_0
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[1]}]; # LED_1
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[2]}]; # LED_2
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[3]}]; # LED_3
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[4]}]; # Header JB_N_0
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[5]}]; # Header JB_P_0
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[6]}]; # Header JB_N_1
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[7]}]; # Header JB_P1

