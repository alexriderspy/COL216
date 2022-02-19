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
    PROCESS
    BEGIN
        CASE condition IS
            WHEN "0000" =>
                predicate <= ZFlag = '1';
            WHEN "0001" =>
                predicate <= ZFlag = '0';
            WHEN "0010" =>
                predicate <= CFlag = '1';
            WHEN "0011" =>
                predicate <= CFlag = '0';
            WHEN "0100" =>
                predicate <= NFlag = '1';
            WHEN "0101" =>
                predicate <= NFlag = '0';
            WHEN "0110" =>
                predicate <= VFlag = '1';
            WHEN "0111" =>
                predicate <= VFlag = '0';
            WHEN "1000" =>
                predicate <= CFlag = '1' AND ZFlag = '0';
            WHEN "1001" =>
                predicate <= CFlag = '0' OR ZFlag = '1';
            WHEN "1010" =>
                predicate <= NFlag = VFlag;
            WHEN "1011" =>
                predicate <= NFlag = NOT(VFlag);
            WHEN "1100" =>
                predicate <= NFlag = VFlag AND ZFlag = '0';
            WHEN "1101" =>
                predicate <= NFlag = NOT(VFlag) OR ZFlag = '1';
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;
END cond_arch;