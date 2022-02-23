LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbench IS

END testbench;

ARCHITECTURE tb OF testbench IS
    COMPONENT cond IS
        PORT (
            condition : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            ZFlag : IN STD_LOGIC;
            VFlag : IN STD_LOGIC;
            CFlag : IN STD_LOGIC;
            NFlag : IN STD_LOGIC;
            predicate : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL condition : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ZFlag : STD_LOGIC;
    SIGNAL VFlag : STD_LOGIC;
    SIGNAL CFlag : STD_LOGIC;
    SIGNAL NFlag : STD_LOGIC;
    SIGNAL predicate : STD_LOGIC;

BEGIN

    UUT : cond PORT MAP(condition, ZFlag, VFlag, CFlag, NFlag, predicate);

    PROCESS
    BEGIN
        condition <= "0000";
        ZFlag <= '1';
        WAIT FOR 1 ns;
        ASSERT(predicate = '1') REPORT "Fail" SEVERITY error;
        ZFlag <= '0';
        WAIT FOR 1 ns;
        ASSERT(predicate = '0') REPORT "Fail" SEVERITY error;
        WAIT;
    END PROCESS;
END tb;