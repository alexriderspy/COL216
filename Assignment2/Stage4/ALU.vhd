LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
USE work.MyTypes.ALL;

ENTITY ALU IS 
    PORT (
        a: in STD_LOGIC_VECTOR(31 downto 0);
        b: in STD_LOGIC_VECTOR(31 downto 0);
        opcode: in optype;
        res: out STD_LOGIC_VECTOR(31 downto 0);
        cin: in STD_LOGIC;
        cout: out STD_LOGIC);
END ALU;

architecture beh_ALU of ALU is
    
    BEGIN 
    PROCESS(a,b,cin,opcode)
        VARIABLE temp: STD_LOGIC_VECTOR(32 downto 0);
        BEGIN 
        cout <= cin;
        CASE opcode IS
        WHEN andop | tst =>
            res <= a and b;
        WHEN eor | teq =>
            res <= a xor b;
        WHEN sub | cmp =>
            temp := STD_LOGIC_VECTOR(signed('0' & a) + signed('0' & b) + 1);
            cout <= STD_LOGIC(temp(32));
            
            res <= temp(31 downto 0);
        WHEN rsb =>
            temp := STD_LOGIC_VECTOR(signed('0' & b) + signed('0' & a) + 1);
            cout <= STD_LOGIC(temp(32));
            
            res <= temp(31 downto 0);
        WHEN add | cmn =>
            temp := STD_LOGIC_VECTOR(signed('0' & a) + signed('0' & b));
            cout <= STD_LOGIC(temp(32));
            res <= temp(31 downto 0);
        WHEN adc =>
            temp := STD_LOGIC_VECTOR(signed('0' & a) + signed('0' & b) + signed'('0'&cin));
            
            cout <= STD_LOGIC(temp(32));
            res <= temp(31 downto 0);

        WHEN sbc =>
            temp := STD_LOGIC_VECTOR(signed('0' & a) + signed('0' & not(b)) + signed'('0'&cin));
            cout <= STD_LOGIC(temp(32));
            res <= temp(31 downto 0);
        WHEN rsc =>
            temp := STD_LOGIC_VECTOR(signed('0' & not(a)) + signed('0' & b) + signed'('0'&cin));
            cout <= STD_LOGIC(temp(32));
            res <= temp(31 downto 0);
        WHEN orr =>
            res <= a or b ;
        WHEN mov =>
            res <= b;
        WHEN bic =>
            res <= a and not(b);
        WHEN mvn =>
            res <= not(b);
        WHEN others =>
            NULL;
        end case;
        end process;
    end beh_ALU;
