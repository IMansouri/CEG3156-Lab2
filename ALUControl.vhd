library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
port (
	funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
	ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
	op: OUT STD_LOGIC_VECTOR( 2 Downto 0);
)
end ALUControl;
ARCHITECTURE rtl OF ALUControl IS
BEGIN
	Op(2)<= ALUop(0) OR (funct(1)AND ALUop(1));
	Op(1)<= NOT(funct(2)) OR (NOT ALUop(1));
	Op(0)<= ALUop(1) AND (funct(0)OR funct(3));
END rtl;
