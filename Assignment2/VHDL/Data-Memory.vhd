library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dm is
    port(
        addr: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        din: in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(31 downto 0);
        wn: in std_logic
        );
    end dm;

architecture dm_arch of dm is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0); --16 - 32 bit addresses
    signal dmem: table;

begin
    read : process(addr)
    begin
        dout <= dmem(to_integer(unsigned(addr)));
    end process read; 

    write: process(clk)
    begin
        if (rising_edge(clk)) then
            if wn = '1' then
                dmem(to_integer(unsigned(addr))) <= din;
            end if ;
        end if ;
    end process write;
end dm_arch ; 