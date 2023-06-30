library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity testbench is --nothing
end;
architecture test of testbench is
	signal funct_TB: STD_LOGIC_VECTOR( 5 Downto 0);
	signal ALUOp_TB : STD_LOGIC_VECTOR(1 downto 0); -- control signal for testbench
	signal op: STD_LOGIC_VECTOR( 2 Downto 0);   ---output control signal for testbecnh
	signal sim_end : boolean := false;

component ALUControl
  port (
	funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
	ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
	op: OUT STD_LOGIC_VECTOR( 2 Downto 0)
)


constant period: time := 50 ns;

begin
DUT : ALUControl
port map (
funct => funct_TB,
ALUop => ALUop_TB,
op=> op_TB);

clock_process : process
begin
while (not sim_end) loop
CLK_TB <= '1';
wait for period/2;
CLK_TB <= '0';
wait for period/2;
end loop;
wait;

testbench_process : process
                begin
                  RST_TB <= '0', '1' after period;
	---Op(2)<= ALUop(0) OR (funct(1)AND ALUop(1));---
	----Op(1)<= NOT(funct(2)) OR (NOT ALUop(1));----
	-----Op(0)<= ALUop(1) AND (funct(0) OR funct(3));---


		  wait for period 
                  	Op(2) <='01' ----- 00 indicates add for loads and stores-----
			wait for period; -----01 is a subtract for branches (to see if two registers are equal)---------
			Op(1)<='10' --------10 indicates to use the funct field-----
			wait for period;
			Op(0)<='00'
			wait;
	end process;
end testbench;

