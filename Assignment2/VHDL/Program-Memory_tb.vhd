library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is 
-- empty
end testbench;

architecture tb of testbench is
signal addr: std_logic_vector(5 downto 0);
signal data: std_logic_vector(31 downto 0);
signal temp: std_logic_vector(31 downto 0):= (others => '0');
-- DUT component
component pm is
    port(
        rd: in std_logic_vector(5 downto 0);
        dd: out std_logic_vector(31 downto 0)
        );
end component;

begin

  -- Connect DUT
  UUT: pm port map(addr,data);
  
  
  process
  begin
    -- Write data into RAM
    wait for 100 ns;
    addr<="000000";
    wait for 100 ns;
    assert(data = temp) report "Fail" severity error;
    
    wait for 100 ns;
    addr<="000001";
    wait for 100 ns;
    assert(data = temp) report "Fail" severity error;
    
    wait for 100 ns;
    addr<="000010";
    wait for 100 ns;
    assert(data = temp) report "Fail" severity error;
    
    assert false report "Test done. Open EPWave to see signals." severity note;
    wait;
  end process;

end tb;
