library ieee;
use ieee.std_logic_1164.all;

entity singleCycleProc_TB is -- testbenches NEVER have ports!
end singleCycleProc_TB;

architecture testbench of singleCycleProc_TB is

        signal CLK_TB, RST_TB : std_logic; -- control signal for testbench
        
        signal ValueSelect_TB : std_logic_vector(2 downto 0);
        signal MuxOut_TB, pcValueOut_TB : std_logic_vector(7 downto 0);
        signal ALUResult_TB, ReadData1_TB, ReadData2_TB, WriteData_TB, controlInfoOut_TB : std_logic_vector(7 downto 0);
        signal InstructionOut_TB : std_logic_vector(31 downto 0);
        signal BranchOut_TB, ZeroOut_TB, MemWriteOut_TB, RegWriteOut_TB : std_logic;
        signal RegDstOut_TB,JumpOut_TB,MemReadOut_TB,MemtoRegOut_TB,ALUSrcOut_TB : std_logic;
        signal ALUOpOut_TB : std_logic_vector(1 downto 0);
        signal sim_end : boolean := false;
        
        component singleCycleProc is
	       port(
	
              ValueSelect : in std_logic_vector(2 downto 0);
		
		          GClock : in std_logic;
		          GReset : in std_logic;
		
		          MuxOut : out std_logic_vector(7 downto 0);
		          pcValueOut : out std_logic_vector(7 downto 0);
		          ALUResultOut : out std_logic_vector(7 downto 0);
		          ReadData1Out : out std_logic_vector(7 downto 0);
		          ReadData2Out : out std_logic_vector(7 downto 0);
		          WriteDataOut : out std_logic_vector(7 downto 0);
		          controlInfoOut : out std_logic_vector(7 downto 0);
		          InstructionOut : out std_logic_vector(31 downto 0);
		          BranchOut : out std_logic;
		          ZeroOut : out std_logic;
		          MemWriteOut : out std_logic;
		          RegWriteOut : out std_logic;
		          
		          RegDstOut : out std_logic;
		          JumpOut : out std_logic;
		          MemReadOut : out std_logic;
		          MemtoRegOut : out std_logic;
		          ALUOpOut : out std_logic_vector(1 downto 0);
		          ALUSrcOut : out std_logic
	  
	         );
        end component singleCycleProc;
        
        constant period: time := 100 ns; -- used to set the time period for our clock
        
        begin
          bdSR : singleCycleProc
                      port map(
	                         
	                         ValueSelect => ValueSelect_TB,
		
		                       GClock => CLK_TB,
		                       GReset => RST_TB,
		
		                       MuxOut => MuxOut_TB,
		                       pcValueOut => pcValueOut_TB,
		                       ALUResultOut => ALUResult_TB,
		                       ReadData1Out => ReadData1_TB,
		                       ReadData2Out => ReadData2_TB,
		                       WriteDataOut => WriteData_TB,
		                       
		                       controlInfoOut => controlInfoOut_TB,
		                       InstructionOut => InstructionOut_TB,
		                       BranchOut => BranchOut_TB,
		                       ZeroOut => ZeroOut_TB,
		                       MemWriteOut => MemWriteOut_TB,
		                       RegWriteOut => RegWriteOut_TB,
		                       
		                       RegDstOut => RegDstOut_TB,
		                       JumpOut => JumpOut_TB,
		                       MemReadOut => MemReadOut_TB,
		                       MemtoRegOut => MemtoRegOut_TB,
		                       ALUOpOut => ALUOpOut_TB,
		                       ALUSrcOut => ALUSrcOut_TB
	                     );
                      
          
          -- this is our clock process to simulate the clock. It will toggle
          -- every half period (which we defined earlier)
          
          clock_process : process
                begin
                  while (not sim_end) loop
                    CLK_TB <= '1';
                    wait for period/2;
                    CLK_TB <= '0';
                    wait for period/2;
                  end loop;
                  wait;
          end process;

          testbench_process : process
                begin
                  
                  RST_TB <= '1';
                  wait for 50 ns;
                  RST_TB <= '0', '1' after period;
                  wait for period;
                  ValueSelect_TB <= "000";
                  wait for period; -- we let the clock and reset signal stabilize
                  
                  wait for 60000 ns;
                  sim_end <= true; -- signal the end of the stimuli
                  wait;
          end process;
end testbench;
