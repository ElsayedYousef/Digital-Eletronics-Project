
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity musics_file is
	generic (
        STEPS : integer := 47 --! Default number of clk periodes to generate one pulse
    );
	port(
		  clk					: in 	  std_logic; --! Main clock
		  music_enable   	: in    std_logic; -- Allowing music counter
		  rst					: in 	  std_logic;
		  music_select		: in 	  std_logic_vector(1 downto 0);
		  relay_first  	: out   std_logic;
		  relay_second 	: out   std_logic;
		  relay_third 		: out   std_logic;
		  relay_fourth 	: out   std_logic

		  
 	);
end musics_file;

architecture Behavioral of musics_file is

signal relay_count  : integer range 0 to (STEPS -1);
signal previous_music_select : std_logic_vector(1 downto 0);


signal change			: std_logic;


begin


--- Music selction change

	process(clk)
	begin
		
		if rising_edge(clk) then
			previous_music_select <= music_select;
		end if;
		
	end process;
	
	--Saving if it  changes
	change <= '1' when previous_music_select /= music_select else '0';





--- Step counter for Music

	p_new_clk : process (clk) is
    begin

        if (rising_edge(clk)) then   
               
					if (rst = '1' or change = '1') then                      -- High-active reset
						 relay_count <= 0;
					-- Counting
					elsif (music_enable = '1') then				
					
							if (relay_count < (STEPS -1) and en_out = '1') then
								relay_count <= relay_count + 1;          -- Increment local counter
							-- End of counter reached
							else
							 relay_count <= 0;
							end if;  
							
					end if;
                              
        end if;

    end process p_new_clk;	
	 
	 
	 

---- Musics

		process(relay_count)
		begin
		
				case music_select is
					when "00" => 
				
						case relay_count is
							when 3  => relay_first <= '1';
							when 5  => relay_second <= '1';
							when 10 => relay_third <= '1';
							when 14 => relay_fourth <= '1';
							when 20  => relay_first <= '1';
							when 22  => relay_second <= '1';
							when 30 => relay_third <= '1';
							when 34 => relay_fourth <= '1';
							when 40  => relay_first <= '1';
							when 42 => relay_second <= '1';
							when 46 => relay_third <= '1';							
							when others =>  relay_first <= '0';  relay_second <= '0';  relay_third <= '0';  relay_fourth <= '0';
						end case;
						
					when "01" =>
					
						case relay_count is				
							when 4 => relay_first <= '1';
							when 6 => relay_second <= '1';
							when 12  => relay_third <= '1';
							when 15 => relay_fourth <= '1';
							when 22 => relay_first <= '1';
							when 23 => relay_second <= '1';
							when 24 => relay_third <= '1';
							when 27 => relay_fourth <= '1';
							when 30 => relay_first <= '1';
							when 33 => relay_second <= '1';
							when 40 => relay_third <= '1';
							when 44 => relay_fourth <= '1';
							when others =>  relay_first <= '0';  relay_second <= '0';  relay_third <= '0';  relay_fourth <= '0';
						end case;
						
						
					when "10" =>
					
						case relay_count is				
							when 2 => relay_first <= '1';
							when 5 => relay_second <= '1';
							when 7  => relay_third <= '1';
							when 11 => relay_fourth <= '1';
							when 14 => relay_first <= '1';
							when 16 => relay_second <= '1';
							when 23 => relay_third <= '1';
							when 30 => relay_fourth <= '1';
							when 36 => relay_first <= '1';
							when 37 => relay_second <= '1';
							when 38 => relay_third <= '1';
							when 44 => relay_fourth <= '1';
							when others =>  relay_first <= '0';  relay_second <= '0';  relay_third <= '0';  relay_fourth <= '0';
						end case;
						
						
					when "11" =>
					
						case relay_count is				
							when 4 => relay_first <= '1';
							when 11 => relay_second <= '1';
							when 15  => relay_third <= '1';
							when 21 => relay_fourth <= '1';
							when 25 => relay_first <= '1';
							when 27 => relay_second <= '1';
							when 30 => relay_third <= '1';
							when 36 => relay_fourth <= '1';
							when 40 => relay_first <= '1';
							when 46 => relay_second <= '1';							
							when others =>  relay_first <= '0';  relay_second <= '0';  relay_third <= '0';  relay_fourth <= '0';
						end case;
				
						--cannot change rekay_count because conflict of signals 
				   when others =>  relay_first <= '0';  relay_second <= '0';  relay_third <= '0';  relay_fourth <= '0'; 
			end case;
		end process;	

end Behavioral;

