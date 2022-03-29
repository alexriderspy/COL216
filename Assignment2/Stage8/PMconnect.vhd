LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.MyTypes.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PMconnect IS
    PORT (
        rout : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memout : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        load_instr : IN load_instr_type;
        store_instr : IN store_instr_type;
        ctrl_state : IN INTEGER;
        adr2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        rin : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memin : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        mw : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END PMconnect;

ARCHITECTURE beh_PMconnect OF PMconnect IS

    SIGNAL a : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL c : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL d : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    a <= (OTHERS => memout(7));
    b <= (OTHERS => memout(15));
    c <= (OTHERS => memout(23));
    d <= (OTHERS => memout(31));

    memin <= rout(15 DOWNTO 0) & rout(15 DOWNTO 0) WHEN store_instr = strh ELSE
        rout(7 DOWNTO 0) & rout(7 DOWNTO 0) & rout(7 DOWNTO 0) & rout(7 DOWNTO 0) WHEN store_instr = strb ELSE
        rout;

    mw <= "0011" WHEN store_instr = strh AND adr2 = "00" ELSE
        "1100" WHEN store_instr = strh AND adr2 = "10" ELSE
        "0001" WHEN store_instr = strb AND adr2 = "00" ELSE
        "0010" WHEN store_instr = strb AND adr2 = "01" ELSE
        "0100" WHEN store_instr = strb AND adr2 = "10" ELSE
        "1000" WHEN store_instr = strb AND adr2 = "11" ELSE
        "1111";

    rin <= X"0000" & memout(15 DOWNTO 0) WHEN load_instr = ldrh AND adr2 = "00" ELSE
        X"0000" & memout(31 DOWNTO 16) WHEN load_instr = ldrh AND adr2 = "10" ELSE
        b(15 downto 0) & memout(15 downto 0) when load_instr = ldrsh and adr2 = "00" else
        d(15 downto 0) & memout(31 downto 16) when load_instr = ldrsh and adr2 = "10" else
        X"000000" & memout(7 downto 0) when load_instr = ldrb and adr2 = "00" else
        X"000000" & memout(15 downto 8) when load_instr = ldrb and adr2 = "01" else
        X"000000" & memout(23 downto 16) when load_instr = ldrb and adr2 = "10" else
        X"000000" & memout(31 downto 24) when load_instr = ldrb and adr2 = "11" else
        a(23 downto 0) & memout(7 downto 0) when load_instr = ldrsb and adr2 = "00" else
        b(23 downto 0) & memout(15 downto 8) when load_instr = ldrsb and adr2 = "01" else
        c(23 downto 0) & memout(23 downto 16) when load_instr = ldrsb and adr2 = "10" else
        d(23 downto 0) & memout(31 downto 24) when load_instr = ldrsb and adr2 = "11" else
        memout;
            
    END beh_PMconnect;