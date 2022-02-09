library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is 
-- empty
end testbench;

architecture tb of testbench is

-- DUT component

component regtr is
    port(
        rd1: in std_logic_vector(3 downto 0);
        rd2: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        data: in std_logic_vector(31 downto 0);
        wad: in std_logic_vector(3 downto 0);
        wn: in std_logic;
        dd1: out std_logic_vector(31 downto 0);
        dd2: out std_logic_vector(31 downto 0)
        );
end component;

signal rd1: std_logic_vector(3 downto 0);
signal rd2: std_logic_vector(3 downto 0);
signal clk: std_logic;
signal data: std_logic_vector(31 downto 0);
signal wad: std_logic_vector(3 downto 0);
signal wn: std_logic;
signal dd1: std_logic_vector(31 downto 0);
signal dd2: std_logic_vector(31 downto 0);
signal temp: std_logic_vector(29 downto 0):= (others => '0');
begin

  -- Connect DUT
  UUT: regtr port map(rd1,rd2,clk,data,wad,wn,dd1,dd2);
  
  process
  begin
    -- Write data into regtr
    clk<='0';
    wait for 50 ns;
    clk <= '1';
    wad<="1000";
    data<=temp & "11";
    wn <= '1';
    
    wait for 50 ns;
    clk <= '0';
    wad <= "0000";
    data<=temp & "01";
    wait for 50 ns;
    
    clk <= '1';
    wad <= "0000";
    data<=temp & "01";
    wn <= '1';
    
    wait for 50 ns;
    -- Read data from regtr
  
    clk <= '0';
    rd1<="1000";
    
    
    wait for 50 ns;
    assert(dd1 = (temp & "11")) report "Fail 11" severity error;
    
    clk <= '1';
    rd2 <= "0000";
    
    wait for 50 ns;
    assert(dd2 = (temp & "01")) report "Fail 01" severity error;
    
    clk <= '0';    
    
	assert false report "Tests done." severity note;
	wait;
	end process;
end tb;
