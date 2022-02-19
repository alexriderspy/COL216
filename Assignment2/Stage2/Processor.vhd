LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Processor IS
    PORT (
        clk : IN STD_LOGIC);
END ENTITY Processor;

ARCHITECTURE beh_Processor OF Processor IS

    COMPONENT pc IS
        PORT (
            pcin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pcout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            clk : IN STD_LOGIC;
            predicate : IN STD_LOGIC
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

    COMPONENT pm IS
        PORT (
            rd : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            dd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

    COMPONENT dm IS
        PORT (
            addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            wn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    --pc, pm
    SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --decoder
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
    SIGNAL res : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rw : STD_LOGIC := '0';
    SIGNAL mw : STD_LOGIC_VECTOR := "0000";
    SIGNAL cout : STD_LOGIC;

    SIGNAL ZF : STD_LOGIC := '0';
    SIGNAL NF : STD_LOGIC := '0';
    SIGNAL VF : STD_LOGIC := '0';
    SIGNAL CF : STD_LOGIC := '0';
    SIGNAL p : STD_LOGIC := '0';
    SIGNAL offset : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    DUT1 : pm PORT MAP(pcin(7 DOWNTO 2), instr);
    DUT2 : Decoder PORT MAP(instr, instr_class, op, DP_subclass, DP_operand_src, load_store, DT_offset_sign);

    DUT3 : regtr PORT MAP(instr(19 DOWNTO 16), rad2, clk, wd, instr(15 DOWNTO 12), rw, rd1, rd2);
    DUT4 : ALU PORT MAP(rd1, alu2, op, res, '0', cout);

    DUT5 : flagupd PORT MAP(rd1(31), alu2(31), cout, res, '0', instr, SBit, clk, ZF, NF, VF, CF);
    DUT6 : dm PORT MAP(res(7 DOWNTO 2), clk, rd2, rd, mw);

    DUT7 : cond PORT MAP(instr(31 DOWNTO 28), ZF, VF, CF, NF, p);
    DUT8 : pc PORT MAP(pcin, instr, pcout, clk, p);

    offset <= instr(7 DOWNTO 0);

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            pcin <= pcout;
        END IF;
    END PROCESS;

    rad2 <= instr(3 DOWNTO 0) WHEN instr_class = DP ELSE
        instr(15 DOWNTO 12) WHEN instr_class = DT;

    mw <= "0000" WHEN (instr_class = DP OR instr_class = BRN) ELSE
        "1111" WHEN instr_class = DT;

    alu2 <= X"000000" & offset WHEN instr_class = DP AND instr(25) = '1'
        ELSE
        rd2 WHEN instr_class = DP AND instr(25) = '0';

    SBit <= '0' WHEN instr_class = DP AND (op = add OR op = sub OR op = mov)
        ELSE
        '1' WHEN instr_class = DP AND (op = cmp);
    rw <= '1' WHEN instr_class = DP AND (op = add OR op = sub OR op = mov)
        ELSE
        '0' WHEN instr_class = DP AND op = cmp;

    wd <= res WHEN instr_class = DP;

    SBit <= '0' WHEN instr_class = DT;
    mw <= "0000" WHEN instr_class = DT AND load_store = load
        ELSE
        "1111" WHEN instr_class = DT AND load_store = store;
    rw <= '1' WHEN instr_class = DT AND load_store = load
        ELSE
        '0' WHEN instr_class = DT AND load_store = store;
    wd <= rd WHEN instr_class = DT AND load_store = load;

    SBit <= '0' WHEN instr_class = BRN;
    rw <= '0' WHEN instr_class = BRN;
END beh_Processor;