library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is 
-- empty
end testbench;

architecture tb of testbench is

signal addr: std_logic_vector(3 downto 0);
signal clk: std_logic;
signal din: std_logic_vector(31 downto 0);
signal dout: std_logic_vector(31 downto 0);
signal wn: std_logic_vector(3 downto 0);

-- DUT component

entity dm is
    port(
        addr: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        din: in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(31 downto 0);
        wn: in std_logic_vector(3 downto 0)
        );
end component;

begin

  -- Connect DUT
  UUT: dm port map(addr,clk,din,dout,wn);
  
  process
  begin
    -- Write data into RAM
    wait for 100 ns;
    ADDRESS<="10000000";
    DATAIN<="01111111";
    WAIT FOR 100 ns;
    ADDRESS<="01000000";
    DATAIN<="10111111";
    WAIT FOR 100 ns;
    ADDRESS<="00100000";
    DATAIN<="11011111";
    WAIT FOR 100 ns;
    ADDRESS<="00010000";
    DATAIN<="11101111";
    WAIT FOR 110 ns;

    -- Read data from RAM
    W_R<='1';
    ADDRESS<="00000000";
    WAIT FOR 100 ns;
    ADDRESS<="10000000";
    WAIT FOR 100 ns;
    ADDRESS<="01000000";
    WAIT FOR 100 ns;
    ADDRESS<="00100000";
    WAIT FOR 100 ns;
    ADDRESS<="00010000";
    WAIT FOR 100 ns;
    
	assert false report "Tests done." severity note;
	wait;
	end process;
end tb;
