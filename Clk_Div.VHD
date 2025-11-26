library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clk_Div is
    Port ( clk_in : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end Clk_Div;

architecture Behavioral of Clk_Div is

signal clkdiv : unsigned(1 downto 0) := "00";  

begin

process (clk_in)
begin 
	if rising_edge (clk_in) then
		clkdiv <= clkdiv + 1;
	end if;
end process;

clk_out <= clkdiv(1);

end Behavioral;

