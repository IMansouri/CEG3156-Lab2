LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux2x1_8bit is
	port(
	
		s : in std_logic;
		i1 : in std_logic_vector(7 downto 0);
    		i2 : in std_logic_vector(7 downto 0);
		o : out std_logic_vector(7 downto 0)
	
	);
end entity mux2x1_8bit;

architecture rtl of mux2x1_8bit is

	begin
	
		o(0) <= (i1(0) and not(s)) or (i2(0) and s);
		o(1) <= (i1(1) and not(s)) or (i2(1) and s); 
		o(2) <= (i1(2) and not(s)) or (i2(2) and s); 
		o(3) <= (i1(3) and not(s)) or (i2(3) and s);
		o(4) <= (i1(4) and not(s)) or (i2(4) and s);
		o(5) <= (i1(5) and not(s)) or (i2(5) and s);
		o(6) <= (i1(6) and not(s)) or (i2(6) and s);
		o(7) <= (i1(7) and not(s)) or (i2(7) and s);
		
end architecture rtl;
