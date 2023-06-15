library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit_TB is -- testbenches NEVER have ports!
end ControlUnit_TB;

architecture testbench of ControlUnit_TB is
        
        signal RegDst_TB, Branch_TB, Jump_TB, MemtoReg_TB, MemRead_TB, MemWrite_TB,ALUSrc_TB,RegWrite_TB : std_logic;
        signal ALUOp_TB : std_logic_vector(1 downto 0);
        signal instruction_TB : std_logic_vector (5 downto 0);
        signal sim_end : boolean := false;
        
        component ControlUnit is 
	       port(

		        instruction : in std_logic_vector(5 downto 0);
		
		        RegDst : out std_logic;
		        Branch : out std_logic;
		        Jump : out std_logic;
		        MemRead : out std_logic;
		        MemtoReg : out std_logic;
		        ALUOp : out std_logic_vector(1 downto 0);
		        MemWrite : out std_logic;
		        ALUSrc : out std_logic;
		        RegWrite : out std_logic

	       );

        end component ControlUnit;
        
        constant period: time := 50 ns; -- used to set the time period for our clock
        
        begin
          cu : ControlUnit
                      port map(
	                         
	                         instruction => instruction_TB,
		
		                       RegDst => RegDst_TB,
		                       Branch => Branch_TB,
		                       Jump => Jump_TB,
		                       MemRead => MemRead_TB,
		                       MemtoReg => MemtoReg_TB,
		                       ALUOp => ALUOp_TB,
		                       MemWrite => MemWrite_TB,
		                       ALUSrc => ALUSrc_TB,
		                       RegWrite => RegWrite_TB
	                     );
         

          testbench_process : process
                begin
                  
                  instruction_TB <= "000000";
                  wait for period; -- we let the clock and reset signal stabilize
                  instruction_TB <= "000100";
                  wait for period;
                  instruction_TB <= "100011";
                  wait for period;
                  instruction_TB <= "000010";
                  wait for period;
                  instruction_TB <= "101101";
                  wait for period;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;

end testbench;
