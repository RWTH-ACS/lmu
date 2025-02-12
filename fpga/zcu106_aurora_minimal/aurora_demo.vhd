----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2022 05:22:21 PM
-- Design Name: 
-- Module Name: aurora_demo - Behavioral
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

use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aurora_demo is
    Port ( clk : in STD_LOGIC;
           reset : out STD_LOGIC;
           m_axis_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           --m_axis_tkeep : out STD_LOGIC_VECTOR (1 downto 0);
           m_axis_tlast : out STD_LOGIC;
           --m_axis_tready : in STD_LOGIC;
           m_axis_tvalid : out STD_LOGIC);
end aurora_demo;

architecture Behavioral of aurora_demo is
	signal timestep_begin : STD_LOGIC := '0';
    signal clk_cnt : integer := 0;
    signal voltage_i : integer := 0;
    signal payload_id : integer := 0;
    signal do_reset : std_logic := '1';
    
    constant send_frequency : integer := 10000;
    --constant clock_frequency : integer := 100e6;    
    constant clock_frequency : integer := 50e6;    
    
    constant voltage1 : integer := 120;
    constant voltage2 : integer := 240;
    constant voltage3 : integer := 1;
begin

--m_axis_tkeep <= (others => '1');
reset <= do_reset;

process (clk, clk_cnt, payload_id, timestep_begin) begin
    if rising_edge(clk) then
            if timestep_begin = '1' then --and m_axis_tready = '0' then
                clk_cnt <= clk_cnt;
            else 
                clk_cnt <= clk_cnt + 1;
            end if;
            if clk_cnt >= 500 then
                do_reset <= '0';
            end if;
            if clk_cnt >= (clock_frequency/send_frequency)-1 then
                timestep_begin <= '1';
                clk_cnt <= 0;
            end if;
            if timestep_begin = '1' then
                case clk_cnt is
                    when 0 =>
                        voltage_i <= voltage_i + 1;
                        if (voltage_i mod 3 = 0) then
                            m_axis_tdata <= std_logic_vector(to_unsigned(voltage1, 16));
                        elsif (voltage_i mod 3 = 1) then
                            m_axis_tdata <= std_logic_vector(to_unsigned(voltage2, 16));
                        elsif (voltage_i mod 3 = 2) then
                            m_axis_tdata <= std_logic_vector(to_unsigned(voltage3, 16));
                        end if;                   
                        m_axis_tvalid <= '1';
                        m_axis_tlast <= '1';
                    when others =>
                        m_axis_tdata <= (others => '0');
                        m_axis_tvalid <= '0';
                        m_axis_tlast <= '0';
                        timestep_begin <= '0';
                end case;
            end if;
        end if;
end process;
    
end Behavioral;
