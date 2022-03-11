LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Sh_ror IS
    PORT (
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        typ : IN shift_type;
        sel : IN STD_logic;
        carry_in : IN STD_logic;
        oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        carry_out : OUT STD_LOGIC
    );
END Sh_ror;

ARCHITECTURE beh_Sh_ror OF Sh_ror IS

BEGIN

END beh_Sh_ror;