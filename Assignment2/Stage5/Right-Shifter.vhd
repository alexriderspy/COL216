LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Right_Shifter IS
    PORT (
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        typ : IN shift_type;
        oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        carry_in : IN STD_LOGIC;
        carry_out : OUT STD_LOGIC
    );
END Right_Shifter;

ARCHITECTURE beh_Right_Shifter OF Right_Shifter IS

    SIGNAL out0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL sig : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    sig <= ((31 DOWNTO 0) => inp(31));

    out0 <= '0' & inp (31 DOWNTO 1) WHEN amt(0) = '1' AND typ = LSR ELSE
        inp(31) & inp (31 DOWNTO 1) WHEN amt(0) = '1' AND typ = ASR ELSE
        inp(0) & inp (31 DOWNTO 1) WHEN amt(0) = '1' AND typ = ROR ELSE
        inp(31 DOWNTO 0);
    out1 <= "00" & out0 (31 DOWNTO 2) WHEN amt(0) = '1' AND typ = LSR ELSE
        sig(1 DOWNTO 0) & out0 (31 DOWNTO 2) WHEN amt(0) = '1' AND typ = ASR ELSE
        out0(1 DOWNTO 0) & out0 (31 DOWNTO 2) WHEN amt(0) = '1' AND typ = ROR ELSE
        out0;
    out2 <= X"0" & out1 (31 DOWNTO 4) WHEN amt(0) = '1' AND typ = LSR ELSE
        sig(3 DOWNTO 0) & out1 (31 DOWNTO 4) WHEN amt(0) = '1' AND typ = ASR ELSE
        out1(3 DOWNTO 0) & out1 (31 DOWNTO 4) WHEN amt(0) = '1' AND typ = ROR ELSE
        out1;
    out3 <= X"00" & out2 (31 DOWNTO 8) WHEN amt(0) = '1' AND typ = LSR ELSE
        sig(7 DOWNTO 0) & out2 (31 DOWNTO 8) WHEN amt(0) = '1' AND typ = ASR ELSE
        out2(7 DOWNTO 0) & out2 (31 DOWNTO 8) WHEN amt(0) = '1' AND typ = ROR ELSE
        out2;
    oupt <= X"0000" & out3 (31 DOWNTO 16) WHEN amt(0) = '1' AND typ = LSR ELSE
        sig(15 DOWNTO 0) & out3 (31 DOWNTO 16) WHEN amt(0) = '1' AND typ = ASR ELSE
        out3(15 DOWNTO 0) & out3(31 DOWNTO 16) WHEN amt(0) = '1' AND typ = ROR ELSE
        out3;
    carry_out <= oupt(16) WHEN amt(4) = '1' ELSE
        out3(24) WHEN amt(3) = '1' ELSE
        out2(28) WHEN amt(2) = '1' ELSE
        out1(30) WHEN amt(1) = '1' ELSE
        out0(31) WHEN amt(0) = '1' ELSE
        carry_in;

END beh_Right_Shifter;