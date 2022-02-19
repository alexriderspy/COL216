LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY testbench IS
  -- empty
END testbench;

ARCHITECTURE tb OF testbench IS

  -- DUT component

  COMPONENT regtr IS
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
  END COMPONENT;

  SIGNAL rd1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL rd2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL clk : STD_LOGIC;
  SIGNAL data : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL wad : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wn : STD_LOGIC;
  SIGNAL dd1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL temp : STD_LOGIC_VECTOR(29 DOWNTO 0) := (OTHERS => '0');
BEGIN

  -- Connect DUT
  UUT : regtr PORT MAP(rd1, rd2, clk, data, wad, wn, dd1, dd2);

  PROCESS
  BEGIN
    -- Write data into register
    clk <= '0';
    WAIT FOR 50 ns;
    clk <= '1';
    wad <= "1000";
    data <= temp & "11";
    wn <= '1';

    WAIT FOR 50 ns;
    clk <= '0';
    wad <= "0000";
    data <= temp & "01";
    WAIT FOR 50 ns;

    clk <= '1';
    wad <= "0000";
    data <= temp & "01";
    wn <= '1';

    WAIT FOR 50 ns;
    -- Read data from register

    clk <= '0';
    rd1 <= "1000";
    wn <= '0';

    WAIT FOR 50 ns;
    ASSERT(dd1 = (temp & "11")) REPORT "Fail 11" SEVERITY error;

    clk <= '1';
    rd2 <= "0000";

    WAIT FOR 50 ns;
    ASSERT(dd2 = (temp & "01")) REPORT "Fail 01" SEVERITY error;

    clk <= '0';

    ASSERT false REPORT "Tests done." SEVERITY note;
    WAIT;
  END PROCESS;
END tb;