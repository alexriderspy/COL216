LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbench IS
    
END testbench;

ARCHITECTURE tb OF testbench IS
	COMPONENT pc IS
    PORT (
        pcin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        predicate : IN STD_LOGIC
    );
    END COMPONENT;

	signal pcin,instr,pcout : std_logic_vector(31 downto 0);
    signal predicate:std_logic;
BEGIN

    UUT : pc PORT MAP(pcin,instr,pcout,predicate);

    PROCESS
    BEGIN
	pcin <= X"00000000";
    instr <= X"00000000";
    wait for 1 ns;
    assert(pcout = X"00000010") report "fail" severity error;
WAIT;
    END PROCESS;
END tb;