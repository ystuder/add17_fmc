-------------------------------------------------------------------------------
-- Project: Hand-made MCU
-- Entity : gpio
-- Author : Waj
-------------------------------------------------------------------------------
-- Description:
-- GPIO block for simple von-Neumann MCU.
-------------------------------------------------------------------------------
-- Total # of FFs: ... tbd ...
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mcu_pkg.all;

entity gpio is
  port(rst        : in    std_logic;
       clk        : in    std_logic;
       -- GPIO bus signals
       bus_in     : in  t_bus2rws;
       bus_out    : out t_rws2bus;
       -- GPIO_1 pin signals
       gpio_0_in  : in  std_logic_vector(c_gpio_port_ww-1 downto 0);
       gpio_0_out : out std_logic_vector(c_gpio_port_ww-1 downto 0);
       gpio_0_enb : out std_logic_vector(c_gpio_port_ww-1 downto 0);
       -- GPIO_2 pin signals
       gpio_1_in  : in  std_logic_vector(c_gpio_port_ww-1 downto 0);
       gpio_1_out : out std_logic_vector(c_gpio_port_ww-1 downto 0);
       gpio_1_enb : out std_logic_vector(c_gpio_port_ww-1 downto 0)
       );
end gpio;

architecture rtl of gpio is

  -- address select signal
  signal addr_sel : t_gpio_addr_sel;
  -- peripheral registers
  signal data_in_0_reg  : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal data_out_0_reg : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal out_enb_0_reg  : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal data_in_1_reg  : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal data_out_1_reg : std_logic_vector(c_gpio_port_ww-1 downto 0);
  signal out_enb_1_reg  : std_logic_vector(c_gpio_port_ww-1 downto 0);
 
begin

  -- output ssignment
  gpio_0_out <= data_out_0_reg;
  gpio_0_enb <= out_enb_0_reg;
  gpio_1_out <= data_out_1_reg;
  gpio_1_enb <= out_enb_1_reg;

  -----------------------------------------------------------------------------
  -- Input register
  -----------------------------------------------------------------------------  
  P_in: process(clk)
  begin
    if rising_edge(clk) then
      data_in_0_reg <= gpio_0_in;
      data_in_1_reg <= gpio_1_in;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Address Decoding (combinationally)
  -----------------------------------------------------------------------------  
  process(bus_in.addr)
  begin
    case bus_in.addr is
      -- Port 0 addresses -----------------------------------------------------
      when c_addr_gpio_0_data_in  => addr_sel <= gpio_0_data_in;
      when c_addr_gpio_0_data_out => addr_sel <= gpio_0_data_out;
      when c_addr_gpio_0_out_enb  => addr_sel <= gpio_0_out_enb;
      -- Port 1 addresses -----------------------------------------------------
      when c_addr_gpio_1_data_in  => addr_sel <= gpio_1_data_in;
      when c_addr_gpio_1_data_out => addr_sel <= gpio_1_data_out;
      when c_addr_gpio_1_out_enb  => addr_sel <= gpio_1_out_enb;
      -- unused addresses -----------------------------------------------------
      when others                 => addr_sel <= none;
    end case;       
  end process;

  -----------------------------------------------------------------------------
  -- Read Access (R and R/W registers)
  -----------------------------------------------------------------------------  
  P_read: process(clk)
  begin
    if rising_edge(clk) then
      -- default assignment
      bus_out.data <= (others => '0');
      -- use address select signal
      case addr_sel is
        -- Port 0 registers --------------------------------------------------
        when gpio_0_data_in  => bus_out.data(c_gpio_port_ww-1 downto 0) <= data_in_0_reg;
        when gpio_0_data_out => bus_out.data(c_gpio_port_ww-1 downto 0) <= data_out_0_reg;
        when gpio_0_out_enb  => bus_out.data(c_gpio_port_ww-1 downto 0) <= out_enb_0_reg;
        -- Port 1 registers --------------------------------------------------
        when gpio_1_data_in  => bus_out.data(c_gpio_port_ww-1 downto 0) <= data_in_1_reg;
        when gpio_1_data_out => bus_out.data(c_gpio_port_ww-1 downto 0) <= data_out_1_reg;
        when gpio_1_out_enb  => bus_out.data(c_gpio_port_ww-1 downto 0) <= out_enb_1_reg;
        -- unused addresses ---------------------------------------------------
        when others          => null;
      end case;       
    end if;      
  end process;

  -----------------------------------------------------------------------------
  -- Write Access (R/W registers only)
  -----------------------------------------------------------------------------  
  P_write: process(clk, rst)
  begin
    if rst = '1' then
      data_out_0_reg <= (others => '0');
      out_enb_0_reg  <= (others => '0');  -- output disabled per default
      data_out_1_reg <= (others => '0');
      out_enb_1_reg  <= (others => '0');  -- output disabled per default
    elsif rising_edge(clk) then
      if bus_in.wr_enb = '1' then
        -- use address select signal only in bus write cycle
        case addr_sel is
          -- Port 0 registers ------------------------------------------------
          when gpio_0_data_out => data_out_0_reg <= bus_in.data(c_gpio_port_ww-1 downto 0);
          when gpio_0_out_enb  => out_enb_0_reg  <= bus_in.data(c_gpio_port_ww-1 downto 0);
          -- Port 1 registers ------------------------------------------------
          when gpio_1_data_out => data_out_1_reg <= bus_in.data(c_gpio_port_ww-1 downto 0);
          when gpio_1_out_enb  => out_enb_1_reg  <= bus_in.data(c_gpio_port_ww-1 downto 0);
          -- unused addresses -------------------------------------------------
          when others          => null;
        end case;       
      end if;
    end if;
  end process;

end rtl;
