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

    SIGNAL pmem : table := (0 => X"E3A0000A",
    1 => X"E3A01005",
    2 => X"E5801000",
    3 => X"E2811002",
    4 => X"E5801004",
    5 => X"E5902000",
    6 => X"E5903004",
    7 => X"E0434002",
    OTHERS => X"00000000"
    );
	BEGIN
    
        dd <= pmem(to_integer(unsigned(rd)));
    

	END pm_arch;