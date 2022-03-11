LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Left_Shifter IS
    PORT (
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        carry_in : IN STD_LOGIC;
        carry_out : OUT STD_LOGIC
    );
END Left_Shifter;

ARCHITECTURE beh_Left_Shifter OF Left_Shifter IS

    SIGNAL out0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    out0 <= inp (30 DOWNTO 0) & '0' WHEN amt(0) = '1' ELSE
        inp(31 DOWNTO 0);
    out1 <= out0(29 DOWNTO 0) & "00" WHEN amt(1) = '1' ELSE
        out0;
    out2 <= out1 (27 DOWNTO 0) & X"0" WHEN amt(2) = '1' ELSE
        out1;
    out3 <= out2(23 DOWNTO 0) & X"00" WHEN amt(3) = '1' ELSE
        out2;
    oupt <= out3(15 DOWNTO 0) & X"0000" WHEN amt(4) = '1' ELSE
        out3;
    carry_out <= oupt(16) WHEN amt(4) = '1' ELSE
        out3(24) WHEN amt(3) = '1' ELSE
        out2(28) WHEN amt(2) = '1' ELSE
        out1(30) WHEN amt(1) = '1' ELSE
        out0(31) WHEN amt(0) = '1' ELSE
        carry_in;

END beh_Left_Shifter;