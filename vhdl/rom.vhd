-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : rom
-- Author : Waj
-------------------------------------------------------------------------------
-- Description: 
-- Program memory for simple von-Neumann MCU with registerd read data output.
-------------------------------------------------------------------------------
-- Total # of FFs: DW
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity rom is
  port(clk     : in    std_logic;
       -- ROM bus signals
       bus_in  : in  t_bus2rom;
       bus_out : out t_rom2bus
       );
end rom;

architecture rtl of rom is

  type t_rom is array (0 to 2**AWROM-1) of std_logic_vector(DW-1 downto 0);
  constant rom_table : t_rom := (
    ---------------------------------------------------------------------------
    -- program code -----------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Opcode    Rdest    Rsrc1    Rsrc2             description
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Basic FMC Test (Testat)
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- configure FMC_CHN_ENB(7:0) to enable all channels
    OPC(setil) & reg(3) & n2slv(16#40#, DW/2),         -- setil r3, 0x40
    OPC(setih) & reg(3) & n2slv(16#03#, DW/2),         -- setih r3, 0x03
    OPC(setil) & reg(4) & n2slv(16#FF#, DW/2),         -- setil r4, 0xFF
    OPC(st)    & reg(4) & reg(3) & "00000",            -- CHN_ENB(7:0) = 0xFF
    -- configure FMC_TMP_CTRL to speed-up factor of 1
    OPC(setil) & reg(3) & n2slv(16#41#, DW/2),         -- setil r3, 0x41
    OPC(setih) & reg(3) & n2slv(16#03#, DW/2),         -- setih r3, 0x03
    OPC(setil) & reg(4) & n2slv(16#40#, DW/2),         -- setil r4, 0x40
    OPC(setih) & reg(4) & n2slv(16#00#, DW/2),         -- setih r4, 0x00
    OPC(st)    & reg(4) & reg(3) & "00000",            -- SPD_FAC(9:0)=0x040=1.00
    OPC(jmp)   & "-00" & n2slv(16#09#, AW-2),          -- jmp 0x009

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- GPIO Test (Task 4) 
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- set GPIO_1(3:0) = LED(3:0) to Output
    OPC(setil) & reg(3) & n2slv(16#05#, DW/2),         -- setil r3, 0x05
    OPC(setih) & reg(3) & n2slv(16#03#, DW/2),         -- setih r3, 0x03
    OPC(setil) & reg(4) & n2slv(16#0F#, DW/2),         -- setil r4, 0x0F
    OPC(st)    & reg(4) & reg(3) & "-----",            -- GPIO_1_OUT_ENB = 0x0F
    -- initialize GPIO_1 data output values (permanently stored in r4) 
    OPC(setil) & reg(3) & n2slv(16#04#, DW/2),         -- setil r3, 0x04
    OPC(setil) & reg(4) & n2slv(16#0C#, DW/2),         -- setil r4, 0x0C (LED(3:0)=1010)
    OPC(st)    & reg(4) & reg(3) & "-----",            -- GPIO_1_DATA_OUT = 0xC0
    -- initilize bit masks for toggling specific bits
    OPC(setil) & reg(5) & n2slv(16#01#, DW/2),         -- setil r5, 0x01 (LED(0))
    OPC(setil) & reg(6) & n2slv(16#06#, DW/2),         -- setil r6, 0x06 (LED(2:1))
    OPC(setil) & reg(7) & n2slv(16#08#, DW/2),         -- setil r7, 0x08 (LED(3))
    ---------------------------------------------------------------------------
    -- addr 10 = 0x00A: start of end-less loop
    -- stop program as long as BTN(3) is pressed
    OPC(setil) & reg(0) & n2slv(16#00#, DW/2),         -- setil r0, 0x00
    OPC(setih) & reg(0) & n2slv(16#03#, DW/2),         -- setih r0, 0x03
    OPC(ld)    & reg(1) & reg(0) & "-----",            -- r0 = GPIO_0_DATA_IN
    OPC(setil) & reg(2) & n2slv(16#80#, DW/2),         -- setil r2, 0x80 (BTN_3 mask)
    OPC(andi)  & reg(1) & reg(2) & reg(1)& "--",       -- apply bit mask     
    OPC(bne)   & "-"    & i2slv(-3, AW),               -- bne -3 (read GPIO again)
    ---------------------------------------------------------------------------
       -- outer for-loop (r2)
       -- init r2 = 6 => 6 * 500 ms = 3 s
       OPC(setil) & reg(2) & n2slv(16#06#, DW/2),         -- setil r2, 0x06
       OPC(setih) & reg(2) & n2slv(16#00#, DW/2),         -- setih r2, 0x00
          -- middle for-loop (r1)
          -- init r1 = 50 = 0x32 => 50 * 10 ms = 500 ms
          OPC(setil) & reg(1) & n2slv(16#32#, DW/2),      -- setil r1, 0x32
          OPC(setih) & reg(1) & n2slv(16#00#, DW/2),      -- setih r1, 0x00
             -- inner for-loop (r0)
             -- init r0 = 52083 = 0xCB73 => 52083 * (8*3) cc = 10 ms
             OPC(setil) & reg(0) & n2slv(16#73#, DW/2),   -- setil r0, 0x73
             OPC(setih) & reg(0) & n2slv(16#CB#, DW/2),   -- setih r0, 0xCB
                -- execute
                iw_nop,                                   -- NOP
                iw_nop,                                   -- NOP
                iw_nop,                                   -- NOP
                iw_nop,                                   -- NOP
                iw_nop,                                   -- NOP
                iw_nop,                                   -- NOP
             -- check condition
             OPC(addil) & reg(0) & i2slv(-1, DW/2),       -- addil r0, -1
             OPC(bne)   & "-"    & i2slv(-7, AW),         -- bne -7
             -- toggle LED(1:0)
             OPC(xori)  & reg(4) & reg(4) & reg(5)& "--", -- apply bit mask     
             OPC(st)    & reg(4) & reg(3) & "-----",      -- write new value to GPIO_1_DATA_OUT
          -- check condition
          OPC(addil) & reg(1) & i2slv(-1, DW/2),          -- addil r1, -1
          OPC(bne)   & "-"    & i2slv(-13, AW),            -- bne -13
          -- toggle LED(3:2)
          OPC(xori)  & reg(4) & reg(4) & reg(6)& "--",    -- apply bit mask     
          OPC(st)    & reg(4) & reg(3) & "-----",         -- write new value to GPIO_1_DATA_OUT
       -- check condition
       OPC(addil) & reg(2) & i2slv(-1, DW/2),             -- addil r2, -1
       OPC(bne)   & "-"    & i2slv(-19, AW),              -- bne -19
       -- toggle LED(3:2)
       OPC(xori)  & reg(4) & reg(4) & reg(7)& "--",       -- apply bit mask     
       OPC(st)    & reg(4) & reg(3) & "-----",            -- write new value to GPIO_1_DATA_OUT
    -- end of end-less loop
    OPC(jmp)   & "-"    & n2slv(16#0A#, AW),              -- jmp 0x00A
    ---------------------------------------------------------------------------
    others => iw_nop                                      -- NOP
         );
  
begin

  -----------------------------------------------------------------------------
  -- sequential process: ROM table with registerd output
  -----------------------------------------------------------------------------  
  P_rom: process(clk)
  begin
    if rising_edge(clk) then
      bus_out.data <= rom_table(to_integer(unsigned(bus_in.addr)));
    end if;
  end process;
  
end rtl;

