LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY Processor IS
    PORT (
        clk : STD_LOGIC;
        reset : STD_LOGIC
    );
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


BEGIN
    PROCESS (reset, clock)
    BEGIN
        IF (reset = '1') THEN
            PC <= X"00000000";
        ELSIF (rising_edge(clock)) THEN
            
            PC <= STD_LOGIC_VECTOR (signed(PC) + 4);
            CASE F IS
                    -- DP instructions sub, add, cmp, mov
                WHEN "00" =>
                    CASE OP IS
                            -- Instruction sub
                        WHEN "00" => RF(Rd) <= STD_LOGIC_VECTOR(signed(RF(Rn)) - signed(RF(Rm)));
                            -- Instruction add
                        WHEN "01" => RF(Rd) <= STD_LOGIC_VECTOR(signed(RF(Rn)) + signed(RF(Rm)));
                            -- Instruction cmp
                        WHEN "10" => IF (RF(Rn) = RF(Rm)) THEN
                            Zflag <= '1';
                        ELSE
                            Zflag <= '1';
                    END IF;
                    -- Instruction mov
                WHEN "11" => RF(Rd) <= X"000000" & Imm;
            END CASE;
            -- DT instructions ldr, str
            WHEN "01" =>
            IF (Lbit = '1') THEN
                RF(Rd) <= DM(DMadr);
            ELSE
                DM(DMAdr) <= RF(Rd);
            END IF;
            -- Branch instructions b, beq, bne
            WHEN "10" =>
            IF (predicate = '1') THEN
                -- This assignment to PC would override earlier assignment
                PC <= STD_LOGIC_VECTOR (signed(PC) + signed(S_ext & S_offset & "00") + 8);
            END IF;
        END CASE;
    END IF;
END PROCESS
END ARCHITECTURE beh_Processor;