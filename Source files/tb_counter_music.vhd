-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 23.4.2024 13:25:53 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_enable is
end tb_clock_enable;

architecture tb of tb_clock_enable is

    component clock_enable
	 generic (
            N_PERIODS : integer
        );
        port (clk   : in std_logic;
              rst   : in std_logic;
              pulse : out std_logic);
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal pulse : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clock_enable
	 generic map (
            N_PERIODS => 6
        )
    port map (clk   => clk,
              rst   => rst,
              pulse => pulse);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clock_enable of tb_clock_enable is
    for tb
    end for;
end cfg_tb_clock_enable;