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
        DT_operand_src : OUT DP_operand_src_type;
        load_store : OUT load_store_type;
        DT_offset_sign : OUT DT_offset_sign_type;

        load_instr : OUT load_instr_type;
        store_instr : OUT store_instr_type;

        shift_operand_src : OUT DP_operand_src_type;
        shift_typ : OUT shift_type
    );
END Decoder;

ARCHITECTURE Decoder_arch OF Decoder IS

    TYPE oparraytype IS ARRAY (0 TO 15) OF optype;
    CONSTANT oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);

BEGIN

    instr_class <=
        DP WHEN instruction(27 DOWNTO 26) = "00" AND (instruction(4) = '0' OR instruction(7)='0') ELSE
        DT WHEN ((instruction(27 DOWNTO 26) = "00" AND instruction(4) = '1' and instruction(7) = '1') OR instruction(27 DOWNTO 26) = "01") ELSE
        BRN;

    store_instr <= strh WHEN instruction(6 DOWNTO 5) = "01" ELSE
        strb WHEN instruction(27 DOWNTO 26) = "01" AND instruction(22) = '1' ELSE
        str;

    load_instr <= ldrh WHEN instruction(27 DOWNTO 26) = "00" AND instruction(6 DOWNTO 5) = "01" ELSE
        ldrsh WHEN instruction(27 DOWNTO 26) = "00" AND instruction(6 DOWNTO 5) = "11" ELSE
        ldrsb WHEN instruction(27 DOWNTO 26) = "00" AND instruction(6 DOWNTO 5) = "10" ELSE
        ldrb WHEN instruction(27 DOWNTO 26) = "01" AND instruction(22) = '1' ELSE
        ldr;

    operation <= invalid WHEN instruction = X"00000000" ELSE
        oparray (to_integer(unsigned (instruction (24 DOWNTO 21))));

    WITH instruction (24 DOWNTO 22) SELECT
    DP_subclass <= arith WHEN "001" | "010" | "011",
        logic WHEN "000" | "110" | "111",
        comp WHEN "101",
        test WHEN OTHERS;

    DP_operand_src <= reg WHEN instruction (25) = '0' ELSE
        imm;

    DT_operand_src <= reg WHEN ((instruction (25) = '1' and instruction(27 DOWNTO 26) = "01") or (instruction(27 DOWNTO 26) = "00" and instruction(22) = '0')) ELSE
        imm;

    load_store <= load WHEN instruction (20) = '1' ELSE
        store;

    DT_offset_sign <= plus WHEN instruction (23) = '1' ELSE
        minus;

    shift_typ <= LSL WHEN instruction(6 DOWNTO 5) = "00" ELSE
        LSR WHEN instruction(6 DOWNTO 5) = "01" ELSE
        ASR WHEN instruction(6 DOWNTO 5) = "10" ELSE
        RORx;

    shift_operand_src <= reg WHEN instruction(4) = '1' ELSE
        imm;

END Decoder_arch;