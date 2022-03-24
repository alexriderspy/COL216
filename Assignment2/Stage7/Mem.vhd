LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mem IS
    PORT (
        addr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        wn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END mem;

ARCHITECTURE mem_arch OF mem IS
    TYPE table IS ARRAY(127 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --16 - 32 bit addresses
    SIGNAL dmem : table := (
        64 => X"E3A00002",
        65 => X"E3A01005",
        66 => X"E3A0200A",
        67 => X"E3A03000",
        68 => X"E0E32091",
        69 => X"E0A32091",
        OTHERS => X"00000000"
    );

BEGIN
    dout <= dmem(to_integer(unsigned(addr)));

    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF wn(3) = '1' THEN
                dmem(to_integer(unsigned(addr)))(31 DOWNTO 24) <= din(31 DOWNTO 24);
            END IF;
            IF wn(2) = '1' THEN
                dmem(to_integer(unsigned(addr)))(23 DOWNTO 16) <= din(23 DOWNTO 16);
            END IF;
            IF wn(1) = '1' THEN
                dmem(to_integer(unsigned(addr)))(15 DOWNTO 8) <= din(15 DOWNTO 8);
            END IF;
            IF wn(0) = '1' THEN
                dmem(to_integer(unsigned(addr)))(7 DOWNTO 0) <= din(7 DOWNTO 0);
            END IF;

        END IF;
    END PROCESS;
END mem_arch;