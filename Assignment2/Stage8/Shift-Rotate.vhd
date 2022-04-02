LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Sh_ror IS
    PORT (
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        typ : IN shift_type;
        carry_in : IN STD_LOGIC;
        oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        carry_out : OUT STD_LOGIC;
        isShift : OUT STD_LOGIC
    );
END Sh_ror;

ARCHITECTURE beh_Sh_ror OF Sh_ror IS

    COMPONENT Left_Shifter IS
        PORT (
            inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
            carry_in : IN STD_LOGIC;
            carry_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Right_Shifter IS
        PORT (
            inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            typ : IN shift_type;
            oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
            carry_in : IN STD_LOGIC;
            carry_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL ouptL : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    SIGNAL carry_outL : STD_LOGIC;

    SIGNAL ouptR : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    SIGNAL carry_outR : STD_LOGIC;

BEGIN

    DUTL : Left_Shifter PORT MAP(inp, amt, ouptL, carry_in, carry_outL);
    DUTR : Right_Shifter PORT MAP(inp, amt, typ, ouptR, carry_in, carry_outR);

    carry_out <= carry_outL WHEN typ = LSL ELSE
        carry_outR;
    oupt <= ouptL WHEN typ = LSL ELSE
        ouptR;
    isShift <= '0' WHEN ((ouptL = inp AND typ = LSL) OR (ouptR = inp AND (typ = RORx OR typ = ASR OR typ = LSR))) ELSE
        '1';
END beh_Sh_ror;