library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dm is
    port(
        addr: in std_logic_vector(5 downto 0);
        clk: in std_logic;
        din: in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(31 downto 0);
        wn: in std_logic_vector(3 downto 0)
        );
    end dm;

architecture dm_arch of dm is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0); --16 - 32 bit addresses
    signal dmem: table;

begin
   	dout <= dmem(to_integer(unsigned(addr)));

   	write: process(clk)
    begin
        if (rising_edge(clk)) then
            if wn(3) = '1' then
                dmem(to_integer(unsigned(addr)))(31 downto 24) <= din(31 downto 24);
            end if ;
            if wn(2) = '1' then
                dmem(to_integer(unsigned(addr)))(23 downto 16) <= din(23 downto 16);
            end if ;
            if wn(1) = '1' then
                dmem(to_integer(unsigned(addr)))(15 downto 8) <= din(15 downto 8);
            end if ;
            if wn(0) = '1' then
                dmem(to_integer(unsigned(addr)))(7 downto 0) <= din(7 downto 0);
            end if ;

        end if ;
    end process write;
end dm_arch ; 