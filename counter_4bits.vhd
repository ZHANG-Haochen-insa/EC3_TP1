library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- 用于支持有符号/无符号类型

entity counter_4bits is
    Port ( CLOCK     : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC; -- '1' 递增, '0' 递减
           COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0));
end counter_4bits;

architecture Behavioral of counter_4bits is
    -- 内部信号，用于计数，使用 unsigned 类型以便进行加减操作
    signal count_int : unsigned (3 downto 0) := (others => '0'); -- 初始化为"0000"
begin

    process (CLOCK)
    begin
        if rising_edge(CLOCK) then
            if DIRECTION = '1' then
                -- 递增计数
                count_int <= count_int + 1;
            else
                -- 递减计数
                count_int <= count_int - 1;
            end if;
        end if;
    end process;

    -- 将内部 unsigned 计数器的值转换为 STD_LOGIC_VECTOR 类型输出
    COUNT_OUT <= std_logic_vector(count_int);

end Behavioral;
