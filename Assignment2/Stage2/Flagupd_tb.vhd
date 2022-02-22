LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbench IS

END testbench;

ARCHITECTURE tb OF testbench IS
    COMPONENT flagupd IS
        PORT (
            MSBa : IN STD_LOGIC;
            MSBb : IN STD_LOGIC;
            cout : IN STD_LOGIC;
            res : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            shiftout : IN STD_LOGIC;
            instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SBit : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            ZFlag : OUT STD_LOGIC;
            NFlag : OUT STD_LOGIC;
            VFlag : OUT STD_LOGIC;
            CFlag : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL MSBa : STD_LOGIC;
    SIGNAL MSBb : STD_LOGIC;
    SIGNAL cout : STD_LOGIC;
    SIGNAL shiftout : STD_LOGIC;
    SIGNAL res : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SBit : STD_LOGIC;
    SIGNAL clk : STD_LOGIC;
    SIGNAL ZFlag : STD_LOGIC := '0';
    SIGNAL NFlag : STD_LOGIC := '0';
    SIGNAL VFlag : STD_LOGIC := '0';
    SIGNAL CFlag : STD_LOGIC := '0';

BEGIN

    UUT : flagupd PORT MAP(MSBa, MSBb, cout, res, shiftout, instr, SBit, clk, ZFlag, NFlag, VFlag, CFlag);

    PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        SBit <= '1';
        res <= X"00000000";
        instr <= X"00" & "0010" & X"00000";
        WAIT FOR 1 ns;
        ASSERT(ZFlag = '1') REPORT "fail" SEVERITY error;
        WAIT;
    END PROCESS;
END tb;