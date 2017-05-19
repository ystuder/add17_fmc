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
    signal fmc_enb  : std_logic_vector(7 downto 0);
    signal fmc_dir  : std_logic_vector(7 downto 0);
    signal fmc_stp  : std_logic_vector(7 downto 0);
    
    signal ctr_dur : unsigned(16 downto 0); -- 0-131071
    signal ctr_nco : unsigned(6 downto 0); -- 0-127
    
    constant ctr_dur_max : unsigned(16 downto 0) := to_unsigned(125000-1, 17);
    constant ctr_nco_max : unsigned(6 downto 0) := to_unsigned(125-1, 7);
    
begin

    tree: for N in 0 to c_fmc_num_chn -1 generate
        chn : entity work.fmc_chn
        generic map(N => N)
        port map(
              rst      => rst,
              clk      => clk,
              
              tick_dur   => tick_dur,
              tick_nco   => tick_nco,
              chn_enb   => chn_enb,
              -- outputs to pins
              fmc_enb   => fmc_enb(N),
              fmc_dir   => fmc_dir(N),
              fmc_stp   => fmc_stp(N)
            );
    end generate;
    
    ctr: process(rst, clk)
    begin
        if rst = '1' then
            ctr_dur <= (others => '0');
            ctr_nco <= (others => '0');
            tick_nco <= '0';
            tick_dur <= '0';
        elsif rising_edge(clk) then
            
            -- NCO counter
            if ctr_nco < ctr_nco_max then
                ctr_nco <= ctr_nco + 1;
                tick_nco <= '0';
            else
                ctr_nco <= (others => '0');
                tick_nco <= '1';
            end if;
            
            -- duration counter
            if ctr_dur < ctr_dur_max then
                ctr_dur <= ctr_dur + 1;
                tick_dur <= '0';
            else
                ctr_dur <= (others => '0');
                tick_dur <= '1';
            end if;
        end if;
    end process;

end rtl;
