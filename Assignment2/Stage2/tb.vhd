LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbench IS

END testbench;

ARCHITECTURE tb OF testbench IS
    COMPONENT Processor IS
        PORT (
            clk, reset : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk, reset : STD_LOGIC;

BEGIN

    UUT : Processor PORT MAP(clk, reset);

    PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 10 ns;
        reset <= '0';

        FOR I IN 0 TO 40 LOOP
            clk <= '0';
            WAIT FOR 10 ns;
            clk <= '1';
            WAIT FOR 10 ns;
        END LOOP;
        WAIT;
    END PROCESS;
END tb;