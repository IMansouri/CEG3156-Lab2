library ieee;
use ieee.std_logic_1164.all;

entity ALU_8bits_TB is -- testbenches NEVER have ports!
end ALU_8bits_TB;

architecture testbench of ALU_8bits_TB is
        
        signal x_TB, y_TB, s_TB : std_logic_vector(7 downto 0);
        signal op_TB : std_logic_vector(2 downto 0);
        signal carry_TB, zero_TB, overflow_TB, slt_TB : std_logic;
        signal sim_end : boolean := false;
        
        component ALU_8bits is 
	       port(

		        op : in std_logic_vector(2 downto 0);
		        x : in std_logic_vector(7 downto 0);
		        y : in std_logic_vector(7 downto 0);

		        s : out std_logic_vector(7 downto 0);
		        carry : out std_logic;
		        overflow : out std_logic;
		        slt : out std_logic;
		        zero : out std_logic

	       );

        end component ALU_8bits;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          alu : ALU_8bits
                      port map(
	                         
	                         op => op_TB,
		                       x => x_TB,
		                       y => y_TB,

		                       s => s_TB,
		                       carry => carry_TB,
		                       overflow => overflow_TB,
		                       slt => slt_TB,
		                       zero => zero_TB
	                         
	                     );
         

          testbench_process : process
                begin
                  
                  --000 AND
                  --001 OR
                  --010 add
                  --110 subtract
                  --111 set-on-less-than
    
                  x_TB <= "01011001";
                  y_TB <= "00100011";
                  op_TB <= "000"; --AND
                  
                  wait for period;
                  
                  x_TB <= "01011001";
                  y_TB <= "00100011";
                  op_TB <= "001"; --OR
                  
                  wait for period;
                  
                  x_TB <= "01000001";
                  y_TB <= "00100011";
                  op_TB <= "010"; --ADD
                  
                  wait for period;
                  
                  x_TB <= "00000001";
                  y_TB <= "00000001";
                  op_TB <= "110"; --SUB
                  
                  wait for period;
                  
                  x_TB <= "01011001";
                  y_TB <= "00100011";
                  op_TB <= "111"; --SLT
                  
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;
end testbench;
