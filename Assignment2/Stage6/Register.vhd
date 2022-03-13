LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY regtr IS
    PORT (
        rd1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        rd2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk : IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        wad : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        wn : IN STD_LOGIC;
        dd1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END regtr;

ARCHITECTURE register_arch OF regtr IS
    TYPE table IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --16 - 32 bit addresses
    SIGNAL reg : table;

BEGIN
    dd1 <= reg(to_integer(unsigned(rd1)));
    dd2 <= reg(to_integer(unsigned(rd2)));
    write : PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF wn = '1' THEN
                reg(to_integer(unsigned(wad))) <= data;
            END IF;
        END IF;
    END PROCESS write;
END register_arch;