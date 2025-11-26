library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tenths is
    Port ( 
				clk, reset : in  STD_LOGIC;
				clk_enable : in  STD_LOGIC;
				sortie : out  STD_LOGIC_VECTOR (9 downto 0);
				term_count : out  STD_LOGIC);
end tenths;

architecture Behavioral of tenths is

signal count : integer;

begin

process (clk, reset) 

begin
   if  reset ='1' then count <= 0 ;
		elsif rising_edge (clk) then
			if clk_enable='1' then
				if count = 10 then
					count <= 0;
				else 
					count <= count + 1;
				end if;
			end if;	
   end if;
end process;

process (count)
begin
	case count is 
		when 0 => sortie <= "0000000001";
		when 1 => sortie <= "0000000010";
		when 2 => sortie <= "0000000100";
		when 3 => sortie <= "0000001000";
		when 4 => sortie <= "0000010000";
		when 5 => sortie <= "0000100000";
		when 6 => sortie <= "0001000000";
		when 7 => sortie <= "0010000000";
		when 8 => sortie <= "0100000000";
		when 9 => sortie <= "1000000000";
		when others => sortie <= "0000000000";
	end case;
end process;	
			
term_count <= '1' when count = 10 else '0';

end Behavioral;
