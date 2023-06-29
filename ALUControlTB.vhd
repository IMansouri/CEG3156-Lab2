library IEEE;
use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all;
entity testbench is --nothing
end;
rchitecture test of testbench is
component ALUControl
  port (
	funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
	ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
	op: OUT STD_LOGIC_VECTOR( 2 Downto 0)
)
 signal funct-TB, ALUOp-TB: std_logic; -- control signal for testbench
signal  :std_logic;   ---output control signal for testbecnh

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
end process;

testbench_process : process
                begin
                  RST_TB <= '0', '1' after period;
	---Op(2)<= ALUop(0) OR (funct(1)AND ALUop(1));---
	----Op(1)<= NOT(funct(2)) OR (NOT ALUop(1));----
	-----Op(0)<= ALUop(1) AND (funct(0)OR funct(3));---

		  assert (op_TB(2) = '0')
report "Test 1" severity
error;

		  wait for period 
                  	Op(2) <='0'
			  Op(1)<=''
			  Op(0)<=''

