-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : fmc_chn
-- Author : Waj
-------------------------------------------------------------------------------
-- Description:
-- Floppy-Music Controller (1 channel)
-------------------------------------------------------------------------------
-- Total # of FFs: ... tbd ...
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity fmc_chn is
  generic(N : natural := 0 -- channel number
          ); 
  port(rst     : in std_logic;
       clk     : in std_logic;
       -- control inputs
       tick_dur : in std_logic; -- nominal period = 1 ms
       tick_nco : in std_logic; -- nominal period = 1 us
       chn_enb  : in std_logic;
       -- outputs to pins
       fmc_enb  : out std_logic;
       fmc_dir  : out std_logic;
       fmc_stp  : out std_logic
       );
end fmc_chn;

architecture rtl of fmc_chn is

  -- output signals
  signal stp_cnt   : unsigned(6 downto 0);
  signal stp_reg   : std_logic;
  signal dir_reg   : std_logic;
  -- ROM and addressing
  signal rom_addr      : std_logic_vector(c_fmc_rom_aw-1 downto 0);
  signal rom_data      : std_logic_vector(c_fmc_rom_dw-1 downto 0);
  signal duration_cnt  : unsigned(c_fmc_dur_ww-1 downto 0);
  signal tone_duration : unsigned(c_fmc_dur_ww-1 downto 0);
  signal tone_number   : unsigned(c_fmc_tone_ww-1 downto 0);
  signal tone_end_evt  : std_logic;
  -- LUT: tone number ==> NCO seed
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
  -- output assignments
  -----------------------------------------------------------------------------  
  fmc_stp <= stp_reg;
  fmc_dir <= dir_reg;
  
  -----------------------------------------------------------------------------
  -- generate and register FMC outputs
  -----------------------------------------------------------------------------  
  P_out: process(rst, clk)
  begin
    if rst = '1' then
      fmc_enb <= '1';
      stp_reg <= '0';
      dir_reg <= '0';
      stp_cnt <= (others => '0');
    elsif rising_edge(clk) then
      -- set enable active during times when any tone is played
      if tone_number > 0 then
        -- enable is low-active
        fmc_enb <= '0';
      else
        fmc_enb <= '1';
      end if;
      -- connect step output to NCO output (MSB) to generate desired frequency
      stp_reg <= std_logic(nco_reg(nco_reg'left));
      -- toggle direction output after every 80 steps (rising edges on fmc_stp)
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
  -- ROM addressing and tick counting
  -----------------------------------------------------------------------------  
  P_read: process(rst, clk)
  begin
    if rst = '1' then
      duration_cnt <= (others => '0');
      tone_end_evt <= '0';
      rom_addr     <= (others => '0');
    elsif rising_edge(clk) then
      -- default assignment
      tone_end_evt <= '0';
      -- maintain tone duration counter
      if tick_dur = '1' then
        if duration_cnt = tone_duration-1 then
          duration_cnt <= (others => '0');
          tone_end_evt <= '1';
        else
          duration_cnt <= duration_cnt + 1;
        end if;
      end if;
      -- maintain ROM address
      if chn_enb = '0' or tone_duration = c_fmc_last_tone then
        -- restart playing from 1st tone
        rom_addr <= (others => '0');
        duration_cnt <= (others => '0');
      elsif tone_end_evt = '1' then
        rom_addr <= std_logic_vector(unsigned(rom_addr)+1);
      end if;
    end if;
  end process;
      
  -----------------------------------------------------------------------------
  -- NCO (tone frequency generation)
  -----------------------------------------------------------------------------  
  P_nco: process(rst, clk)
  begin
    if rst = '1' then
      seed    <= (others => '0');
      nco_reg <= (others => '0');
    elsif rising_edge(clk) then
      seed    <= to_unsigned(nco_lut(to_integer(tone_number)),13);
      if tick_nco = '1' then
        nco_reg <= nco_reg + seed;
      end if;
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

end rtl;
