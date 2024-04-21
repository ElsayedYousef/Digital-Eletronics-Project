library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_keyboard is
--  Port ( );
end tb_keyboard;

architecture testbench of tb_keyboard is
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_col	    : std_logic_vector(2 downto 0);
    signal s_row	    : std_logic_vector(3 downto 0);
    signal s_button     : std_logic_vector(3 downto 0);	
begin
    uut_keyboard : entity work.keyboard
        port map(
            clk     => s_clk_100MHz,
            reset   => s_reset,
            col_i   => s_col,
            row_o   => s_row,
            button_o => s_button 
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        report "running keyboard tests" severity note;
        
        s_reset <= '0'; wait for 10 ns;
        s_reset <= '1'; wait for 10 ns;
        assert(s_button = "1111") report "Test failed for (RESET)" severity error;
        
        s_reset <= '0'; wait for 15 ns;
        
        s_col <= "111"; wait for 40 ns;
        assert(s_button = "1111") report "Test failed for (NO INPUT)" severity error;
        
        s_col <= "011"; wait for 40 ns;
        assert(s_button = "0001") report "Test failed for (1)" severity error;
        
        s_col <= "101"; wait for 40 ns;
        assert(s_button = "0010") report "Test failed for (2)" severity error;
        
        s_col <= "110"; wait for 40 ns;
        assert(s_button = "0011") report "Test failed for (3)" severity error;
        
        s_col <= "111"; wait for 10 ns;
        
        s_col <= "011"; wait for 20 ns;
        assert(s_button = "0100") report "Test failed for (4)" severity error;
        
        s_col <= "101"; wait for 20 ns;
        assert(s_button = "0101") report "Test failed for (5)" severity error;
        
        s_col <= "110"; wait for 20 ns;
        assert(s_button = "0110") report "Test failed for (6)" severity error;
        
        s_col <= "111"; wait for 10 ns;
        
        s_col <= "011"; wait for 30 ns;
        assert(s_button = "0111") report "Test failed for (7)" severity error;
        
        s_col <= "101"; wait for 30 ns;
        assert(s_button = "1000") report "Test failed for (8)" severity error;
        
        s_col <= "110"; wait for 30 ns;
        assert(s_button = "1001") report "Test failed for (9)" severity error;
        
        s_col <= "111"; wait for 10 ns;
        
        s_col <= "011"; wait for 40 ns;
        assert(s_button = "1010") report "Test failed for (CLEAR)" severity error;
        
        s_col <= "101"; wait for 40 ns;
        assert(s_button = "0000") report "Test failed for (0)" severity error;
        
        s_col <= "110"; wait for 40 ns;
        assert(s_button = "1011") report "Test failed for (ENTER)" severity error;
        
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end testbench;
