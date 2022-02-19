LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.MyTypes.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decoder IS
    PORT (
        instruction : IN word;
        instr_class : OUT instr_class_type;
        operation : OUT optype;
        DP_subclass : OUT DP_subclass_type;
        DP_operand_src : OUT DP_operand_src_type;
        load_store : OUT load_store_type;
        DT_offset_sign : OUT DT_offset_sign_type
    );
END Decoder;

ARCHITECTURE Decoder_arch OF Decoder IS

    TYPE oparraytype IS ARRAY (0 TO 15) OF optype;
    CONSTANT oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);

BEGIN

    WITH instruction (27 DOWNTO 26) SELECT
    instr_class <= DP WHEN "00",
        DT WHEN "01",
        BRN WHEN "10",
        none WHEN OTHERS;

    operation <= oparray (to_integer(unsigned (instruction (24 DOWNTO 21))));
    WITH instruction (24 DOWNTO 22) SELECT
    DP_subclass <= arith WHEN "001" | "010" | "011",
        logic WHEN "000" | "110" | "111",
        comp WHEN "101",
        test WHEN OTHERS;
    DP_operand_src <= reg WHEN instruction (25) = '0' ELSE
        imm;
    load_store <= load WHEN instruction (20) = '1' ELSE
        store;
    DT_offset_sign <= plus WHEN instruction (23) = '1' ELSE
        minus;
END Decoder_arch;