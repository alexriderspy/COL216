LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Processor IS
    PORT (
        clk, reset : IN STD_LOGIC;
        state : OUT FSM_states:=st1
    );
END ENTITY Processor;

ARCHITECTURE beh_Processor OF Processor IS

    COMPONENT pc IS
        PORT (
            pcin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pcout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            clk : IN STD_LOGIC;
            predicate : IN STD_LOGIC;
            write_en : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Decoder IS
        PORT (
            instruction : IN word;
            instr_class : OUT instr_class_type;
            operation : OUT optype;
            DP_subclass : OUT DP_subclass_type;
            DP_operand_src : OUT DP_operand_src_type;
            load_store : OUT load_store_type;
            DT_offset_sign : OUT DT_offset_sign_type
        );
    END COMPONENT;

    COMPONENT ALU IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            opcode : IN optype;
            res : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cin : IN STD_LOGIC;
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT regtr IS
        PORT (
            rd1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            rd2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            clk : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            wad : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            wn : IN STD_LOGIC;
            dd1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT cond IS
        PORT (
            condition : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            ZFlag : IN STD_LOGIC;
            VFlag : IN STD_LOGIC;
            CFlag : IN STD_LOGIC;
            NFlag : IN STD_LOGIC;
            predicate : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT flagupd IS
        PORT (
            MSBa : IN STD_LOGIC;
            MSBb : IN STD_LOGIC;
            cout : IN STD_LOGIC;
            res : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            shiftout : IN STD_LOGIC;
            instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SBit : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            ZFlag : OUT STD_LOGIC;
            NFlag : OUT STD_LOGIC;
            VFlag : OUT STD_LOGIC;
            CFlag : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mem IS
        PORT (
            addr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            wn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_en : STD_LOGIC := '0';

    SIGNAL instr_class : instr_class_type;
    SIGNAL op : optype;
    SIGNAL DP_subclass : DP_subclass_type;
    SIGNAL DP_operand_src : DP_operand_src_type;
    SIGNAL load_store : load_store_type;
    SIGNAL DT_offset_sign : DT_offset_sign_type;

    SIGNAL rad2 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL SBit : STD_LOGIC := '0';
    SIGNAL wd : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rw : STD_LOGIC := '0';
    SIGNAL mw : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL cout : STD_LOGIC;

    SIGNAL opd1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL opd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cin : STD_LOGIC;

    SIGNAL ZF : STD_LOGIC := '0';
    SIGNAL NF : STD_LOGIC := '0';
    SIGNAL VF : STD_LOGIC := '0';
    SIGNAL CF : STD_LOGIC := '0';
    SIGNAL p : STD_LOGIC := '0';
    SIGNAL offset : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL immd : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL addr : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL opalu : optype;

    SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RES : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL curr : FSM_states := st1;
    SIGNAL nex : FSM_states;
    
    SIGNAL wdmem: std_logic_vector(31 downto 0);
BEGIN

    DUT1 : mem PORT MAP(addr, clk,wdmem, rd, mw);
    DUT2 : Decoder PORT MAP(IR, instr_class, op, DP_subclass, DP_operand_src, load_store, DT_offset_sign);

    DUT3 : regtr PORT MAP(IR(19 downto 16), rad2, clk, wd, IR(15 downto 12), rw, rd1, rd2);
    DUT4 : ALU PORT MAP(opd1, opd2, opalu, result, cin, cout);

    DUT5 : flagupd PORT MAP(opd1(31), opd2(31), cout, result, '0', IR, SBit, clk, ZF, NF, VF, CF);

    DUT7 : cond PORT MAP(IR(31 DOWNTO 28), ZF, VF, CF, NF, p);
    DUT8 : pc PORT MAP(pcin, IR, pcout, clk, p, write_en);

    immd <= IR(7 DOWNTO 0);
    offset <= IR(11 DOWNTO 0);

    addr <= STD_LOGIC_VECTOR(unsigned(pcin(8 DOWNTO 2)) + 64) WHEN curr = st1 ELSE
        RES(8 DOWNTO 2);

    IR <= rd when curr = st1;

    DR <= rd when curr = st4c;

    wdmem <= B when curr = st4b;

	rad2 <= IR(3 DOWNTO 0) WHEN curr = st2 ELSE
        IR(15 DOWNTO 12);

    opd1 <= pcout when curr = st3c else
        A;

    opd2 <= (X"000000" & immd) WHEN (curr = st3a and DP_operand_src = imm)
        ELSE
        (X"00000" & offset) WHEN (curr = st3b)
        ELSE
        B when (curr = st3a and DP_operand_src = reg);

    A <= rd1 when curr = st2;
    B <= rd2 when curr = st2;

    RES <= result when curr = st3a or curr = st3b;

    opalu <= add WHEN (curr = st3b and DT_offset_sign = plus) ELSE
        sub WHEN (curr = st3b and DT_offset_sign = minus) ELSE
        adc when (curr = st3c) else
        op;

    cin <= '1' when opalu = adc else '0';

    wd <= DR WHEN curr = st5 ELSE
        RES;

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            pcin <= x"00000000";
        END IF;
        IF rising_edge(clk) THEN
            CASE curr IS
                WHEN st1 =>
                    write_en <= '1'; --pc= pc+4
                    rw <= '0';
                    SBit <= '0';
                    mw <= "0000"; --mem read
                    nex <= st2; --update state
                WHEN st2 =>
                    write_en <= '0';
                    SBit <= '0';
                    rw <= '0';
                    mw <= "0000";
                    IF instr_class = DP THEN
                        nex <= st3a;
                    ELSIF instr_class = DT THEN
                        nex <= st3b;
                    ELSE
                        nex <= st3c;
                    END IF;
                WHEN st3a =>
                    rw <= '0';
                    mw <= "0000";
                    write_en <= '0';
                    IF op = cmp THEN
                        SBit <= '1';
                    ELSE
                        SBit <= '0';
                    END IF;
                    
                    nex <= st4a;
                WHEN st3b =>
                    rw <= '0';
                    mw <= "0000";
                    write_en <= '0';
                    SBit <= '0';
                    IF load_store = store THEN
                        nex <= st4b;
                    ELSE
                        nex <= st4c;
                    END IF;
                WHEN st3c =>
                    --branch
                    SBit <= '0';
                    nex <= st1;
                    pcin <= pcout;
                WHEN st4a => --last stage for DP
                    SBit <= '0';
                    mw <= "0000";
                    write_en <= '0';
                    IF op = cmp THEN
                        rw <= '0';
                    ELSE
                        rw <= '1';
                    END IF;
                    nex <= st1;
                    pcin <= pcout;
                WHEN st4b => --store
                    SBit <= '0';

                    mw <= "1111";
                    write_en <= '0';
                    rw <= '0';
                    nex <= st1;
                    pcin <= pcout;
                WHEN st4c => --load
                    rw <= '0';
                    SBit <= '0';
                    mw <= "0000";
                    write_en <= '0';
                    nex <= st5;
                WHEN st5 =>
                    rw <= '1';
                    SBit <= '0';
                    mw <= "0000";
                    write_en <= '0';
                    nex <= st1;
                    pcin <= pcout;
                WHEN OTHERS =>
                    NULL;
            END CASE;
            state<=nex;
            curr <= nex;
        END IF;
    END PROCESS;
END beh_Processor;