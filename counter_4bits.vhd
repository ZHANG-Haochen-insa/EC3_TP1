library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For signed/unsigned type support

entity counter_4bits is
    Port ( CLOCK     : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC; -- '1' for increment, '0' for decrement
           COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0));
end counter_4bits;

architecture Behavioral of counter_4bits is
    -- Internal signal for counting, using unsigned type for arithmetic operations
    signal count_int : unsigned (3 downto 0) := (others => '0'); -- Initialize to "0000"
begin

    process (CLOCK)
    begin
        if rising_edge(CLOCK) then
            if DIRECTION = '1' then
                -- Increment count
                count_int <= count_int + 1;
            else
                -- Decrement count
                count_int <= count_int - 1;
            end if;
        end if;
    end process;

    -- Convert internal unsigned counter value to STD_LOGIC_VECTOR type output
    COUNT_OUT <= std_logic_vector(count_int);

end Behavioral;
