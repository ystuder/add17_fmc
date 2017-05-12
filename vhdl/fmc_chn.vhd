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
  Port ( rst     : in std_logic;
         clk     : in std_logic;
         tick_dur : in std_logic -- nominal period = 1 ms
       );
end fmc_chn;





architecture Behavioral of fmc_chn is

  signal duration_cnt  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal tone_duration  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal rom_addr      : std_logic_vector(c_fmc_rom_aw-1 downto 0);
  signal rom_data      : std_logic_vector(c_fmc_rom_dw-1 downto 0);

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


end Behavioral;
