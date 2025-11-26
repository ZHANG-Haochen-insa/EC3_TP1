library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity STOPWATCH is
    port 	(  
				CLK : in STD_LOGIC; 
				RESET : in STD_LOGIC;
				STRTSTOP : in STD_LOGIC;
				TENTHSOUT : out STD_LOGIC_VECTOR(9 downto 0);
				ONESOUT, TENSOUT : out STD_LOGIC_VECTOR(6 downto 0)
				);
end STOPWATCH;

architecture structural of STOPWATCH is

component Clk_Div is
    Port		( 
				clk_in : in  STD_LOGIC;
				clk_out : out  STD_LOGIC
			);
end component;

component state_machine
    port 	(     
				CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				STRTSTOP : in STD_LOGIC;
				CLKOUT : out STD_LOGIC;
				RST : out STD_LOGIC
				);
end component;

component tenths is
    Port 	( 
				clk, reset : in  STD_LOGIC;
				clk_enable : in  STD_LOGIC;
				sortie : out  STD_LOGIC_VECTOR (9 downto 0);
				term_count : out  STD_LOGIC
				);
end component;

component cnt60
    port 	(    
				CE : in STD_LOGIC;
				CLK : in STD_LOGIC;
				CLR : in STD_LOGIC;
				LSBSEC : out STD_LOGIC_VECTOR(3 downto 0);
				MSBSEC : out STD_LOGIC_VECTOR(3 downto 0)
				);
end component;

component hex2led
    port 	(
				HEX : in STD_LOGIC_VECTOR(3 downto 0);
				LED : out STD_LOGIC_VECTOR(6 downto 0)
				);
end component;

signal clkenable : STD_LOGIC;
signal divided_clk : STD_LOGIC;
signal rstint : STD_LOGIC;
signal xtermcnt : STD_LOGIC;
signal cnt60enable : STD_LOGIC;
signal lsbcnt : STD_LOGIC_VECTOR(3 downto 0);
signal msbcnt : STD_LOGIC_VECTOR(3 downto 0);

begin

----------------------------------------------------
-- Component Instantiation 
----------------------------------------------------

CLOCK_DV : Clk_Div 
    port map( 	clk_in => CLK,
					clk_out => divided_clk);

MACHINE : state_machine 
	port map(	CLK => divided_clk,
	            RESET => RESET,
					STRTSTOP => STRTSTOP,
					CLKOUT => clkenable,
	            RST => rstint);

TENTH : tenths 
	port map(	clk => divided_clk, 
					reset => rstint,
					clk_enable => clkenable,
					sortie => TENTHSOUT,
					term_count => xtermcnt);

SIXTY: cnt60 
	port map(	CE => cnt60enable,
	            CLK => divided_clk,
	            CLR => rstint,
	            LSBSEC => lsbcnt,
	            MSBSEC => msbcnt);

LSBLED:hex2led 
	port map(	HEX => lsbcnt,
					LED => ONESOUT);

MSBLED:hex2led 
	port map(	HEX => msbcnt,
					LED => TENSOUT);
			
    
cnt60enable <= xtermcnt and clkenable;

end structural;
