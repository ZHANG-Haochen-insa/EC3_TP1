library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clk_Div is
    Port ( clk_in  : in  STD_LOGIC;
           clk_out : out STD_LOGIC);
end Clk_Div;

architecture Behavioral of Clk_Div is

    -- To get a ~100Hz clock from a 100MHz input clock, we need to divide by 1,000,000.
    -- To create a 50% duty cycle clock, we will toggle the output every 500,000 cycles.
    constant MAX_COUNT : integer := 500000;
    
    signal counter  : integer range 0 to MAX_COUNT - 1 := 0;
    signal clk_out_signal : std_logic := '0';

begin

    process (clk_in)
    begin 
        if rising_edge (clk_in) then
            if counter = MAX_COUNT - 1 then
                -- When counter reaches the limit, reset it and flip the output clock signal
                counter <= 0;
                clk_out_signal <= not clk_out_signal;
            else
                -- Otherwise, just keep counting
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    -- Assign the internal toggling signal to the final output
    clk_out <= clk_out_signal;

end Behavioral;