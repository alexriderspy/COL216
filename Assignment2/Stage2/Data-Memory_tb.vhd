LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY testbench IS
    -- empty
END testbench;

ARCHITECTURE tb OF testbench IS

    -- DUT component

    COMPONENT dm IS
        PORT (
            addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            wn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL clk : STD_LOGIC;
    SIGNAL din : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wn : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL temp : STD_LOGIC_VECTOR(29 DOWNTO 0) := (OTHERS => '0');

BEGIN

    -- Connect DUT
    UUT : dm PORT MAP(addr, clk, din, dout, wn);

    PROCESS
    BEGIN
        -- Write data into DM
        clk <= '0';
        WAIT FOR 50 ns;

        clk <= '1';
        addr <= "100000";
        din <= temp & "11";
        wn <= "1111";

        WAIT FOR 50 ns;
        clk <= '0';
        WAIT FOR 50 ns;

        clk <= '1';
        addr <= "000000";
        din <= temp & "01";
        wn <= "1111";

        WAIT FOR 50 ns;
        clk <= '0';
        WAIT FOR 50 ns;

        -- Read data from DM

        clk <= '1';
        addr <= "100000";
        wn <= "0000";

        WAIT FOR 50 ns;
        ASSERT(dout = (temp & "11")) REPORT "Fail 11" SEVERITY error;

        clk <= '0';
        addr <= "000000";

        WAIT FOR 50 ns;
        ASSERT(dout = (temp & "01")) REPORT "Fail 01" SEVERITY error;

        --Write data
        clk <= '1';
        addr <= "000000";
        din <= temp & "10";
        wn <= "0001";
        WAIT FOR 50 ns;

        --read data
        clk <= '0';
        addr <= "000000";
        wn <= "0000";
        WAIT FOR 50 ns;
        ASSERT(dout = (temp & "10")) REPORT "Fail wn" SEVERITY error;

        ASSERT false REPORT "Tests done." SEVERITY note;
        WAIT;
    END PROCESS;
END tb;