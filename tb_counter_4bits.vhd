library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_counter_4bits is
--  Port ( );
end tb_counter_4bits;

architecture Behavioral of tb_counter_4bits is

    -- 申明要测试的组件
    component counter_4bits is
        Port ( CLOCK     : in  STD_LOGIC;
               DIRECTION : in  STD_LOGIC;
               COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    -- 创建连接到组件的信号
    signal tb_clock     : STD_LOGIC := '0';
    signal tb_direction : STD_LOGIC := '1'; -- 初始方向设置为递增
    signal tb_count_out : STD_LOGIC_VECTOR (3 downto 0);

    -- 时钟周期定义
    constant clock_period : time := 10 ns; -- 对应 100 MHz 时钟

begin

    -- 实例化待测试单元 (Unit Under Test, UUT)
    uut: counter_4bits
        Port map (
            CLOCK     => tb_clock,
            DIRECTION => tb_direction,
            COUNT_OUT => tb_count_out
        );

    -- 时钟生成进程
    clock_process : process
    begin
        tb_clock <= '0';
        wait for clock_period / 2;
        tb_clock <= '1';
        wait for clock_period / 2;
    end process;

    -- 激励生成进程
    stimulus_process: process
    begin
        -- 初始状态，DIRECTION = '1' (递增)
        report "开始测试: 方向 = 1 (递增)";
        wait for 20 * clock_period; -- 等待20个时钟周期

        -- 切换方向为递减
        tb_direction <= '0';
        report "切换方向: 方向 = 0 (递减)";
        wait for 20 * clock_period; -- 再等待20个时钟周期

        -- 再次切换方向为递增
        tb_direction <= '1';
        report "再次切换方向: 方向 = 1 (递增)";
        wait for 10 * clock_period; -- 再等待10个时钟周期

        report "测试结束";
        wait; -- 停止仿真
    end process;

end Behavioral;
