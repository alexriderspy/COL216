LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Processor IS
    PORT (
        clk, reset : IN STD_LOGIC);
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
    SIGNAL pcin : STD_LOGIC_VECTOR(31 DOWNTO 0);
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
    SIGNAL mw : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    SIGNAL cout : STD_LOGIC;

    SIGNAL ZF : STD_LOGIC := '0';
    SIGNAL NF : STD_LOGIC := '0';
    SIGNAL VF : STD_LOGIC := '0';
    SIGNAL CF : STD_LOGIC := '0';
    SIGNAL p : STD_LOGIC := '0';
    SIGNAL offset : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL immd : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal addr : std_logic_vector(5 downto 0);
    signal opalu : optype;
BEGIN

    DUT1 : pm PORT MAP(pcin(7 DOWNTO 2), instr);
    DUT2 : Decoder PORT MAP(instr, instr_class, op, DP_subclass, DP_operand_src, load_store, DT_offset_sign);

    DUT3 : regtr PORT MAP(instr(19 DOWNTO 16), rad2, clk, wd, instr(15 DOWNTO 12), rw, rd1, rd2);
    DUT4 : ALU PORT MAP(rd1, alu2, opalu, res, '0', cout);

    DUT5 : flagupd PORT MAP(rd1(31), alu2(31), cout, res, '0', instr, SBit, clk, ZF, NF, VF, CF);
    DUT6 : dm PORT MAP(addr, clk, rd2, rd, mw);

    DUT7 : cond PORT MAP(instr(31 DOWNTO 28), ZF, VF, CF, NF, p);
    DUT8 : pc PORT MAP(pcin, instr, pcout, clk, p);

    immd <= instr(7 DOWNTO 0);
    offset <= instr(11 DOWNTO 0);

    addr <= res(7 downto 2);

    rad2 <= instr(3 DOWNTO 0) WHEN instr_class = DP ELSE
        instr(15 DOWNTO 12);

    mw <= "1111" WHEN instr_class = DT AND load_store = store ELSE
        "0000";

    alu2 <= (X"000000" & immd) WHEN DP_operand_src = imm AND instr_class = DP
        ELSE
        (X"00000" & offset) WHEN instr_class = DT
        
        ELSE
        rd2;

    opalu <= add when (instr_class = DT and DT_offset_sign = plus) else sub when (instr_class = DT and DT_offset_sign = minus) else op;

    SBit <= '1' WHEN instr_class = DP AND op = cmp
        ELSE
        '0';

    rw <= '0' WHEN ((instr_class = DP AND op = cmp) OR (instr_class = DT AND load_store = store) OR instr_class = BRN) ELSE
        '1';

    wd <= rd WHEN instr_class = DT AND load_store = load ELSE
        res;

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            pcin <= x"00000000";
        END IF;
        IF rising_edge(clk) THEN
            pcin <= pcout;
        END IF;
    END PROCESS;

END beh_Processor;