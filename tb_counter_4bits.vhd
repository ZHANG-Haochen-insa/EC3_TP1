library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_counter_4bits is
--  Port ( );
end tb_counter_4bits;

architecture Behavioral of tb_counter_4bits is

    -- Declare the component to be tested
    component counter_4bits is
        Port ( CLOCK     : in  STD_LOGIC;
               DIRECTION : in  STD_LOGIC;
               COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    -- Create signals to connect to the component's ports
    signal tb_clock     : STD_LOGIC := '0';
    signal tb_direction : STD_LOGIC := '1'; -- Initial direction set to increment
    signal tb_count_out : STD_LOGIC_VECTOR (3 downto 0);

    -- Clock period definition
    constant clock_period : time := 10 ns; -- Corresponds to 100 MHz clock

begin

    -- Instantiate Unit Under Test (UUT)
    uut: counter_4bits
        Port map (
            CLOCK     => tb_clock,
            DIRECTION => tb_direction,
            COUNT_OUT => tb_count_out
        );

    -- Clock generation process
    clock_process : process
    begin
        tb_clock <= '0';
        wait for clock_period / 2;
        tb_clock <= '1';
        wait for clock_period / 2;
    end process;

    -- Stimulus generation process
    stimulus_process: process
    begin
        -- Initial state, DIRECTION = '1' (increment)
        report "Starting test: DIRECTION = 1 (increment)";
        wait for 20 * clock_period; -- Wait for 20 clock cycles

        -- Switch direction to decrement
        tb_direction <= '0';
        report "Switching direction: DIRECTION = 0 (decrement)";
        wait for 20 * clock_period; -- Wait for another 20 clock cycles

        -- Switch direction back to increment
        tb_direction <= '1';
        report "Switching direction back: DIRECTION = 1 (increment)";
        wait for 10 * clock_period; -- Wait for another 10 clock cycles

        report "Test finished";
        wait; -- Stop simulation
    end process;

end Behavioral;
