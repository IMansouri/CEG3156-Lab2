LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity singleCycleProc is
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
end entity singleCycleProc;

architecture rtl of singleCycleProc is

							-- Signals --
	signal pc4, pcValue, pcInc, muxB1, addB, muxB, aluB, memData, controlInfo : std_logic_vector(7 downto 0);
	signal instructionValue : std_logic_vector(31 downto 0);
	signal clk1M,clk100K,clk10K,clk1K,clk100,clk10,clk1 : std_logic;
	
	-- Control Unit --
	signal RegDst,Jump,BranchEQ,BranchNotEQ,MemRead,MemWrite,MemtoReg,ALUSrc,RegWrite, b : std_logic;
	signal ALUOp : std_logic_vector(1 downto 0);
	
	-- Register File --
	signal writeData, rd1, rd2 : std_logic_vector(7 downto 0);
	signal writeReg  : std_logic_vector(2 downto 0);
	
	-- ALU --
	signal aluResult : std_logic_vector(7 downto 0);
	signal aluCarry,aluOverflow,slt,zero : std_logic;
	signal opALU : std_logic_vector(2 downto 0);
	
	-- Jump --
	signal jumpAddr : std_logic_vector(7 downto 0);
	
							-- Components --
	
	component bidirectional_shift_register_8bits is
		port(
		
			in_n : in std_logic_vector(7 downto 0);
			in_bit : in std_logic;
			
			shift : in std_logic;
			leftShift : in std_logic;
			
			load : in std_logic;
			reset : in std_logic;
			clock : in std_logic;
			
			out_vector : out std_logic_vector(7 downto 0);
			out_n : out std_logic
		  
		);
	end component bidirectional_shift_register_8bits;
	
	component ControlUnit is 
		port(

			instruction : in std_logic_vector(5 downto 0);
			
			RegDst : out std_logic;
			BranchEQ : out std_logic;
			BranchNotEQ : out std_logic;
			Jump : out std_logic;
			MemRead : out std_logic;
			MemtoReg : out std_logic;
			ALUOp : out std_logic_vector(1 downto 0);
			MemWrite : out std_logic;
			ALUSrc : out std_logic;
			RegWrite : out std_logic

		);

	end component ControlUnit;
	
	component mux2x1_8bits is
		port(
		
			a : in std_logic_vector(7 downto 0);
			b : in std_logic_vector(7 downto 0);
			s : in std_logic;
		 
			o : out std_logic_vector(7 downto 0)
		 
		);
	end component mux2x1_8bits;
	
	component RegisterFile is
		port(
		
			readReg1 : in std_logic_vector(7 downto 0);
			readReg2 : in std_logic_vector(7 downto 0);
			
			writeReg : in std_logic_vector(7 downto 0);
			writeData : in std_logic_vector(7 downto 0);
			RegWrite : in std_logic;
			
			reset : in std_logic;
			clock : in std_logic;

		 readData1 : out std_logic_vector(7 downto 0);
		 readData2 : out std_logic_vector(7 downto 0)
			
		);
	end component RegisterFile;
	
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
	
	component ALUControl is
	port (
		funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
		ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
		op: OUT STD_LOGIC_VECTOR( 2 Downto 0)
	);
	end component ALUControl;
	
	component eigthbit_adder is 
		port(

			xV : in std_logic_vector(7 downto 0);
			yV : in std_logic_vector(7 downto 0);
			addNot : in std_logic;

			sV : out std_logic_vector(7 downto 0);
			carry : out std_logic;
			overflow : out std_logic

		);

	end component eigthbit_adder;
	
	component shiftByTwo is
		port(
		
			in_n : in std_logic_vector(7 downto 0);
			in_bit : in std_logic;
			
			shift : in std_logic;
			leftShift : in std_logic;
			
			load : in std_logic;
			reset : in std_logic;
			clock : in std_logic;
			
			out_vector : out std_logic_vector(7 downto 0);
		  out_n : out std_logic
		  
		);
	end component shiftByTwo;
	
	component mux2x1_3bits is
		port(
		
			a : in std_logic_vector(2 downto 0);
			b : in std_logic_vector(2 downto 0);
			s : in std_logic;
		 
			o : out std_logic_vector(2 downto 0)
		 
		);
	end component mux2x1_3bits;
	
	component mux8x1_8bits is
		port(
		
			x0 : in std_logic_vector(7 downto 0);
			x1 : in std_logic_vector(7 downto 0);
			x2 : in std_logic_vector(7 downto 0);
			x3 : in std_logic_vector(7 downto 0);
			x4 : in std_logic_vector(7 downto 0);
			x5 : in std_logic_vector(7 downto 0);	
			x6 : in std_logic_vector(7 downto 0);	
			x7 : in std_logic_vector(7 downto 0);
		 
			s : in std_logic_vector(2 downto 0);
		 
			o : out std_logic_vector(7 downto 0)
		 
		);
	end component mux8x1_8bits;
	
	COMPONENT clk_div IS

	 PORT
	   (
		    clock_25Mhz				: IN	STD_LOGIC;
		    clock_1MHz				: OUT	STD_LOGIC;
		    clock_100KHz				: OUT	STD_LOGIC;
		    clock_10KHz				: OUT	STD_LOGIC;
		    clock_1KHz				: OUT	STD_LOGIC;
		    clock_100Hz				: OUT	STD_LOGIC;
		    clock_10Hz				: OUT	STD_LOGIC;
		    clock_1Hz				: OUT	STD_LOGIC);
	
  END  COMPONENT clk_div;
  
  begin
    
    clkDiv : entity work.clk_div(a)
                port map(GClock,clk1M,clk100K,clk10K,clk1K,clk100,clk10,clk1);
  
		pc : entity work.bidirectional_shift_register_8bits(rtl)
				port map(pc4, '0', '0', '0', '1', GReset, clk1M, pcValue);
		
		pcAddJ : entity work.eigthbit_adder(rtl)
					port map(pcValue,"00000100",'0',pcInc);
		
		ROM : lpm_rom
		        GENERIC MAP(LPM_WIDTH => 32 ,
		        LPM_WIDTHAD => 8, 
		        LPM_FILE => "ROM.mif")
                PORT MAP(address => pcValue, 
                        q => instructionValue,
								inclock => GClock,
								outclock => GClock);			
		
		cu : entity work.ControlUnit(rtl)
				port map(instructionValue(31 downto 26),RegDst,BranchEQ,BranchNotEQ,Jump,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
			  
		muxReg : entity work.mux2x1_3bits(rtl)
						port map(instructionValue(18 downto 16), instructionValue(13 downto 11), RegDst, writeReg);
						
		rf : entity work.RegisterFile(rtl)
					port map(instructionValue(23 downto 21),instructionValue(18 downto 16),writeReg,writeData,RegWrite,GReset,clk1M,rd1,rd2);
		
		muxALU : entity work.mux2x1_8bits(rtl)
						port map(rd2,instructionValue(7 downto 0),ALUSrc,aluB);
		
		aluC : entity work.ALUControl(rtl)
					port map(instructionValue(5 downto 0),ALUOp,opALU);
		
		alu : entity work.ALU_8bits(rtl)
					port map(opALU,rd1,aluB,aluResult,aluCarry,aluOverflow,slt,zero);
		
		b <= (BranchEQ and zero) or (BranchNotEQ and not(zero));
				
		shftJ : entity work.shiftByTwo(rtl)
					port map(instructionValue(7 downto 0),'0','0','1','1',GReset,GClock,jumpAddr);
					
		shftB : entity work.shiftByTwo(rtl)
					port map(instructionValue(7 downto 0),'0','0','1','1',GReset,GClock,muxB1);
					
		pcAddB : entity work.eigthbit_adder(rtl)
					port map(pcInc,muxB1,'0',addB);
				
		muxBranch : entity work.mux2x1_8bits(rtl)
						port map(pcInc,addB,b,muxB);
						
		muxJump : entity work.mux2x1_8bits(rtl)
						port map(muxB,jumpAddr,Jump,pc4);
						
		muxMem : entity work.mux2x1_8bits(rtl)
						port map(aluResult,memData,MemtoReg,writeData);
						  
						  
		RAM : lpm_ram_dq
		        GENERIC MAP(LPM_WIDTH => 8 ,
		        LPM_WIDTHAD => 8, 
		        LPM_FILE => "RAM.mif")
                PORT MAP(data => rd2, 
                        address => aluResult, 
                        we => MemWrite,
                        q => memData,
								        inclock => GClock,
								        outclock => GClock);				  					  
				
		controlInfo(7) <= '0';
		controlInfo(6) <= RegDst;
		controlInfo(5) <= Jump;
		controlInfo(4) <= MemRead;
		controlInfo(3) <= MemtoReg;
		controlInfo(2 downto 1) <= ALUOp;
		controlInfo(0) <= ALUSrc;
		
		muxValues : entity work.mux8x1_8bits(rtl)
							port map(pcValue,aluResult,rd1,rd2,writeData,controlInfo,controlInfo,controlInfo,ValueSelect,MuxOut);
		
		InstructionOut <= instructionValue;
		BranchOut <= b;
		ZeroOut <= zero;
		MemWriteOut <= MemWrite;
		RegWriteOut <= RegWrite;
		
		ALUResultOut <= aluResult;
		ReadData1Out <= rd1;
		ReadData2Out <= rd2;
		WriteDataOut <= writeData;
		controlInfoOut <= controlInfo;
		pcValueOut <= pcValue;
		
		
		RegDstOut <= RegDst;
		JumpOut <= Jump;
		MemReadOut <= MemRead;
		MemtoRegOut <= MemtoReg;
		ALUOpOut <= ALUOp;
		ALUSrcOut <= ALUSrc;
    
end rtl;
