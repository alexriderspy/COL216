LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dm IS
    PORT (
        addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        wn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END dm;

ARCHITECTURE dm_arch OF dm IS
    TYPE table IS ARRAY(63 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --16 - 32 bit addresses
    SIGNAL dmem : table;

BEGIN
    dout <= dmem(to_integer(unsigned(addr)));

    write : PROCESS (clk)
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
    END PROCESS write;
END dm_arch;