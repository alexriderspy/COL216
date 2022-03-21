LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE MyTypes IS

    SUBTYPE word IS STD_LOGIC_VECTOR (31 DOWNTO 0);
    SUBTYPE hword IS STD_LOGIC_VECTOR (15 DOWNTO 0);
    SUBTYPE byte IS STD_LOGIC_VECTOR (7 DOWNTO 0);
    SUBTYPE nibble IS STD_LOGIC_VECTOR (3 DOWNTO 0);
    SUBTYPE bit_pair IS STD_LOGIC_VECTOR (1 DOWNTO 0);
    TYPE optype IS (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn, invalid);
    TYPE instr_class_type IS (DP, DT, MUL, BRN, none);
    TYPE DP_subclass_type IS (arith, logic, comp, test, none);
    TYPE DP_operand_src_type IS (reg, imm);
    TYPE load_store_type IS (load, store);
    TYPE DT_offset_sign_type IS (plus, minus);
    TYPE shift_type IS (LSL, LSR, ASR, RORx);
    TYPE load_instr_type IS (ldr, ldrh, ldrb, ldrsh, ldrsb);
    TYPE store_instr_type IS (str, strh, strb);
    TYPE mul_acc_type IS (mul,mla,umull,umlal,smull,smlal);

END MyTypes;

PACKAGE BODY MyTypes IS
END MyTypes;