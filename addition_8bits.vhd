LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity addition_8bits is 
	port(

		xV_add : in std_logic_vector(7 downto 0);
		yV_add : in std_logic_vector(7 downto 0);
		en_add : in std_logic;

		sV_add : out std_logic_vector(7 downto 0);
		carry_add : out std_logic;
		overflow_add : out std_logic

	);

end entity addition_8bits;

architecture rtl of addition_8bits is

	signal x, y : std_logic_vector(7 downto 0);

	component eightbit_adder is 
		port(

			xV : in std_logic_vector(7 downto 0);
			yV : in std_logic_vector(7 downto 0);
			addNot : in std_logic;

			sV : out std_logic_vector(7 downto 0);
			carry : out std_logic;
			overflow : out std_logic

		);

	end component eightbit_adder;

	begin
		
		adder : entity work.eigthbit_adder(rtl)
					port map (xV_add, yV_add, '0', sV_add, carry_add, overflow_add);

end architecture rtl;
