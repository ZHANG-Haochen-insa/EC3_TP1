library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine is
  port (
			CLK: in STD_LOGIC;
			reset: in STD_LOGIC;
			strtstop: in STD_LOGIC;
			clkout: out STD_LOGIC;
			rst: out STD_LOGIC);
end state_machine;

architecture Behavioral of state_machine is

   type machine_place is (zero, start, counting, stop, stopped);
   signal state, next_state : machine_place; 

begin

   SYNC_PROC: process (CLK)
   begin
	if rising_edge(CLK) then
         if (reset = '1') then
			   state <= zero;
         else
            state <= next_state;
         end if;        
    end if;
   end process;
 
   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE: process (state)
   begin
      case state is
			when zero => 
				clkout <= '0';
				rst <= '1';
			when start => 
 				clkout <= '1';
				rst <= '0';        
			when counting => 
 				clkout <= '1';
				rst <= '0';  
			when stop => 
 				clkout <= '0';
				rst <= '0'; 
			when stopped => 
 				clkout <= '0';
				rst <= '0';  
			when others => 	
				clkout <= '0';
				rst <= '0';		
			end case;		
   end process;
 
   NEXT_STATE_DECODE: process (state, strtstop)
   begin
 
		next_state <= state;  --default is to stay in current state

      case (state) is
         when zero =>
            if strtstop = '1' then
               next_state <= start;
            end if;
         when start =>
            if strtstop = '0' then
               next_state <= counting;
            end if;
         when counting =>
				if strtstop = '1' then
               next_state <= stop;
				end if;	
         when stop =>
            if strtstop = '0' then
               next_state <= stopped;
            end if;
         when stopped =>
            if strtstop = '1' then
               next_state <= start;
            end if;
         when others =>
            next_state <= zero;
      end case;      
   end process;

end Behavioral;

