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
        0 => X"EA000006", --reset
        2 => X"EA00000C", --swi
        8 => X"E3A00C01", --instruction to be executed for reset
        9 => X"E590E000",
        10 => X"E6000011", --rte
        16 => X"E5900000", --instruction to be executed for swi
        17 => X"E6000011", --rte
        --user program
        96 => X"EF000000",
        97 => X"E2001001",
        98 => X"E3510001",
        99 => X"1AFFFFFB",
        OTHERS => X"00000000"
    );

BEGIN
    dout <= dmem(to_integer(unsigned(addr))); --WHEN unsigned(addr) >= 64 ELSE X"00000000";
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF unsigned(addr) >= 64 THEN
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
        END IF;
    END PROCESS;
END mem_arch;