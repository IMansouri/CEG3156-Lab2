LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ALU_8bits is 
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

end entity ALU_8bits;

architecture rtl of ALU_8bits is
  
  signal add, sub, andS, orS, sltV, sV : std_logic_vector(7 downto 0);
  signal carryAdd, ovfAdd, carrySub, ovfSub : std_logic;
  signal opAdd, opSub, opAnd, opOr, opSlt :  std_logic;
  
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
  
  begin
    
    --000 AND
    --001 OR
    --010 add
    --110 subtract
    --111 set-on-less-than
    
    opAnd <= not(op(2)) and not(op(1)) and not(op(0));
    opOr <= not(op(2)) and not(op(1)) and op(0);
    opAdd <= not(op(2)) and op(1) and not(op(0));
    opSub <= op(2) and op(1) and not(op(0));
    opSlt <= op(2) and op(1) and op(0);
    
    adder : entity work.eigthbit_adder(rtl)
              port map(x, y, '0', add, carryAdd, ovfAdd);
                
    substracter : entity work.eigthbit_adder(rtl)
              port map(x, y, '1', sub, carrySub, ovfSub);
                
    andS(0) <= x(0) and y(0);
    andS(1) <= x(1) and y(1);
    andS(2) <= x(2) and y(2);
    andS(3) <= x(3) and y(3);
    andS(4) <= x(4) and y(4);
    andS(5) <= x(5) and y(5);
    andS(6) <= x(6) and y(6);
    andS(7) <= x(7) and y(7);
    
    orS(0) <= x(0) or y(0);
    orS(1) <= x(1) or y(1);
    orS(2) <= x(2) or y(2);
    orS(3) <= x(3) or y(3);
    orS(4) <= x(4) or y(4);
    orS(5) <= x(5) or y(5);
    orS(6) <= x(6) or y(6);
    orS(7) <= x(7) or y(7);
    
    sltV(0) <= (sub(7) and x(0)) or (not(sub(7)) and y(0));
    sltV(1) <= (sub(7) and x(1)) or (not(sub(7)) and y(1));
    sltV(2) <= (sub(7) and x(2)) or (not(sub(7)) and y(2));
    sltV(3) <= (sub(7) and x(3)) or (not(sub(7)) and y(3));
    sltV(4) <= (sub(7) and x(4)) or (not(sub(7)) and y(4));
    sltV(5) <= (sub(7) and x(5)) or (not(sub(7)) and y(5));
    sltV(6) <= (sub(7) and x(6)) or (not(sub(7)) and y(6));
    sltV(7) <= (sub(7) and x(7)) or (not(sub(7)) and y(7));
    
    -- Outputs --
    
    sV(0) <= (add(0) and opAdd) or (sub(0) and opSub) or (andS(0) and opAnd) or (orS(0) and opOr) or (sltV(0) and opSlt);
    sV(1) <= (add(1) and opAdd) or (sub(1) and opSub) or (andS(1) and opAnd) or (orS(1) and opOr) or (sltV(1) and opSlt);
    sV(2) <= (add(2) and opAdd) or (sub(2) and opSub) or (andS(2) and opAnd) or (orS(2) and opOr) or (sltV(2) and opSlt);
    sV(3) <= (add(3) and opAdd) or (sub(3) and opSub) or (andS(3) and opAnd) or (orS(3) and opOr) or (sltV(3) and opSlt);
    sV(4) <= (add(4) and opAdd) or (sub(4) and opSub) or (andS(4) and opAnd) or (orS(4) and opOr) or (sltV(4) and opSlt);
    sV(5) <= (add(5) and opAdd) or (sub(5) and opSub) or (andS(5) and opAnd) or (orS(5) and opOr) or (sltV(5) and opSlt);
    sV(6) <= (add(6) and opAdd) or (sub(6) and opSub) or (andS(6) and opAnd) or (orS(6) and opOr) or (sltV(6) and opSlt);
    sV(7) <= (add(7) and opAdd) or (sub(7) and opSub) or (andS(7) and opAnd) or (orS(7) and opOr) or (sltV(7) and opSlt);
    
    zero <= not(sV(0) or sV(1) or sV(2) or sV(3) or sV(4) or sV(5) or sV(6) or sV(7));
    overflow <= (opAdd and ovfAdd) or (opSub and ovfSub);
    carry <= (opAdd and carryAdd) or (opSub and carrySub);
    slt <= sub(7) and opSlt;
    s <= sV;
    
end rtl;
