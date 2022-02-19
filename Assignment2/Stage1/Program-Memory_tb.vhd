LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY testbench IS
  -- empty
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL data : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL temp : STD_LOGIC_VECTOR(29 DOWNTO 0) := (OTHERS => '0');
  -- DUT component
  COMPONENT pm IS
    PORT (
      rd : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      dd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

BEGIN

  -- Connect DUT
  UUT : pm PORT MAP(addr, data);
  PROCESS
  BEGIN
    --Read data from Program Memory
    WAIT FOR 100 ns;
    addr <= "111111";
    WAIT FOR 100 ns;
    ASSERT(data = temp & "01") REPORT "Fail" SEVERITY error;

    WAIT FOR 100 ns;
    addr <= "111110";
    WAIT FOR 100 ns;
    ASSERT(data = temp & "10") REPORT "Fail" SEVERITY error;

    WAIT FOR 100 ns;
    addr <= "111101";
    WAIT FOR 100 ns;
    ASSERT(data = temp & "11") REPORT "Fail" SEVERITY error;

    WAIT FOR 100 ns;
    addr <= "000000";
    WAIT FOR 100 ns;
    ASSERT(data = temp & "00") REPORT "Fail" SEVERITY error;

    ASSERT false REPORT "Test done. Open EPWave to see signals." SEVERITY note;
    WAIT;
  END PROCESS;

END tb;