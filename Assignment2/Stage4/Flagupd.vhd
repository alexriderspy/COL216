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
        shiftout : IN STD_LOGIC;
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr_class : IN instr_class_type;
        DP_subclass : IN DP_subclass_type;
        SBit : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        ZFlag : OUT STD_LOGIC:='0';
        NFlag : OUT STD_LOGIC:='0';
        VFlag : OUT STD_LOGIC:='0';
        CFlag : OUT STD_LOGIC:='0'
    );
END flagupd;

ARCHITECTURE flag_arch OF flagupd IS

BEGIN
    
    CFlag <= cout WHEN (instr_class= DP and ((DP_subclass = arith AND SBit = '1') OR (DP_subclass = comp)));
    
    ZFlag <= '1' WHEN (instr_class= DP and (((DP_subclass = arith AND SBit = '1') OR (DP_subclass = logic AND SBit = '1') OR (DP_subclass = comp) OR (DP_subclass = test)) AND (res = X"00000000"))) ELSE
        
        '0' ;
    
    NFlag <= res(31) WHEN (instr_class= DP and ((DP_subclass = arith AND SBit = '1') OR (DP_subclass = logic AND SBit = '1') OR (DP_subclass = comp) OR (DP_subclass = test)));

    VFlag <= (MSBa AND MSBb AND NOT(res(31))) OR (NOT(MSBa) AND NOT(MSBb) AND res(31)) WHEN (instr_class= DP and ((DP_subclass = arith AND SBit = '1') OR (DP_subclass = comp)));
    
END flag_arch;