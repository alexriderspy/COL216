LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbenchR IS

END testbenchR;

ARCHITECTURE tbR OF testbenchR IS
    COMPONENT Processor IS
        PORT (
            clk, reset : IN STD_LOGIC;
            input_p : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk, reset : STD_LOGIC;
    SIGNAL input_p : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    UUT : Processor PORT MAP(clk, reset, input_p);
    PROCESS
    BEGIN
        reset <= '0';

        FOR I IN 0 TO 80 LOOP
            input_p <= X"00000003"; --last 9 bits    
            clk <= '0';
            WAIT FOR 1 ns;
            clk <= '1';
            WAIT FOR 1 ns;
        END LOOP;
        WAIT;
    END PROCESS;
END tbR;