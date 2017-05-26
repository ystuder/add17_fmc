################################################################
# Project: Hand-made MCU
# Entity : mcu_pkg
# Author : Waj
################################################################

################################################################
# Timing Constraints
################################################################

# Clock signal 
create_clock -add -name sys_clk -period 12 -waveform {0 6.0} [get_ports {clk}]; 

################################################################
# Physical Constraints
################################################################

# Clock signal 
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports {clk}];
# Reset signal (uses BTN_0 on ZYBO)
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports {rst}]; # BTN_0

# GPIO_0 (8 inputs from ZYBO, one already used as reset)
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[0]}]; # SW_0
#set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[1]}]; # SW_1
#set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[2]}]; # SW_2
#set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[3]}]; # SW_3
#set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[4]}]; # Header JB_N_2
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[1]}]; # BTN_1
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[2]}]; # BTN_2
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports {gpio_0[3]}]; # BTN_3

# GPIO_1 (8 outputs to ZYBO
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[0]}]; # LED_0
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[1]}]; # LED_1
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[2]}]; # LED_2
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[3]}]; # LED_3
#set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[4]}]; # Header JB_N_0
#set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[5]}]; # Header JB_P_0
#set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[6]}]; # Header JB_N_1
#set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 } [get_ports {gpio_1[7]}]; # Header JB_P1

### FMC outputs for Single-Channel Devices ################################################
# FMC Channel 0 (Pmod JE, upper row)
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[0]}];   # JE2
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[0]}]; # JE3
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[0]}]; # JE4

# FMC Channel 1 (Pmod JE, lower row)
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[1]}];   # JE8
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[1]}]; # JE9
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[1]}]; # JE10

### FMC outputs for 8-Channel Devices #####################################################
# FMC Channel 0 (Pmod JB)
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[0]}];   # JB8
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[0]}]; # JB7
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[0]}]; # JB1
# FMC Channel 1 (Pmod JB)
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[1]}];   # JB2
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[1]}]; # JB3
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[1]}]; # JB4
# FMC Channel 2 (Pmod JB/JC)
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[2]}];   # JB10
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[2]}]; # JB9
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[2]}]; # JC8
# FMC Channel 3 (Pmod JC)
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[3]}];   # JC7
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[3]}]; # JC1
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[3]}]; # JC2
# FMC Channel 4 (Pmod JC)
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[4]}];   # JC3
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[4]}]; # JC4
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[4]}]; # JC10
# FMC Channel 5 (Pmod JC/JD)
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[5]}];   # JC9
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[5]}]; # JD8
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[5]}]; # JD7
# FMC Channel 6 (Pmod JD)
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[6]}];   # JD1
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[6]}]; # JD2
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[6]}]; # JD3
# FMC Channel 7 (Pmod JD)
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports {fmc_step[7]}];   # JD4
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {fmc_direct[7]}]; # JD10
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports {fmc_enable[7]}]; # JD9

