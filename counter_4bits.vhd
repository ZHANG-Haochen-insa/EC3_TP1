library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_4bits is
    Port ( CLOCK     : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC; -- '1' for increment, '0' for decrement
           COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0));
end counter_4bits;

architecture Behavioral of counter_4bits is
    -- Internal signal for the 4-bit counter
    signal count_int : unsigned (3 downto 0) := (others => '0');
    
    -- Prescaler counter to slow down the visual update rate
    -- Counting to 50,000,000 with a 100MHz clock gives a ~2Hz update rate
    constant PRESCALER_LIMIT : integer := 50000000;
    signal prescaler_counter : integer range 0 to PRESCALER_LIMIT := 0;

begin

    -- This single process now handles both clock division and the 4-bit counting
    process (CLOCK)
    begin
        if rising_edge(CLOCK) then
            -- Check if the prescaler has reached its limit
            if prescaler_counter = PRESCALER_LIMIT - 1 then
                prescaler_counter <= 0; -- Reset the prescaler
                
                -- Update the visible 4-bit counter ONLY when the prescaler finishes counting
                if DIRECTION = '1' then
                    count_int <= count_int + 1; -- Increment
                else
                    count_int <= count_int - 1; -- Decrement
                end if;
                
            else
                -- Just keep incrementing the prescaler
                prescaler_counter <= prescaler_counter + 1;
            end if;
        end if;
    end process;

    -- Connect the internal counter to the output LEDs
    COUNT_OUT <= std_logic_vector(count_int);

end Behavioral;
