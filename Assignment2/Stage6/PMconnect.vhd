LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.MyTypes.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity PMconnect is
    port (
        rout : in std_logic_vector(31 downto 0);
        memout : in std_logic_vector(31 downto 0);
        instr : in std_logic_vector(31 downto 0);
        ctrl_state : in integer;
        adr2 : in std_logic_vector(1 downto 0);
        rin : out std_logic_vector(31 downto 0);
        memin : out std_logic_vector(31 downto 0);
        mw : out std_logic_vector(3 downto 0)
    );
end PMconnect;

architecture beh_PMconnect of PMconnect is

    signal 

begin

end beh_PMconnect ; 