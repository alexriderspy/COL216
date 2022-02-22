LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pm IS
    PORT (
        rd : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        dd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END pm;

ARCHITECTURE pm_arch OF pm IS
    TYPE table IS ARRAY(63 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --16 - 32 bit vectors

    SIGNAL pmem : table := (0 => X"E3A00005",
    1 => X"E2400001",
    2 => X"EA000000",
    3 => X"E3A00004",
    4 => X"E2400001",
    OTHERS => X"00000000"
    );

BEGIN
    dd <= pmem(to_integer(unsigned(rd)));
END pm_arch;