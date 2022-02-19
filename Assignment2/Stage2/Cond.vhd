LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY cond IS
    PORT (
        condition : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ZFlag : IN STD_LOGIC;
        VFlag : IN STD_LOGIC;
        CFlag : IN STD_LOGIC;
        NFlag : IN STD_LOGIC;
        predicate : OUT STD_LOGIC
    );
END cond;

ARCHITECTURE cond_arch OF cond IS
BEGIN

    WITH condition SELECT
    predicate <= ZFlag WHEN "0000",
        NOT ZFlag WHEN "0001",
        CFlag WHEN "0010",
        NOT CFlag WHEN "0011",
        NFlag WHEN "0100",
        NOT NFlag WHEN "0101",
        VFlag WHEN "0110",
        NOT VFlag WHEN "0111",
        CFlag AND NOT ZFlag WHEN "1000",
        NOT CFlag OR ZFlag WHEN "1001",
        NOT (NFlag XOR VFlag) WHEN "1010",
        NFlag XOR VFlag WHEN "1011",
        (NOT (NFlag XOR VFlag) AND NOT ZFlag) WHEN "1100",
        ((NFlag XOR VFlag) OR ZFlag) WHEN "1101",
        '1' WHEN OTHERS;

END cond_arch;