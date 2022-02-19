LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY testbench IS
    -- empty
END testbench;

ARCHITECTURE tb OF testbench IS

    -- DUT component

    COMPONENT Processor IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
BEGIN

    -- Connect DUT
    UUT : Processor PORT MAP(clk, reset);

    PROCESS
    BEGIN
        -- Write data into register
        clk <= '0';
        WAIT FOR 50 ns;
        clk <= '1';

        WAIT FOR 50 ns;
        clk <= '0';
        WAIT FOR 50 ns;

        clk <= '1';

        WAIT FOR 50 ns;
       
        clk <= '0';
        
        WAIT FOR 50 ns;

        clk <= '1';

        WAIT FOR 50 ns;

        clk <= '0';
        WAIT;
    END PROCESS;
END tb;