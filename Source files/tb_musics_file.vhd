-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 18.4.2024 09:25:29 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_musics_file is
end tb_musics_file;

architecture tb of tb_musics_file is

    component musics_file
	 generic (
            STEPS : integer
        );
        port (clk          : in std_logic;
              music_enable : in std_logic;
              rst          : in std_logic;
              music_select : in std_logic_vector (1 downto 0);
              relay_first  : out std_logic;
              relay_second : out std_logic);
    end component;

    signal clk          : std_logic;
    signal music_enable : std_logic;
    signal rst          : std_logic;
    signal music_select : std_logic_vector (1 downto 0);
    signal relay_first  : std_logic;
    signal relay_second : std_logic;
    

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : musics_file
	 generic map (
            STEPS => 47
        )
    port map (clk          => clk,
              music_enable => music_enable,
              rst          => rst,
              music_select => music_select,
              relay_first  => relay_first,
              relay_second => relay_second);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        music_enable <= '0';
        
        music_select <= (others => '0');
		  rst <= '1';
        wait for 100 ns;
        rst <= '0';
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  
        --wait for 100 ns;
		  --music_enable <= '1';
		  
		  
		  music_select <= "01";
		  
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  wait for 20 ns;
		  music_enable <= '0';
		  wait for 20 ns;
		  music_enable <= '1';
		  
		  
		  
		  
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_musics_file of tb_musics_file is
    for tb
    end for;
end cfg_tb_musics_file;