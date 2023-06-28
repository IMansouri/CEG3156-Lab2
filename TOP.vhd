LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Top IS
	PORT (
		ValueSelect : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		nextCycle, GClk, GRst : IN STD_LOGIC;
		InstructionOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		MuxOut : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF Top IS
	SIGNAL int_Instruct : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL int_PC, int_aluResult, int_Data1, int_Data2, int_WriteData, int_Other : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL int_ALUOp : STD_LOGIC_VECTOR (1 DOWNTO 0);
	


	COMPONENT MUX8x1_8bit IS
		PORT (
			s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			x0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			x7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

BEGIN
	
	);

	MUX : MUX8x1_8bit 
	PORT MAP(
		s => ValueSelect,
		x0 => int_PC,
		x1 => int_aluResult,
		x2 => int_readData1,
		x3 => int_readData2,
		x4 => int_writeData,
		x5 => int_Other,
		x6 => int_Other,
		x7 => int_Other,
		o => MUXOut
	);

	
END struct;
