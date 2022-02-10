library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is 
-- empty
end testbench;

architecture tb of testbench is

-- DUT component

component dm is
    port(
        addr: in std_logic_vector(5 downto 0);
        clk: in std_logic;
        din: in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(31 downto 0);
        wn: in std_logic_vector(3 downto 0)
        );
end component;

signal addr: std_logic_vector(5 downto 0);
signal clk: std_logic;
signal din: std_logic_vector(31 downto 0);
signal dout: std_logic_vector(31 downto 0);
signal wn: std_logic_vector(3 downto 0);
signal temp: std_logic_vector(29 downto 0):= (others => '0');

begin

  -- Connect DUT
  UUT: dm port map(addr,clk,din,dout,wn);
  
  process
  begin
    -- Write data into DM
    clk<='0';
    wait for 50 ns;
    
    clk <= '1';
    addr<="100000";
    din<=temp & "11";
    wn <= "1111";
    
    wait for 50 ns;
    clk <= '0';
    wait for 50 ns;
    
    clk <= '1';
    addr <= "000000";
    din<=temp & "01";
    wn <= "1111";
    
    wait for 50 ns;
	clk <= '0';
    wait for 50 ns;
       
-- Read data from DM
  
    clk <= '1';
    addr<="100000";
    wn <= "0000";
    
    wait for 50 ns;
    assert(dout = (temp & "11")) report "Fail 11" severity error;
    
    clk <= '0';
    addr <= "000000";
    
    wait for 50 ns;
    assert(dout = (temp & "01")) report "Fail 01" severity error;

--Write data
	clk <= '1';
    addr <= "000000";
	din<= temp & "10";
    wn <= "0001";
	wait for 50 ns;
    
--read data
    clk <= '0';
    addr <= "000000";
   	wn <= "0000";
    wait for 50 ns;
    assert(dout = (temp & "10")) report "Fail wn" severity error;
    
	assert false report "Tests done." severity note;
	wait;
	end process;
end tb;
