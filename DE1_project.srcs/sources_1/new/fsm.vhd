library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
    Port ( 
        clk        : in  std_logic;
        reset      : in  std_logic;
        keyboard_i : in  std_logic_vector (4 - 1 downto 0);
        data0_o    : out std_logic_vector (4 - 1 downto 0);
        data1_o    : out std_logic_vector (4 - 1 downto 0);
        data2_o    : out std_logic_vector (4 - 1 downto 0);
        data3_o    : out std_logic_vector (4 - 1 downto 0);
        led_o      : out std_logic_vector (2 - 1 downto 0);
        relay_o    : out std_logic;
        siren_o    : out std_logic
    );
end fsm;

architecture Behavioral of fsm is

-- Define the states
    type t_state is (S_WAIT,
                     S_FIRST,
                     S_SECOND,
                     S_THIRD,
                     S_FORTH,
                     S_CORRECT,
                     S_WRONG
                     );
    -- Define the signal that uses different states
    signal s_state  : t_state;

    -- Internal clock enable
    signal s_en     : std_logic;
    -- Local delay counter
    signal s_cnt    : unsigned(5 - 1 downto 0);

    -- Specific values for local counter
    constant c_DELAY_2SEC   : unsigned(5 - 1 downto 0)  := b"0_1000";
    constant c_DELAY_5SEC   : unsigned(5 - 1 downto 0)  := b"1_0100";
    constant c_ZERO         : unsigned(5 - 1 downto 0)  := b"0_0000";
    
    -- Hardcoded PIN 4321
    constant c_pin0         : std_logic_vector(4 - 1 downto 0) := "0100"; 
    constant c_pin1         : std_logic_vector(4 - 1 downto 0) := "0011";
    constant c_pin2         : std_logic_vector(4 - 1 downto 0) := "0010";
    constant c_pin3         : std_logic_vector(4 - 1 downto 0) := "0001";
    
    -- signals to store typed pin values to compare with the constant
    signal   s_pin0         : std_logic_vector(4 - 1 downto 0); 
    signal   s_pin1         : std_logic_vector(4 - 1 downto 0);
    signal   s_pin2         : std_logic_vector(4 - 1 downto 0);
    signal   s_pin3         : std_logic_vector(4 - 1 downto 0);
    
    signal   s_last         : std_logic_vector(4 - 1 downto 0); -- internal signal to store last pressed value to prevent long press problem
    
begin

--------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 250 ms (4 Hz). Remember that the frequency of the clock 
    -- signal is 100 MHz.
    
    -- JUST FOR SHORTER/FASTER SIMULATION
    -- s_en <= '1';
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 25000000 -- correctly 25000000, for faster simulation 25  -- g_MAX = 250 ms / (1/100 MHz)
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_en
        );

    --------------------------------------------------------------------
    -- p_doorlock_fsm:
    -- The sequential process with synchronous reset and clock_enable 
    -- entirely controls the s_state signal by CASE statement.
    --------------------------------------------------------------------
    p_doorlock_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then         -- Synchronous reset
                s_state    <= S_WAIT;     -- Set initial state
                s_cnt      <= c_ZERO;     -- Clear all bits
                
                data3_o    <= "1111";     -- init digit 3 to blank
                data2_o    <= "1111";     -- init digit 2 to blank
                data1_o    <= "1111";     -- init digit 1 to blank
                data0_o    <= "1111";     -- init digit 0 to blank
                
                led_o      <= "00";       -- turn off dualcolor LED
                relay_o    <= '0';        -- turn off relay
                siren_o    <= '0';        -- turn off siren
                
                s_last     <= "1111";     -- init state

            elsif (s_en = '1' and (keyboard_i = "1111" or keyboard_i /= s_last)) then
                --Every 250 ms, CASE checks the value of the s_state 
                --variable and changes to the next state according 
                -- to the delay value, if the button that was pressed previously is not pressed now
                
                s_last <= keyboard_i;
                
                case s_state is

                    when S_WAIT =>
                        if (keyboard_i /= "1111" and keyboard_i /= "1010" and keyboard_i /= "1011") then
                            -- First number typed
                            s_pin0    <= keyboard_i; -- load it into local signal
                            data3_o   <= keyboard_i; -- show that number on the first digit of display
                            s_state   <= S_FIRST;    -- go to state S_FIRST
                        end if;

                    when S_FIRST =>
                        if (keyboard_i = "1010") then -- clear was pressed
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o   <= "1111";      -- init digit 3 to blank                   
                        elsif (keyboard_i /= "1111" and keyboard_i /= "1011") then
                            -- Second number typed
                            s_pin1    <= keyboard_i; -- load it into local signal
                            data2_o   <= keyboard_i; -- show that number on the second digit of display
                            s_cnt     <= c_ZERO;     -- clear counter bits
                            s_state   <= S_SECOND;   -- go to state S_SECOND
                        elsif (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else -- 2 sec delay is over
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o   <= "1111";     -- init digit 3 to blank
                        end if;
                        
                    when S_SECOND =>
                        if (keyboard_i = "1010") then -- clear was pressed
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o   <= "1111";     -- init digit 3 to blank
                            data2_o   <= "1111";     -- init digit 2 to blank
                        elsif (keyboard_i /= "1111" and keyboard_i /= "1011") then
                            -- Third number typed
                            s_pin2    <= keyboard_i; -- load it into local signal
                            data1_o   <= keyboard_i; -- show that number on the third digit of display
                            s_cnt     <= c_ZERO;
                            s_state   <= S_THIRD;    -- go to state S_THIRD
                        elsif (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            s_cnt      <= c_ZERO;
                            s_state    <= S_WAIT;
                            data3_o    <= "1111";     -- init digit 3 to blank
                            data2_o    <= "1111";     -- init digit 2 to blank
                        end if;
                      
                    when S_THIRD =>
                        if (keyboard_i = "1010") then -- clear was pressed
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o    <= "1111";     -- init digit 3 to blank
                            data2_o    <= "1111";     -- init digit 2 to blank
                            data1_o    <= "1111";     -- init digit 1 to blank
                        elsif (keyboard_i /= "1111" and keyboard_i /= "1011") then
                            -- Forth number typed
                            s_pin3    <= keyboard_i; -- load it into local signal
                            data0_o   <= keyboard_i; -- show that number on the forth digit of display
                            s_cnt     <= c_ZERO;
                            s_state   <= S_FORTH;    -- go to state S_FORTH
                        elsif (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o    <= "1111";     -- init digit 3 to blank
                            data2_o    <= "1111";     -- init digit 2 to blank
                            data1_o    <= "1111";     -- init digit 1 to blank
                        end if;
                        
                    when S_FORTH =>
                        if (keyboard_i = "1010") then -- clear was pressed
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o   <= "1111";     -- init digit 3 to blank
                            data2_o   <= "1111";     -- init digit 2 to blank
                            data1_o   <= "1111";     -- init digit 1 to blank
                            data0_o   <= "1111";     -- init digit 0 to blank
                        elsif (keyboard_i = "1011") then -- enter was pressed
                            data3_o   <= "1111";     -- init digit 3 to blank
                            data2_o   <= "1111";     -- init digit 2 to blank
                            data1_o   <= "1111";     -- init digit 1 to blank
                            data0_o   <= "1111";     -- init digit 0 to blank
                            s_cnt     <= c_ZERO;
                            if (s_pin0 = c_pin0 and s_pin1 = c_pin1 and s_pin2 = c_pin2 and s_pin3 = c_pin3) then 
                                -- pin correct
                                relay_o   <= '1';    -- open the door
                                led_o     <= "01";   -- show green light
                                s_state   <= S_CORRECT;  -- go to state S_CORRECT
                            else
                                -- pin incorrect
                                siren_o   <= '1';    -- turn on siren
                                led_o     <= "10";   -- show red light
                                s_state   <= S_WRONG;    -- go to state S_WRONG
                            end if;
                        elsif (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            s_cnt     <= c_ZERO;
                            s_state   <= S_WAIT;
                            data3_o   <= "1111";     -- init digit 3 to blank
                            data2_o   <= "1111";     -- init digit 2 to blank
                            data1_o   <= "1111";     -- init digit 1 to blank
                            data0_o   <= "1111";     -- init digit 0 to blank
                        end if;
                      
                    when S_CORRECT =>
                        if (s_cnt < c_DELAY_5SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            relay_o   <= '0';    -- turn off relay
                            led_o     <= "00";   -- turn off LED
                            -- Move to the next state
                            s_state <= S_WAIT;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                        
                    when S_WRONG =>
                        if (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            siren_o   <= '0';    -- turn off siren
                            led_o     <= "00";   -- turn off LED
                            -- Move to the next state
                            s_state <= S_WAIT;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                                    
                    -- It is a good programming practice to use the 
                    -- OTHERS clause, even if all CASE choices have 
                    -- been made. 
                    when others =>
                        s_state <= S_WAIT;

                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_doorlock_fsm;

end Behavioral;
