library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is 
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        opcode: in std_logic_vector(3 downto 0);
        res: out std_logic_vector(31 downto 0);
        cin: in std_logic;
        cout: out std_logic);
end ALU;

architecture beh_ALU of ALU is
    signal temp: std_logic_vector(32 downto 0);
    signal temp2: std_logic_vector(31 downto 0) := (others => '0');
    begin 
    process(a,b,cin,opcode)
        begin 
        cout <= '0';
        case opcode is
        when "0000" =>
            res <= std_logic_vector(signed(a) and signed(b));
        when "0001" =>
            res <= std_logic_vector(signed(a) xor signed(b));
        when "0010" =>
            temp <= std_logic_vector(signed('0' & a) - signed('0' & b));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0011" =>
            temp <= std_logic_vector(signed('0' & b) - signed('0' & a));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0100" =>
            temp <= std_logic_vector(signed('0' & a) + signed('0' & b));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0101" =>
            temp <= std_logic_vector(signed('0' & a) + signed('0' & b) + signed'('0'&cin));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);

        when "0110" =>
            temp <= std_logic_vector(signed('0' & a) + signed('0' & not(b)) + signed'('0'&cin));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0111" =>
            temp <= std_logic_vector(signed('0' & not(a)) + signed('0' & b) + signed'('0'&cin));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "1000" =>
            res <= std_logic_vector(signed(a) and signed(b));  
        when "1001" =>
            res <= std_logic_vector(signed(a) xor signed(b)); 
        when "1010" =>
            temp <= std_logic_vector(signed('0' & a) - signed('0' & b));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "1011" =>
            temp <= std_logic_vector(signed('0' & a) + signed('0' & b));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "1100" =>
            res <= std_logic_vector(signed(a) or signed(b)) ;
        when "1101" =>
            res <= std_logic_vector(signed(b));
        when "1110" =>
            temp <= std_logic_vector(signed('0' & a) + signed('0' & not(b)));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "1111" =>
            res <= std_logic_vector(signed(not(b)));
        when others =>
            NULL;
        end case;
        end process;
    end beh_ALU;
