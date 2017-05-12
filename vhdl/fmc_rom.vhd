-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : fmc_rom
-- Author : Waj
-------------------------------------------------------------------------------
-- Description:
-- ROM for Floppy-Music Controller (channel-dependent content)
-------------------------------------------------------------------------------
-- Total # of FFs: FMC_ROM_DW
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.mcu_pkg.all;

entity fmc_rom is
  generic(N : natural := 0 -- channel number
          ); 
  port(clk  : in std_logic;
       addr : in  std_logic_vector(c_fmc_rom_aw-1 downto 0);
       data : out std_logic_vector(c_fmc_rom_dw-1 downto 0)
       );
end fmc_rom;

architecture rtl of fmc_rom is

  type t_rom is array (0 to 2**c_fmc_rom_aw-1) of std_logic_vector(c_fmc_rom_dw-1 downto 0);

  impure function f_assign_mif(file_name : in string) return t_rom is       
     FILE     f : text open read_mode is file_name;                   
     variable l : line;
     variable s : string(c_fmc_rom_dw downto 1);
     variable r : t_rom;                                      
  begin                                                        
    for i in t_rom'range loop
      if not endfile(f) then
        -- Note: The last row in .mif should have no CR
        readline(f,l);                             
        read(l,s);
        for k in s'range loop
          if s(k) = '1' then
            r(i)(k-1) := '1';
          else
            r(i)(k-1) := '0';
          end if;
        end loop;
      end if;
    end loop;                                                    
    return r;                                                  
  end function;

  signal rom_table : t_rom := f_assign_mif("fmc_rom_" & character'val(N+48) & ".mif");
  signal data_reg  : std_logic_vector(c_fmc_rom_dw-1 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Behavioral description of ROM with latency of 2 cc
  -----------------------------------------------------------------------------  
  P_rom: process(clk)
  begin
    if rising_edge(clk) then
      data_reg <= rom_table(to_integer(unsigned(addr)));
      data     <= data_reg;
    end if;
  end process;

end rtl;
