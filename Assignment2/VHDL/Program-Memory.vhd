library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pm is
    port(
        rd: in std_logic_vector(5 downto 0);
        dd: out std_logic_vector(31 downto 0)
        );
    end pm;

architecture pm_arch of pm is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0); --16 - 32 bit vectors
    
    signal pmem: table := ("00000000000000000000000000000001",
 "00000000000000000000000000000010","00000000000000000000000000000011",others => (others => '0'));
begin
    read : process(rd)
    begin
        dd <= pmem(to_integer(unsigned(rd)));
    end process read; 
end pm_arch ; 