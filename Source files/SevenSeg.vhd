library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration
entity SevenSegDisplay is
    Port ( song_number : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit input to represent 4 songs
           seg : out  STD_LOGIC_VECTOR(6 downto 0)); -- 7-segment output (a, b, c, d, e, f, g)
end SevenSegDisplay;

-- Architecture declaration
architecture Behavioral of SevenSegDisplay is
begin
    -- Process to determine output based on song_number
    process(song_number)
    begin
        case song_number is
            when "00" => seg <= "0000110"; -- Display "1" on the 7-segment
            when "01" => seg <= "1011011"; -- Display "2" on the 7-segment
            when "10" => seg <= "1001111"; -- Display "3" on the 7-segment
            when "11" => seg <= "1100110"; -- Display "4" on the 7-segment
            when others => seg <= "1111111"; -- Default case, all segments off
        end case;
    end process;
end Behavioral;
