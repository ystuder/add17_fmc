----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2017 18:29:03
-- Design Name: 
-- Module Name: fmc_chn - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fmc_chn is
  generic(N : natural := 0 -- channel number
          ); 
  Port ( rst     : in std_logic;
         clk     : in std_logic;
         
         tick_dur : in std_logic; -- nominal period = 1 ms
         tick_nco : in std_logic; -- nominal period = 1 us
         chn_enb  : in std_logic;
         -- outputs to pins
         fmc_enb  : out std_logic;
         fmc_dir  : out std_logic;
         fmc_stp  : out std_logic
       );
end fmc_chn;





architecture Behavioral of fmc_chn is

  signal duration_cnt  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal tone_duration  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal rom_addr      : std_logic_vector(c_fmc_rom_aw-1 downto 0);
  signal rom_data      : std_logic_vector(c_fmc_rom_dw-1 downto 0);
  signal tone_number   : unsigned(c_fmc_tone_ww-1 downto 0);
  signal stp_reg   : std_logic;
  signal dir_reg   : std_logic;

begin

  -----------------------------------------------------------------------------
  -- ROM addressing and tick counting
  -----------------------------------------------------------------------------  
  P_read: process(rst, clk)
  begin
    if rst = '1' then
      duration_cnt <= (others => '0');
      rom_addr     <= (others => '0');
    elsif rising_edge(clk) then
      -- default assignment
      -- maintain tone duration counter
      if tick_dur = '1' then
        if duration_cnt = tone_duration-1 then
          duration_cnt <= (others => '0');
          rom_addr <= std_logic_vector(unsigned(rom_addr)+1);
        else
          duration_cnt <= duration_cnt + 1;
        end if;
      end if;
    end if;
  end process;
  
  P_freq: process(rst, clk)
begin
      if rst = '1' then
      fmc_enb <= '1';
      stp_reg <= '0';
      dir_reg <= '0';
      elsif rising_edge(clk) then
      end if;
end process;


  -----------------------------------------------------------------------------
  -- channel number dependent FMC ROM instance
  -----------------------------------------------------------------------------   
   fmc_stp <= stp_reg;
   fmc_dir <= dir_reg;
  rom : entity work.fmc_rom
    generic map(N => N)
    port map (clk  => clk,
              addr => rom_addr,
              data => rom_data
              );
  tone_duration <= unsigned(rom_data(c_fmc_dur_ww+c_fmc_tone_ww-1 downto c_fmc_tone_ww));
  tone_number   <= unsigned(rom_data(c_fmc_tone_ww-1 downto 0));

end Behavioral;
