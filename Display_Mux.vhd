library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Mux is
    Port ( 
        clk  : in  STD_LOGIC; -- System clock (100MHz)
        -- 4-bit inputs for the two digits to display
        ones : in  STD_LOGIC_VECTOR (3 downto 0); -- Seconds digit (0-9)
        tens : in  STD_LOGIC_VECTOR (3 downto 0); -- Tens of seconds digit (0-5)
        -- Outputs for the 7-segment display
        seg  : out STD_LOGIC_VECTOR (6 downto 0); -- Cathode signals (active low)
        an   : out STD_LOGIC_VECTOR (7 downto 0)  -- Anode enables (active low)
    );
end Display_Mux;

architecture Behavioral of Display_Mux is

    -- Component declaration for the BCD-to-7-segment decoder
    component HEX2LED is
        Port ( 
            HEX : in  STD_LOGIC_VECTOR (3 downto 0);
            LED : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    -- A counter to slow down the clock for display refresh
    -- Refresh rate should be high enough to avoid flicker (~100Hz per digit)
    -- With a 100MHz clock, we need a ~200Hz refresh clock (for 2 digits)
    -- 100,000,000 / 200 = 500,000. A 19-bit counter is needed.
    constant REFRESH_LIMIT : integer := 50000; -- Reduced for faster simulation, still fast enough for FPGA
    signal refresh_counter : integer range 0 to REFRESH_LIMIT := 0;

    -- Signal to select which digit to display ('0' for ones, '1' for tens)
    signal digit_select : STD_LOGIC := '0';

    -- Signal to hold the 4-bit data for the currently selected digit
    signal digit_to_decode : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instance of the BCD to 7-segment decoder
    decoder_inst : HEX2LED
        Port map (
            HEX => digit_to_decode,
            LED => seg
        );

    -- Process to generate the refresh clock and toggle the digit selection
    REFRESH_PROC: process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = REFRESH_LIMIT - 1 then
                refresh_counter <= 0;
                digit_select <= not digit_select; -- Switch to the other digit
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
    -- This process acts as a multiplexer for the data and anode signals
    MUX_PROC: process(digit_select, ones, tens)
    begin
        if digit_select = '0' then
            -- Display the 'ones' digit on the first 7-segment display (AN0)
            digit_to_decode <= ones;
            -- AN0 is low to enable, all others are high to disable
            an <= "11111110"; 
        else
            -- Display the 'tens' digit on the second 7-segment display (AN1)
            digit_to_decode <= tens;
            -- AN1 is low to enable, all others are high to disable
            an <= "11111101";
        end if;
    end process;

end Behavioral;
