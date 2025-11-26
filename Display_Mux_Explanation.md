# `Display_Mux.vhd` 逐行代码详解

本文件详细解释了 `Display_Mux.vhd` 模块的内部工作原理。这个模块的核心功能是使用“分时复用”技术来驱动一个双位数的7段数码管显示器。

---

## 完整代码

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Mux is
    Port ( 
        clk  : in  STD_LOGIC; -- System clock (100MHz)
        ones : in  STD_LOGIC_VECTOR (3 downto 0); -- Seconds digit (0-9)
        tens : in  STD_LOGIC_VECTOR (3 downto 0); -- Tens of seconds digit (0-5)
        seg  : out STD_LOGIC_VECTOR (6 downto 0); -- Cathode signals (active low)
        an   : out STD_LOGIC_VECTOR (7 downto 0)  -- Anode enables (active low)
    );
end Display_Mux;

architecture Behavioral of Display_Mux is

    component HEX2LED is
        Port ( 
            HEX : in  STD_LOGIC_VECTOR (3 downto 0);
            LED : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    constant REFRESH_LIMIT : integer := 50000;
    signal refresh_counter : integer range 0 to REFRESH_LIMIT := 0;

    signal digit_select : STD_LOGIC := '0';

    signal digit_to_decode : STD_LOGIC_VECTOR(3 downto 0);

begin

    decoder_inst : HEX2LED
        Port map (
            HEX => digit_to_decode,
            LED => seg
        );

    REFRESH_PROC: process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = REFRESH_LIMIT - 1 then
                refresh_counter <= 0;
                digit_select <= not digit_select;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
    MUX_PROC: process(digit_select, ones, tens)
    begin
        if digit_select = '0' then
            digit_to_decode <= ones;
            an <= "11111110"; 
        else
            digit_to_decode <= tens;
            an <= "11111101";
        end if;
    end process;

end Behavioral;
```

---

## 代码结构详解

### 1. `entity Display_Mux is ...` (实体声明)

这部分定义了模块的“接口”，即它有哪些输入和输出。

-   `clk`: 输入。这是来自开发板的100MHz主时钟。我们需要一个高速时钟来确保数码管的切换速度足够快，以实现视觉暂留效果。
-   `ones`, `tens`: 输入。这两个4位的端口分别接收要显示的“秒的个位数”和“秒的十位数”的BCD码。
-   `seg`: 输出。这是一个7位的信号，用于控制7段数码管的a,b,c,d,e,f,g这7个段（阴极）。
-   `an`: 输出。这是一个8位的信号，用于控制8个数码管的阳极。我们通过这个信号来选择**哪一个**数码管被点亮。

### 2. `architecture Behavioral of ...` (架构体)

这部分描述了模块的具体行为和内部逻辑。

#### 2.1 `component HEX2LED ...`
-   **作用**: 声明一个我们将要使用的子模块。
-   **解释**: 我们没有在 `Display_Mux` 内部重新发明轮子去写BCD到7段码的转换逻辑，而是直接声明并使用项目中已有的 `HEX2LED.vhd` 模块。

#### 2.2 `constant` 和 `signal` 声明
-   `constant REFRESH_LIMIT ...`: 定义一个常量，值为50000。这是我们内部“刷新计数器”的上限。当100MHz的时钟数50000次，大约耗时0.5毫秒。这意味着数码管的切换频率大约是 `100MHz / 50000 / 2 = 1kHz`，这个频率远高于人眼能分辨的闪烁频率（约60Hz），因此显示看起来是稳定的。
-   `signal refresh_counter ...`: 一个整数计数器，它的唯一作用就是从0数到`REFRESH_LIMIT`，然后归零，循环往复。它就像一个定时器。
-   `signal digit_select ...`: **这是控制切换的核心信号**。它是一个只有一位的信号 (`'0'` 或 `'1'`)。我们让它在`refresh_counter`每次数满时翻转一次。它就像一个开关，用来决定当前是处理“个位数”还是“十位数”。
-   `signal digit_to_decode ...`: 一个临时的4位信号。它的作用是“暂存”当前被选中的数字（`ones` 或 `tens`），然后将这个数字送给`HEX2LED`解码器。

#### 2.3 `decoder_inst : HEX2LED ...` (例化解码器)
-   **作用**: 创建 `HEX2LED` 模块的一个实例。
-   **解释**: 这行代码将 `digit_to_decode` 信号（我们选择要显示的数字）连接到 `HEX2LED` 的输入 `HEX`，并将 `HEX2LED` 的输出 `LED` 连接到本模块的总输出 `seg`。

#### 2.4 `REFRESH_PROC: process(clk) ...` (刷新进程)
-   **作用**: 这是驱动整个复用逻辑的“心跳”或“引擎”。
-   **`if rising_edge(clk) then`**: 确保进程中的所有操作都与时钟同步，在每个时钟的上升沿执行一次。
-   **`if refresh_counter = REFRESH_LIMIT - 1 then`**: 判断“定时器”是否数满。
-   **`digit_select <= not digit_select;`**: **关键行**。如果定时器数满了，就将 `digit_select` 信号翻转（'0'变'1'，'1'变'0'）。正是这个翻转，触发了下面 `MUX_PROC` 进程的切换。
-   **`else refresh_counter <= refresh_counter + 1;`**: 如果定时器没数满，就继续累加。

#### 2.5 `MUX_PROC: process(digit_select, ones, tens) ...` (复用器进程)
-   **作用**: 这是执行实际“选择”操作的逻辑。它根据 `digit_select` 的值来决定输出什么。
-   **`if digit_select = '0' then`**: 当选择信号为'0'时，我们处理**个位数**。
    -   `digit_to_decode <= ones;`: 将个位数 `ones` 的值送去解码。
    -   `an <= "11111110";`: 设置阳极信号。对于低电平有效的阳极，`'0'`代表点亮。这个值的第0位是'0'，意味着**只有第一个数码管(AN0)被点亮**。
-   **`else`**: 当选择信号不为'0'（即为'1'）时，我们处理**十位数**。
    -   `digit_to_decode <= tens;`: 将十位数 `tens` 的值送去解码。
    -   `an <= "11111101";`: 设置阳极信号。这个值的第1位是'0'，意味着**只有第二个数码管(AN1)被点亮**。

通过 `REFRESH_PROC` 和 `MUX_PROC` 这两个进程的精妙配合，模块实现了高速、自动地在两个数码管之间来回切换，从而完成了分时复用显示。
