LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Processor IS
    PORT (
        clk, reset : IN STD_LOGIC
    );
END ENTITY Processor;

ARCHITECTURE beh_Processor OF Processor IS

    COMPONENT Decoder IS
        PORT (
            instruction : IN word;
            instr_class : OUT instr_class_type;
            operation : OUT optype;
            DP_subclass : OUT DP_subclass_type;
            DP_operand_src : OUT DP_operand_src_type;
            DT_operand_src : OUT DP_operand_src_type;
            load_store : OUT load_store_type;
            DT_offset_sign : OUT DT_offset_sign_type;
            shift_operand_src : OUT DP_operand_src_type;
            shift_typ : OUT shift_type
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
            DP_subclass : IN DP_subclass_type;
            SBit : IN STD_LOGIC;
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

    COMPONENT Sh_ror IS
        PORT (
            inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            amt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            typ : IN shift_type;
            carry_in : IN STD_LOGIC;
            oupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            carry_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0);

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
    SIGNAL alu1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rw : STD_LOGIC := '0';
    SIGNAL mw : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL cout : STD_LOGIC;

    SIGNAL cin : STD_LOGIC := '0';

    SIGNAL ZF : STD_LOGIC := '0';
    SIGNAL NF : STD_LOGIC := '0';
    SIGNAL VF : STD_LOGIC := '0';
    SIGNAL CF : STD_LOGIC := '0';
    SIGNAL ZFlag : STD_LOGIC := '0';
    SIGNAL NFlag : STD_LOGIC := '0';
    SIGNAL VFlag : STD_LOGIC := '0';
    SIGNAL CFlag : STD_LOGIC := '0';
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

    SIGNAL curr : INTEGER;

    SIGNAL S_ext : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL S_offset : STD_LOGIC_VECTOR (23 DOWNTO 0);

    SIGNAL C : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL shift_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL shift_amt : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL shift_typ : shift_type;
    SIGNAL shift_ty : shift_type;
    SIGNAL DT_operand_src : DP_operand_src_type;
    SIGNAL shift_operand_src : DP_operand_src_type;
    SIGNAL oupt : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cout_s : STD_LOGIC;

    SIGNAL W : STD_LOGIC;
    SIGNAL P : STD_LOGIC;

BEGIN

    DUT1 : Decoder PORT MAP(IR, instr_class, op, DP_subclass, DP_operand_src, DT_operand_src, load_store, DT_offset_sign, shift_operand_src, shift_typ);

    DUT2 : regtr PORT MAP(IR(19 DOWNTO 16), rad2, clk, wd, IR(15 DOWNTO 12), rw, rd1, rd2);
    DUT3 : ALU PORT MAP(alu1, alu2, opalu, result, cin, cout);

    DUT4 : flagupd PORT MAP(rd1(31), alu2(31), cout, result, '0', IR, DP_subclass, IR(20), ZF, NF, VF, CF);
    DUT5 : mem PORT MAP(addr, clk, B, rd, mw);

    DUT6 : cond PORT MAP(IR(31 DOWNTO 28), ZFlag, VFlag, CFlag, NFlag, p);

    DUT7 : Sh_ror PORT MAP(shift_data, shift_amt, shift_ty, CFlag, oupt, cout_s);
    --cout_s is carry_out from shifter

    immd <= IR(7 DOWNTO 0);
    offset <= IR(11 DOWNTO 0);

    W <= IR(21);
    P <= IR(24);

    shift_amt <= C(4 DOWNTO 0) WHEN curr = 22 ELSE
        IR(11 DOWNTO 8) & '0' WHEN curr = 23 ELSE
        IR(11 DOWNTO 7);

    shift_data <= (X"000000" & immd) WHEN curr = 23 ELSE
        B;

    shift_ty <= RORx WHEN curr = 23 ELSE
        shift_typ;

    addr <= STD_LOGIC_VECTOR(unsigned(pcin(8 DOWNTO 2)) + 64) WHEN curr = 0 ELSE
        A(8 DOWNTO 2) WHEN P = '0' ELSE --post-index 
        RES(8 DOWNTO 2);

    rad2 <= IR(3 DOWNTO 0) WHEN (curr = 1) ELSE
        IR(11 DOWNTO 8) WHEN curr = 21 ELSE
        IR(15 DOWNTO 12);

    mw <= "1111" WHEN curr = 41 ELSE
        "0000";

    alu1 <= ("00" & pcout(31 DOWNTO 2)) WHEN curr = 32 ELSE
        pcin WHEN curr = 0 ELSE
        A;

    alu2 <= (S_ext & S_offset) WHEN curr = 32 AND p = '1' ELSE
        (X"0000000" & "0100") WHEN curr = 0 ELSE
        C WHEN curr = 31 ELSE
        B;

    S_offset <= IR (23 DOWNTO 0);
    S_ext <= "11111111" WHEN (IR(23) = '1') ELSE
        "00000000";

    opalu <= add WHEN (curr = 31 AND DT_offset_sign = plus) ELSE
        sub WHEN (curr = 31 AND DT_offset_sign = minus) ELSE
        add WHEN curr = 0 ELSE
        adc WHEN curr = 32 ELSE
        op;

    cin <= '1' WHEN curr = 32 ELSE
        CFlag WHEN (curr = 30 AND (op = adc OR op = sbc OR op = rsc)) ELSE
        '0';

    rw <= '1' WHEN (curr = 5 OR (curr = 40 AND (op = andop OR op = eor OR op = sub OR op = rsb OR op = add OR op = adc OR op = sbc OR op = rsc OR op = orr OR op = mov OR op = bic OR op = mvn)) OR ((curr = 42) AND (W = '1' OR P = '0')) OR ((curr = 41) AND (W = '1' OR P = '0'))) ELSE
        '0';

    wd <= rd WHEN curr = 5 ELSE
        RES;

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            pcin <= x"00000000";
            curr <= 0;
        ELSIF rising_edge(clk) THEN
            CASE curr IS
                WHEN 0 =>
                    IR <= rd;
                    pcout <= result;
                    curr <= 1;
                WHEN 1 =>
                    A <= rd1;
                    B <= rd2;
                    IF instr_class = DP THEN
                        IF DP_operand_src = reg THEN
                            IF shift_operand_src = imm THEN
                                curr <= 20;
                            ELSE
                                curr <= 21;
                            END IF;
                        ELSE
                            curr <= 23; --imm
                        END IF;
                    ELSIF instr_class = DT THEN
                        IF DT_operand_src = reg THEN
                            --only constant so no branching here
                            curr <= 24;
                        ELSE
                            curr <= 25;
                        END IF;
                    ELSE
                        curr <= 32;
                    END IF;
                WHEN 20 =>
                    curr <= 30;
                    B <= oupt;
                WHEN 21 =>
                    C <= rd2;
                    curr <= 22;
                WHEN 22 =>
                    B <= oupt;
                    curr <= 30;
                WHEN 23 =>
                    B <= oupt;
                    curr <= 30;
                WHEN 24 =>
                    C <= oupt;
                    curr <= 31;
                WHEN 25 =>
                    C <= (X"00000" & offset); --no shift/rotate
                    curr <= 31;
                WHEN 30 =>
                    RES <= result;
                    curr <= 40;
                    IF IR(20) = '1' THEN
                        ZFlag <= ZF;
                        CFlag <= CF;
                        NFlag <= NF;
                        VFlag <= VF;
                    END IF;
                WHEN 31 =>
                    RES <= result;
                    B <= rd2;
                    IF load_store = store THEN
                        curr <= 41;
                    ELSE
                        curr <= 42;
                    END IF;
                WHEN 32 =>
                    curr <= 0;
                    IF p = '1' THEN
                        pcin <= (result(29 DOWNTO 0) & "00");
                    ELSE
                        pcin <= pcout;
                    END IF;
                WHEN 40 =>
                    curr <= 0;
                    pcin <= pcout;
                WHEN 41 =>
                    curr <= 0;
                    pcin <= pcout;
                WHEN 42 =>
                    DR <= rd;
                    curr <= 5;
                WHEN 5 =>
                    curr <= 0;
                    pcin <= pcout;
                WHEN OTHERS =>
                    NULL;
            END CASE;
        END IF;
    END PROCESS;
END beh_Processor;