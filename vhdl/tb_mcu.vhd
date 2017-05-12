-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : tb_mcu
-- Author : Waj
-------------------------------------------------------------------------------
-- Description:
-- Simple testbench for the MCU with clokc and reset generation only.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity tb_mcu is
end tb_mcu;

architecture TB of tb_mcu is

  signal rst        : std_logic;
  signal clk        : std_logic := '0';
  signal gpio_0     : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal gpio_1     : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal fmc_enable : std_logic_vector(c_fmc_num_chn-1 downto 0);
  signal fmc_direct : std_logic_vector(c_fmc_num_chn-1 downto 0);
  signal fmc_step   : std_logic_vector(c_fmc_num_chn-1 downto 0);

   
begin

  -- instantiate MUT
  MUT : entity work.mcu
    port map(
      rst        => rst,
      clk        => clk,
      gpio_0     => gpio_0,
      gpio_1     => gpio_1,
      fmc_enable => fmc_enable,
      fmc_direct => fmc_direct,
      fmc_step   => fmc_step
      );

  -- generate reset
  rst   <= '1', '0' after 5us;

  -- clock generation
  p_clk: process
  begin
    wait for 1 sec / CF/2;
    clk <= not clk;
  end process;
 
end TB;
