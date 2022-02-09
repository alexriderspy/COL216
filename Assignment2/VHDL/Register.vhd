library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regtr is
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
    end regtr;

architecture register_arch of regtr is
    type table is array(15 downto 0) of std_logic_vector(31 downto 0); --16 - 32 bit addresses
    signal reg: table;

begin
    dd1 <= reg(to_integer(unsigned(rd1)));
    dd2 <= reg(to_integer(unsigned(rd2)));


    write: process(clk)
    begin
        if (rising_edge(clk)) then
            if wn = '1' then
                reg(to_integer(unsigned(wad))) <= data;
            end if ;
        end if ;
    end process write;
end register_arch ; 