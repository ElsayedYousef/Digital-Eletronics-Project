library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        CLK100MHZ : in    std_logic;                     -- Main clock
        rst       : in   std_logic;
        BTNC      : in    std_logic;
        BTNU      : in   std_logic;                      -- play/pause
        JB_1      : out   std_logic;
        JB_2      : out   std_logic;
        JB_3      : out   std_logic;
        JB_4      : out   std_logic;
        MUSIC_SEL : in   std_logic_vector(1 downto 0);    -- Music selection input
        play      : in   std_logic;                      -- Play signal for LEDs
        stop      : in   std_logic;                      -- Stop signal for LEDs
        LEDs      : out  std_logic_vector(24 downto 0);  -- LEDs output
        seg       : out  std_logic_vector(6 downto 0)    -- 7-segment output
    );
end entity top_level;

architecture behavioral of top_level is
    -- Component declaration for clock enable
    component clock_enable is
        generic (
            N_PERIODS : integer
        );
        port (
            clk        : in    std_logic;
            rst        : in    std_logic;
            pulse      : out   std_logic;
            play_pause : in    std_logic
        );
    end component;

    -- Component declaration for simple counter
    component musics_file is
        generic (
            STEPS : integer
        );
        port (
            clk           : in    std_logic;    -- Main clock
            music_enable  : in    std_logic;    -- counter
            rst           : in    std_logic;
            relay_first   : out   std_logic;
            relay_second  : out   std_logic;
            relay_third   : out   std_logic;
            relay_fourth  : out   std_logic
        );
    end component;

    -- Component declaration for play/pause control
    component play_pause is
        port (
            clk             : in  std_logic;    -- Main clock
            rst             : in  std_logic;    -- Reset 
            play_pause_btn  : in  std_logic;    -- Button input
            en_out          : out std_logic     -- Enable signal output
        );
    end component;

    -- Component declaration for LED control
    component leds is
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            play  : in  std_logic;
            stop  : in  std_logic;
            LEDs  : out std_logic_vector(24 downto 0)
        );
    end component;

    -- Component declaration for 7-segment display
    component SevenSegDisplay is
        Port (
            song_number : in  std_logic_vector(1 downto 0);
            seg         : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Internal signals
    signal sig_en        : std_logic;           -- Clock enable signal for 4-bit counter
    signal signal_pause  : std_logic;           -- Pause signal
    signal music_enable  : std_logic;           -- Enable signal for music counter
    signal play_led      : std_logic;           -- Play LED control signal
    signal stop_led      : std_logic;           -- Stop LED control signal

begin

    -- Component instantiation of clock enable for 250 ms
    clk_en0 : clock_enable
        generic map (
            N_PERIODS => 25_000_000
        )
        port map (
            clk         => CLK100MHZ,
            rst         => BTNC,
            pulse       => sig_en,
            play_pause  => signal_pause
        );

    -- Component instantiation of 4-bit simple counter
    counter0 : musics_file
        generic map (
            STEPS => 47
        )
        port map (
            clk           => CLK100MHZ,
            rst           => BTNC,
            music_enable  => music_enable,
            relay_first   => JB_1,
            relay_second  => JB_2,
            relay_third   => JB_3,
            relay_fourth  => JB_4
        );

    -- Component instantiation of play/pause control
    pause0 : play_pause
        port map (
            clk             => CLK100MHZ,
            rst             => BTNC,
            play_pause_btn  => BTNU,
            en_out          => signal_pause
        );

    -- Component instantiation of LED control
    LED_control: leds
        port map (
            clk   => CLK100MHZ,
            reset => BTNC,
            play  => play_led,
            stop  => stop_led,
            LEDs  => LEDs
        );

    -- Component instantiation of 7-segment display
    SevenSeg: SevenSegDisplay
        port map (
            song_number => MUSIC_SEL,
            seg         => seg
        );

    -- Music selection logic
    process(MUSIC_SEL)
    begin
        case MUSIC_SEL is
            when "00" =>
                music_enable <= '1';
            when others =>
                music_enable <= '0';
        end case;
    end process;

    -- Control play/stop LEDs
    process(play, stop)
    begin
        if play = '1' then
            play_led <= '1'; 
        else
            play_led <= '0';
        end if;

        if stop = '1' then
            stop_led <= '1'; 
        else
            stop_led <= '0';
        end if;
    end process;

    -- Assign LEDs output
    LEDs <= "000000000000000000000000" & stop_led & play_led;

end behavioral;