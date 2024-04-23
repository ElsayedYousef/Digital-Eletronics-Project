library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Define the entity
entity leds is
    Port (
        clk : in STD_LOGIC; 
        reset : in STD_LOGIC;
        play : in STD_LOGIC;
        stop : in STD_LOGIC; 
        LEDs : out STD_LOGIC_VECTOR (17 downto 0));
end leds;

-- Architecture declaration
architecture Behavioral of leds is
    signal led_index : INTEGER range 0 to 15 := 0;
    signal counting_up : BOOLEAN := TRUE;
begin
    -- LED control process
    process(clk, reset)
    begin
        if reset = '1' then
            LEDs <= (others => '0');
            led_index <= 0;
            counting_up <= TRUE;
        elsif rising_edge(clk) then
            -- Initialize all LEDs
            LEDs(15 downto 0) <= (others => '0');
            
            -- Update the specific LED based on the current index
            LEDs(led_index) <= '1';
            
            -- Counting logic
            if counting_up then
                if led_index = 15 then
                    counting_up <= FALSE;
                    led_index <= led_index - 1;
                else
                    led_index <= led_index + 1;
                end if;
            else  -- Counting down
                if led_index = 0 then
                    counting_up <= TRUE;
                    led_index <= led_index + 1;
                else
                    led_index <= led_index - 1;
                end if;
            end if;

            -- Control play/stop LEDs
            if play = '1' then
                LEDs(16) <= '1'; -- Turn on LED16 when playing
            else
                LEDs(16) <= '0';
            end if;

            if stop = '1' then
                LEDs(17) <= '1'; -- Turn on LED17 when stopped
            else
                LEDs(17) <= '0';
            end if;
        end if;
