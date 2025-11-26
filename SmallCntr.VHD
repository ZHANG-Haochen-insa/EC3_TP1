library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity smallcntr is
    port (  
				CE : in STD_LOGIC;
				CLK : in STD_LOGIC;
				CLR : in STD_LOGIC;
				QOUT : out STD_LOGIC_VECTOR(3 downto 0)
			);
end smallcntr;

architecture inside of smallcntr is

signal qoutsig : unsigned(3 downto 0);
    
begin

process(CE,CLK,CLR)
    begin
		if(CLR='1') then
			qoutsig <= (others => '0');
		elsif rising_edge (CLK)then
			if (CE='1') then  
				if(qoutsig="1001") then
					qoutsig<= (others => '0');
				else
					qoutsig<=qoutsig + 1;
				end if;
			end if;
		end if;
 end process;
	
QOUT <= std_logic_vector (qoutsig);
    
end inside;

