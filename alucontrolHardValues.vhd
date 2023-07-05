library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
port (
	funct: IN STD_LOGIC_VECTOR( 5 Downto 0);
	ALUop: IN STD_LOGIC_VECTOR( 1 Downto 0);	
	op: OUT STD_LOGIC_VECTOR( 2 Downto 0)
);
end entity ALUControl;
ARCHITECTURE rtl OF ALUControl IS
BEGIN
	Op(2)<= (not(ALUop(1)) and ALUop(0)) OR (ALUop(1) and not(ALUop(0)) and funct(2) and funct(1));
	
	Op(1)<= (not(ALUop(1)) and ALUop(0)) 
	         OR (not(ALUop(1)) and not(ALUop(0)))
	         OR (ALUop(1) and not(ALUop(0)) and funct(2) and funct(1))
	         OR (ALUop(1) and not(ALUop(0)) and not(funct(2)) and funct(1) and not(funct(0)));
	
	Op(0)<= (ALUop(1) and not(ALUop(0)) and not(funct(2)) and not(funct(1)) and funct(0))
	           OR (ALUop(1) and not(ALUop(0)) and funct(2) and funct(1) and funct(0));
END rtl;
