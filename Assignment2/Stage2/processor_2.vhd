PROCESS(clk)
BEGIN

    offset <= instr(7 downto 0);
    IF (reset = '1') THEN
        pcin <= X"00000000";
    ELSE 
        CASE instr_class IS
            WHEN DP =>
                rad2 <= instr(3 DOWNTO 0);
                mw <= "0000";

                IF instr(25) = '1' THEN
                    alu2 <= X"000000" & offset;
                ELSE
                    alu2 <= rd2;
                END IF;

                CASE op IS
                    WHEN add | sub | mov =>
                        SBit <= '0';
                        rw <= '1';
                    WHEN cmp =>
                        SBit <= '1';
                        rw <= '0';
                    WHEN OTHERS => NULL;
                END CASE;
                wd <= res;
            WHEN DT =>
                rad2 <= instr(15 DOWNTO 12);
                SBit <= '0';
                IF load_store = load THEN
                    mw <= "1111";
                    rw <= '1';
                    wd <= rd;
                ELSE
                    mw <= "1111";
                    rw <= '0';
                END IF;

            WHEN BRN =>
                SBit <= '0';
                rw <= '0';
                mw <= "0000";
            WHEN OTHERS => NULL;

        END CASE;
        
        pcin <= pcout;
    END IF;

END PROCESS;