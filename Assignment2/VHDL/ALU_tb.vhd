-- Testbench for OR gate
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component ALU is 
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        opcode: in std_logic_vector(3 downto 0);
        res: out std_logic_vector(31 downto 0);
        cin: in std_logic;
        cout: out std_logic
        );
end component;

signal a: std_logic_vector(31 downto 0);
signal  b: std_logic_vector(31 downto 0);
signal opcode: std_logic_vector(3 downto 0);
signal res: std_logic_vector(31 downto 0);
signal cin: std_logic;
signal cout: std_logic;
signal temp: std_logic_vector(28 downto 0):= (others => '0');
signal temp2: std_logic_vector(28 downto 0):= (others => '1');

begin

  -- Connect DUT
  DUT: ALU port map(a,b,opcode,res,cin,cout);
  process
  begin
  	cin <= '0';
    opcode <= "0000";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "001") report "Fail and" severity error;

	opcode <= "0001";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "010") report "Fail xor" severity error;
  
  	opcode <= "0010";
    a <= temp & "011";
    b <= temp & "001";
    wait for 1 ns;
    assert(res = temp & "010") report "Fail sub" severity error;

	opcode <= "0011";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "010") report "Fail rsb" severity error;

	opcode <= "0100";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "100") report "Fail add" severity error;
    assert(cout = '0') report "Fail add" severity error;

	opcode <= "0101";
    a <= temp & "001";
    b <= temp & "011";
    cin <= '1';
    wait for 1 ns;
    assert(res = temp & "101") report "Fail adc" severity error;
    assert(cout = '0') report "Fail adc" severity error;

	opcode <= "0110";
    a <= temp & "011";
    b <= temp & "001";
    cin <= '1';
    wait for 1 ns;
    assert(res = temp & "010") report "Fail sbc" severity error;
    assert(cout = '1') report "Fail sbc" severity error;

	opcode <= "0111";
    a <= temp & "001";
    b <= temp & "011";
    cin <= '1';
    wait for 1 ns;
    assert(res = temp & "010") report "Fail rsc" severity error;
    assert(cout = '1') report "Fail rsc" severity error;

	opcode <= "1000";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "001") report "Fail tst" severity error;

	opcode <= "1001";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "010") report "Fail teq" severity error;
	
    opcode <= "1010";
    a <= temp & "011";
    b <= temp & "001";
    wait for 1 ns;
    assert(res = temp & "010") report "Fail cmp" severity error;
	
    opcode <= "1011";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "100") report "Fail cmn" severity error;
    assert(cout = '0') report "Fail cmn" severity error;
	
    opcode <= "1100";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "011") report "Fail orr" severity error;
	
    opcode <= "1101";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "011") report "Fail mov" severity error;
	
    opcode <= "1110";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp & "000") report "Fail bic" severity error;
	
    opcode <= "1111";
    a <= temp & "001";
    b <= temp & "011";
    wait for 1 ns;
    assert(res = temp2 & "100") report "Fail mvn" severity error;
    
	
	assert false report "Test done." severity note;
    wait;
  end process;

  
end tb;
