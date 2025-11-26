library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Use the standard numeric library for unsigned type
use IEEE.NUMERIC_STD.ALL;

entity Clk_Div is
    Port ( clk_in  : in  STD_LOGIC;
           clk_out : out STD_LOGIC);
end Clk_Div;

architecture Behavioral of Clk_Div is

    -- To get a ~100Hz clock from 100MHz, we need to divide by 1,000,000.
    -- We toggle the clock every 500,000 cycles.
    -- The number 500,000 requires 19 bits to be represented (2^19 = 524288).
    -- So we declare a 19-bit unsigned counter.
    signal counter  : unsigned(18 downto 0) := (others => '0');
    
    -- The internal signal for the clock output
    signal clk_out_signal : std_logic := '0';

begin

    process (clk_in)
    begin 
        if rising_edge (clk_in) then
            -- Compare the counter with the target value (500,000 - 1)
            if counter = to_unsigned(499999, 19) then
                -- Reset the counter and flip the output clock signal
                counter <= (others => '0');
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
