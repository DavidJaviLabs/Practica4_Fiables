----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2025 12:35:45
-- Design Name: 
-- Module Name: sma_filter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sma_filter is
    generic (
            N     : integer := 4;
            WIDTH : integer := 8
     );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic_vector(WIDTH-1 downto 0);
        load : in  std_logic;
        dout : out std_logic_vector(WIDTH-1 downto 0)
    );
end sma_filter;

architecture Behavioral of sma_filter is

    function numBits(numero:integer) return integer is
        variable valorMul:integer := 1;
        variable resultado:integer := 0;
        
    begin
        while valorMul < numero loop
            valorMul := valorMul * 2;
            resultado := resultado + 1;
        end loop;
        
        return resultado;
    end function;
    
    constant anchoSuma:integer := WIDTH+numBits(N);
    type typeArray is array(0 to N-1) of unsigned(WIDTH-1 downto 0);
    signal datos:typeArray := (others => (others => '0'));
    signal media:unsigned(WIDTH-1 downto 0) := (others => '0');
    
begin

    process(clk, rst)
        variable suma:unsigned(anchoSuma+1 downto 0);
    begin
        if rst = '1' then
            media <= (others => '0');
            datos <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if load = '1' then
                for i in N-1 downto 1 loop
                    datos(i) <= datos(i-1);
                end loop;
                datos(0) <= unsigned(din);
                
                suma := (others => '0');
                
                for i in 0 to N-1 loop
                    suma := suma + datos(i);
                end loop;
                
                media <= shift_right(suma,2) (WIDTH-1 downto 0);
            end if;
        end if;
    end process;
    dout <= std_logic_vector(media);
end architecture;