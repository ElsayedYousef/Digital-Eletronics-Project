library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (
        CLK100MHZ  : in  std_logic; -- CLOCK
        BTN0       : in  std_logic; -- RST button
        
        IO41       : in  std_logic; -- COL1
        IO40       : in  std_logic; -- COL2
        IO39       : in  std_logic; -- COL3
        
        IO38       : out std_logic; -- ROW1
        IO37       : out std_logic; -- ROW2
        IO36       : out std_logic; -- ROW3
        IO35       : out std_logic; -- ROW4
        
        IO7        : out std_logic; -- A
        IO8        : out std_logic; -- B
        IO10       : out std_logic; -- C
        IO12       : out std_logic; -- D
        IO13       : out std_logic; -- E
        IO34       : out std_logic; -- F
        IO9        : out std_logic; -- G
        IO11       : out std_logic; -- DP
        
        IO6        : out std_logic; -- A1
        IO33       : out std_logic; -- A2
        IO32       : out std_logic; -- A3
        IO5        : out std_logic; -- A4
        
        IO31       : out std_logic; -- Relay
        
        IO3        : out std_logic; -- RED LED
        IO30       : out std_logic; -- GREEN LED
        
        IO4        : out std_logic  -- Siren
        
     );
end top;

architecture Behavioral of top is

-- internal signals
signal s_keyboard : std_logic_vector (4 - 1 downto 0);
signal s_data3    : std_logic_vector (4 - 1 downto 0);
signal s_data2    : std_logic_vector (4 - 1 downto 0);
signal s_data1    : std_logic_vector (4 - 1 downto 0);
signal s_data0    : std_logic_vector (4 - 1 downto 0);


begin

fsm : entity work.fsm
    port map(
        clk        => CLK100MHZ,
        reset      => BTN0,
        keyboard_i => s_keyboard,
        data0_o    => s_data0,
        data1_o    => s_data1,
        data2_o    => s_data2,
        data3_o    => s_data3,
        led_o(0)   => IO30,
        led_o(1)   => IO3,
        relay_o    => IO31,
        siren_o    => IO4
    );
    
keyboard : entity work.keyboard
    port map(
        clk		  => CLK100MHZ, 
        reset     => BTN0,
        col_i(2)  => IO41,
        col_i(1)  => IO40,
        col_i(0)  => IO39,   
        row_o(3)  => IO38,
        row_o(2)  => IO37,
        row_o(1)  => IO36,
        row_o(0)  => IO35,
        button_o  => s_keyboard	
    );
    
driver_7seg_4digits : entity work.driver_7seg_4digits
    port map(
         clk      => CLK100MHZ,   
         reset    => BTN0,
         
         data0_i  => s_data0,
         data1_i  => s_data1,
         data2_i  => s_data2,
         data3_i  => s_data3,
         
         dp_i     => "1111",
         
         dp_o     => IO11,
         
         seg_o(6) => IO7, 
         seg_o(5) => IO8, 
         seg_o(4) => IO10,
         seg_o(3) => IO12,
         seg_o(2) => IO13,
         seg_o(1) => IO34,
         seg_o(0) => IO9,
         
         dig_o(3) => IO6,  
         dig_o(2) => IO33, 
         dig_o(1) => IO32, 
         dig_o(0) => IO5  
    );


end Behavioral;
