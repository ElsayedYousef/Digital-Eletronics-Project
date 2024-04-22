library ieee;
use ieee.std_logic_1164.all;

entity play_pause is
    port (
        clk         : in  std_logic;   -- Main clock
        rst         : in  std_logic;   -- Reset button
        play_pause_btn : in  std_logic;   -- Button input
        en_out  : out std_logic    -- Enable signal output
    );
end entity play_pause;

architecture behavioral of play_pause is
    type state_type is (IDLE, PRESSED);
    signal state : state_type := IDLE;
    -- Internal signal to store the enable state
    signal en_in : std_logic := '1';

begin
    -- FSM process
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;                  -- Reset state to IDLE on reset
            en_in <= '1';         -- Reset enable state
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if play_pause_btn = '1' then      -- If button is pressed
                        state <= PRESSED;      -- Transition to PRESSED state
                    end if;
                when PRESSED =>
                    if play_pause_btn = '0' then      -- If button is released
                        en_in <= not en_in;  -- Toggle enable state
                        state <= IDLE;          -- Transition back to IDLE state
                    end if;
            end case;
        end if;
    end process;

    -- Output the enable state
    en_out <= en_in;

end architecture behavioral;
