library ieee;
use ieee.std_logic_1164.all;

entity song_controller is
    port (
        clk             : in    std_logic;               -- Main clock
        rst             : in    std_logic;               -- Reset button
        next_btn        : in    std_logic;               -- Button to select next song
        prev_btn        : in    std_logic;               -- Button to select previous song
        song_select     : out   std_logic_vector(1 downto 0)  -- Output to select the song
    );
end entity song_controller;

architecture behavioral of song_controller is
    type state_type is (IDLE, NXT, PREV);   
    signal state : state_type := IDLE;       
    signal song_select_out : std_logic_vector(1 downto 0) := "00";  
begin
    -- FSM start
    process (clk, rst, next_btn, prev_btn)
    begin
        if rst = '1' then
            state <= IDLE;
            song_select <= "00"; 
             
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if next_btn = '1' then
                        state <= NXT;
                    elsif prev_btn = '1' then
                        state <= PREV;
                    end if;
                when NXT =>
                    case song_select_out is
                        when "00" =>
                            song_select_out <= "01";
                        when "01" =>
                            song_select_out <= "10"; 
                        when others =>
                            song_select_out <= "00";
                    end case;

                    if next_btn = '0' then
                        state <= IDLE;
                    end if;
                when PREV =>
                    case song_select_out is
                        when "00" =>
                            song_select_out <= "10"; 
                        when "01" =>
                            song_select_out <= "00"; 
                        when others =>
                            song_select_out <= "01"; 
                    end case;
                    if prev_btn = '0' then
                        state <= IDLE;
                    end if;
            end case;
        end if;
        
        song_select <= song_select_out;
    end process;
end architecture behavioral;
