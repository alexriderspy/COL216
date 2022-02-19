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
    
    begin 
    process(a,b,cin,opcode)
        variable temp: std_logic_vector(32 downto 0);
        begin 
        cout <= cin;
        case opcode is
        when "0000" | "1000" =>
            res <= a and b;
        when "0001" | "1001" =>
            res <= a xor b;
        when "0010" | "1010" =>
            temp := std_logic_vector(signed('0' & a) - signed('0' & b));
            cout <= std_logic(temp(32));
            
            res <= temp(31 downto 0);
        when "0011" =>
            temp := std_logic_vector(signed('0' & b) - signed('0' & a));
            cout <= std_logic(temp(32));
            
            res <= temp(31 downto 0);
        when "0100" | "1011" =>
            temp := std_logic_vector(signed('0' & a) + signed('0' & b));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0101" =>
            temp := std_logic_vector(signed('0' & a) + signed('0' & b) + signed'('0'&cin));
            
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);

        when "0110" =>
            temp := std_logic_vector(signed('0' & a) + signed('0' & not(b)) + signed'('0'&cin));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "0111" =>
            temp := std_logic_vector(signed('0' & not(a)) + signed('0' & b) + signed'('0'&cin));
            cout <= std_logic(temp(32));
            res <= temp(31 downto 0);
        when "1100" =>
            res <= a or b ;
        when "1101" =>
            res <= b;
        when "1110" =>
            res <= a and not(b);
        when "1111" =>
            res <= not(b);
        when others =>
            NULL;
        end case;
        end process;
    end beh_ALU;
