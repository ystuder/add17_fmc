-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : fmc_top
-- Author : Waj
-------------------------------------------------------------------------------
-- Description: 
-- Top-level of Floppy-Music Controller peripheral module in MCU.
-------------------------------------------------------------------------------
-- Total # of FFs: 0
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity fmc_top is
  generic(CF : natural := CF
          ); 
  port(rst     : in    std_logic;
       clk     : in    std_logic;
       -- FMC bus signals
       bus_in  : in  t_bus2rws;
       bus_out : out t_rws2bus;
       -- FMC pin signals
       fmc_enable : out  std_logic_vector(c_fmc_num_chn-1 downto 0);
       fmc_direct : out  std_logic_vector(c_fmc_num_chn-1 downto 0);
       fmc_step   : out  std_logic_vector(c_fmc_num_chn-1 downto 0)
       );
end fmc_top;

architecture rtl of fmc_top is

    signal tick_dur : std_logic; -- nominal period = 1 ms
    signal tick_nco : std_logic; -- nominal period = 1 us
    signal chn_enb  : std_logic;
    -- outputs to pins
    signal fmc_enb  : std_logic;
    signal fmc_dir  : std_logic;
    signal fmc_stp  : std_logic;

begin

    tree: for N in 1 to c_fmc_num_chn generate
        chn : entity work.fmc_chn
        generic map(N => N)
        port map(
              rst      => rst,
              clk      => clk,
              
              tick_dur   => tick_dur,
              tick_nco   => tick_nco,
              chn_enb   => chn_enb,
              -- outputs to pins
              fmc_enb   => fmc_enb,
              fmc_dir   => fmc_dir,
              fmc_stp   => fmc_stp
            );
    end generate;

end rtl;
