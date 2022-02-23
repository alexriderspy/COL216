-- Testbench for ALU 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY testbench IS
    -- empty
END testbench;

ARCHITECTURE tb OF testbench IS

    -- DUT component
    COMPONENT ALU IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            res : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cin : IN STD_LOGIC;
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL a : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL opcode : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL res : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cin : STD_LOGIC;
    SIGNAL cout : STD_LOGIC;
    SIGNAL temp : STD_LOGIC_VECTOR(28 DOWNTO 0) := (OTHERS => '0');
    SIGNAL temp2 : STD_LOGIC_VECTOR(28 DOWNTO 0) := (OTHERS => '1');

BEGIN

    -- Connect DUT
    DUT : ALU PORT MAP(a, b, opcode, res, cin, cout);
    PROCESS
    BEGIN
        cin <= '0';
        opcode <= "0000";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "001") REPORT "Fail and" SEVERITY error;

        opcode <= "0001";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail xor" SEVERITY error;

        opcode <= "0010";
        a <= temp & "011";
        b <= temp & "001";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail sub" SEVERITY error;

        opcode <= "0011";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail rsb" SEVERITY error;

        opcode <= "0100";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "100") REPORT "Fail add" SEVERITY error;
        ASSERT(cout = '0') REPORT "Fail add" SEVERITY error;

        opcode <= "0101";
        a <= temp & "001";
        b <= temp & "011";
        cin <= '1';
        WAIT FOR 1 ns;
        ASSERT(res = temp & "101") REPORT "Fail adc" SEVERITY error;
        ASSERT(cout = '0') REPORT "Fail adc" SEVERITY error;

        opcode <= "0110";
        a <= temp & "011";
        b <= temp & "001";
        cin <= '1';
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail sbc" SEVERITY error;
        ASSERT(cout = '1') REPORT "Fail sbc" SEVERITY error;

        opcode <= "0111";
        a <= temp & "001";
        b <= temp & "011";
        cin <= '1';
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail rsc" SEVERITY error;
        ASSERT(cout = '1') REPORT "Fail rsc" SEVERITY error;

        opcode <= "1000";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "001") REPORT "Fail tst" SEVERITY error;

        opcode <= "1001";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail teq" SEVERITY error;

        opcode <= "1010";
        a <= temp & "011";
        b <= temp & "001";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "010") REPORT "Fail cmp" SEVERITY error;

        opcode <= "1011";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "100") REPORT "Fail cmn" SEVERITY error;
        ASSERT(cout = '0') REPORT "Fail cmn" SEVERITY error;

        opcode <= "1100";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "011") REPORT "Fail orr" SEVERITY error;

        opcode <= "1101";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "011") REPORT "Fail mov" SEVERITY error;

        opcode <= "1110";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp & "000") REPORT "Fail bic" SEVERITY error;

        opcode <= "1111";
        a <= temp & "001";
        b <= temp & "011";
        WAIT FOR 1 ns;
        ASSERT(res = temp2 & "100") REPORT "Fail mvn" SEVERITY error;
        ASSERT false REPORT "Test done." SEVERITY note;
        WAIT;
    END PROCESS;
END tb;