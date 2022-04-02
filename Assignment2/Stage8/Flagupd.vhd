LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY flagupd IS
    PORT (
        MSBa : IN STD_LOGIC;
        MSBb : IN STD_LOGIC;
        cout : IN STD_LOGIC;
        res : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        res_64 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        shiftout : IN STD_LOGIC;
        instr : IN instr_class_type;
        mul_acc : IN mul_acc_type;
        opalu : IN optype;
        DP_subclass : IN DP_subclass_type;
        SBit : IN STD_LOGIC;
        ZFlag : OUT STD_LOGIC := '0';
        NFlag : OUT STD_LOGIC := '0';
        VFlag : OUT STD_LOGIC := '0';
        CFlag : OUT STD_LOGIC := '0';
        isShift : IN STD_LOGIC
    );
END flagupd;

ARCHITECTURE flag_arch OF flagupd IS

BEGIN
    CFlag <= cout WHEN ((DP_subclass = arith AND SBit = '1') OR DP_subclass = comp) ELSE
        shiftout WHEN (isShift = '1' AND SBit = '1' AND (DP_subclass = logic OR DP_subclass = test)) ELSE
        '0';
    ZFlag <= '1' WHEN ((res_64 = X"0000000000000000" AND SBit = '1' AND instr = MUL) OR (instr = DP AND ((DP_subclass = arith AND SBit = '1') OR (DP_subclass = logic AND SBit = '1') OR (DP_subclass = comp) OR (DP_subclass = test)) AND (res = X"00000000")))
        ELSE
        '0';
    NFlag <= res(31) WHEN (instr = DP AND ((DP_subclass = arith AND SBit = '1') OR (DP_subclass = logic AND SBit = '1') OR (DP_subclass = comp) OR (DP_subclass = test))) ELSE
        res_64(63) WHEN (SBit = '1' AND instr = MUL) ELSE
        '0';
    VFlag <= (MSBa AND MSBb AND NOT(res(31))) OR (NOT(MSBa) AND NOT(MSBb) AND res(31)) WHEN ((opalu = add OR opalu = adc or opalu = cmn) AND SBit = '1') ELSE
        (MSBa AND NOT(MSBb) AND NOT(res(31))) OR (NOT(MSBa) AND MSBb AND res(31)) WHEN ((opalu = sub OR opalu = sbc or opalu = cmp) AND SBit = '1') ELSE
        (NOT(MSBa) AND MSBb AND NOT(res(31))) OR (MSBa AND NOT(MSBb) AND res(31)) WHEN ((opalu = rsb OR opalu = rsc) AND SBit = '1') ELSE
        '0';
END flag_arch;