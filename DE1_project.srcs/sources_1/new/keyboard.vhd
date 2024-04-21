library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity keyboard is 
port(
    clk		    :   in  std_logic;
    reset    	:   in  std_logic;
    col_i	    :   in  std_logic_vector(2 downto 0);
    row_o	    :   out std_logic_vector(3 downto 0);	
    button_o	:   out std_logic_vector(3 downto 0)
);
end keyboard;

architecture Behavioral of keyboard is
    type   row_type is (row_1, row_2, row_3, row_4);
    signal s_row    : row_type;    
    signal en       : std_logic;

begin
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX   => 10000000 -- 1 for faster simulation, for implementation 10000000 - 100ms with 100MHz signal
        )
        port map(
            clk     => clk,
            reset   => reset,
            ce_o    => en
        );

    p_keyboard: process(clk)
	begin
        if (rising_edge (clk)) then
            if (reset = '1') then
                s_row <= row_1;
                row_o <= "1111";
                button_o <= "1111";
            elsif (en = '1') then
                button_o <= "1111";
                case s_row is
                    when row_1 =>
                        row_o <= "0111";
                        if (col_i = "011") then
                            button_o <= "0001"; -- 1
                        elsif (col_i = "101") then
                            button_o <= "0010"; -- 2
                        elsif (col_i = "110") then
                            button_o <= "0011"; -- 3
                        else
                            s_row <= row_2;
                        end if;
                    when row_2 =>
                        row_o <= "1011";
                        if (col_i = "011") then
                            button_o <= "0100"; -- 4
                        elsif (col_i = "101") then
                            button_o <= "0101"; -- 5
                        elsif (col_i = "110") then
                            button_o <= "0110"; -- 6
                        else
                            s_row <= row_3;
                        end if;
                    when row_3 =>
                        row_o <= "1101";
                        if (col_i = "011") then
                            button_o <= "0111"; -- 7
                        elsif (col_i = "101") then
                            button_o <= "1000"; -- 8
                        elsif (col_i = "110") then
                            button_o <= "1001"; -- 9
                        else
                            s_row <= row_4;
                        end if;
                    when row_4 =>
                        row_o <= "1110";
                        if (col_i = "011") then
                            button_o <= "1010"; -- clear
                        elsif (col_i = "101") then
                            button_o <= "0000"; -- 0
                        elsif (col_i = "110") then
                            button_o <= "1011"; -- enter
                        else
                            s_row <= row_1;
                        end if;
                    when others => s_row <= row_1;
                end case;
            end if;
        end if;
    end process p_keyboard;
end;
