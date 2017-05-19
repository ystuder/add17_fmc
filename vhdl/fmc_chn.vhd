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

  signal duration_cnt   : unsigned(c_fmc_dur_ww-1 downto 0);
  signal tone_duration  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal rom_addr       : std_logic_vector(c_fmc_rom_aw-1 downto 0);
  signal rom_data       : std_logic_vector(c_fmc_rom_dw-1 downto 0);
  signal tone_number    : unsigned(c_fmc_tone_ww-1 downto 0);
  signal stp_cnt        : unsigned(6 downto 0);
  signal stp_reg        : std_logic;
  signal dir_reg        : std_logic;
  type t_nco_lut is array (2**c_fmc_tone_ww-1 downto 0) of natural;
  constant nco_lut : t_nco_lut := (
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,7382,6968,6577,6207,5859,5530,5220,4927,4650,4389,4143,3910,3691,
    3484,3288,3104,2930,2765,2610,2463,2325,2195,2071,1955,1845,1742,1644,1552,1465,1383,1305,1232,
    1163,1097,1036,978,923,871,822,776,732,691,652,616,581,549,518,489,461,0);
  -- NCO signals
  signal seed    : unsigned(12 downto 0); -- 13 bit seed
  signal nco_reg : unsigned(23 downto 0); -- 24 bit NCO

begin


  -----------------------------------------------------------------------------
  -- Controll logic at the "time domain"
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


  -----------------------------------------------------------------------------
  -- Generate FMC signal 
  -----------------------------------------------------------------------------
  fmc_stp <= stp_reg;
  fmc_dir <= dir_reg;
  P_freq: process(rst, clk)
  begin
    if rst = '1' then
    fmc_enb <= '1';
    stp_reg <= '0';
    dir_reg <= '0';
    stp_cnt <= (others => '0');
    nco_reg <= (others => '0');
    elsif rising_edge(clk) then      
      if tone_number > 0 then
        -- enable is low-active
        fmc_enb <= '0';
      else
        fmc_enb <= '1';
      end if;
      if tick_nco = '1' then
        nco_reg <= nco_reg + seed;
      end if;
      stp_reg <= std_logic(nco_reg(nco_reg'left)); -- connect MSB of nco_reg to stp_reg
      if stp_reg = '0' and std_logic(nco_reg(nco_reg'left)) = '1' then
        -- rising edge on step output
        if stp_cnt = c_fmc_max_step-1 then 
          stp_cnt <= (others => '0');
          dir_reg <= not dir_reg;
        else
          stp_cnt <= stp_cnt + 1;
        end if;
      end if;
    end if;
  end process;

    
  -----------------------------------------------------------------------------
  -- convert ROM tone number to seed
  -----------------------------------------------------------------------------  
  nco_generating: process(rst, clk)
  begin
    if rst = '1' then
      seed    <= (others => '0');
    elsif rising_edge(clk) then
      seed    <= to_unsigned(nco_lut(to_integer(tone_number)),13);
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- channel number dependent FMC ROM instance
  -----------------------------------------------------------------------------   
  rom : entity work.fmc_rom
    generic map(N => N)
    port map (clk  => clk,
              addr => rom_addr,
              data => rom_data
              );
  tone_duration <= unsigned(rom_data(c_fmc_dur_ww+c_fmc_tone_ww-1 downto c_fmc_tone_ww));
  tone_number   <= unsigned(rom_data(c_fmc_tone_ww-1 downto 0));

end Behavioral;
