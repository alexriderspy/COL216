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
        DP_subclass : IN DP_subclass_type;
        SBit : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        ZFlag : OUT STD_LOGIC := '0';
        NFlag : OUT STD_LOGIC := '0';
        VFlag : OUT STD_LOGIC := '0';
        CFlag : OUT STD_LOGIC := '0'
    );
END flagupd;

ARCHITECTURE flag_arch OF flagupd IS

BEGIN
    CFlag <= cout when ((DP_subclass = arith and SBit='1') or DP_subclass = comp);
    ZFlag <= '1' when (((DP_subclass = arith and SBit = '1') or (DP_subclass = logic and SBit = '1') or (DP_subclass = comp) or (DP_subclass = test)) and (res=X"00000000"))
        else '0' when (((DP_subclass = arith and SBit = '1') or (DP_subclass = logic and SBit = '1') or (DP_subclass = comp) or (DP_subclass = test)));
    NFlag <= res(31) when ((DP_subclass = arith and SBit = '1') or (DP_subclass = logic and SBit = '1') or (DP_subclass = comp) or (DP_subclass = test));
    VFlag <= (MSBa AND MSBb AND NOT(res(31))) OR (NOT(MSBa) AND NOT(MSBb) AND res(31)) when ((DP_subclass = arith and SBit = '1') or (DP_subclass = comp));
END flag_arch;