LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY isr IS
    PORT (
        addr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END isr;

ARCHITECTURE isr_arch OF isr IS
    TYPE table IS ARRAY(127 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --16 - 32 bit addresses
    SIGNAL dmem : table := (
        OTHERS => X"00000000"
    );

BEGIN
    dout <= dmem(to_integer(unsigned(addr)));

END isr_arch;