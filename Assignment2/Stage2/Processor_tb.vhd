LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY testbench IS
    -- empty
END testbench;

ARCHITECTURE tb OF testbench IS

    -- DUT component

    COMPONENT Processor IS
        PORT (
            clk : IN STD_LOGIC
        );
    END COMPONENT;

	signal clk : std_logic;
    
BEGIN

    UUT : Processor PORT MAP(clk);

    PROCESS
    BEGIN
   -- Write data into register
    for I in 0 to 20 loop
	    clk <= '0';
        wait for 10 ns;
        clk <= '1';
	    wait for 10 ns;    
    end loop;        
    WAIT;
    END PROCESS;
END tb;