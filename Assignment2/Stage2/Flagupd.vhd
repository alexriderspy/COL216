LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY flagupd IS
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
END flagupd;

ARCHITECTURE flag_arch OF flagupd IS

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF instr(27 DOWNTO 26) = "00" THEN
                CASE instr(24 DOWNTO 22) IS
                    WHEN "001" | "010" | "011" =>
                        IF SBit = '1' THEN
                            ZFlag <= (res = x'"00000000");
                            CFlag <= cout;
                            VFlag <= (MSBa AND MSBb AND NOT(res(31))) + (NOT(MSBa) AND NOT(MSBb) AND res(31));
                            NFlag <= res(31);
                        END IF;
                    WHEN "000" | "110" | "111" =>
                        IF SBit = '1' THEN
                            IF instr(25) = '0' THEN
                                IF instr(11 DOWNTO 4) = x'"00" THEN
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                ELSE
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                    CFlag <= shiftout;
                                END IF;

                            ELSE
                                IF instr(11 DOWNTO 8) = x'"0" THEN
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                ELSE
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                    CFlag <= shiftout;
                                END IF;
                            END IF;
                        END IF;
                    WHEN "101" => --cmp
                        ZFlag <= (res = x'"00000000");
                        CFlag <= cout;
                        VFlag <= (signed(MSBa AND MSBb AND NOT(res(31))) + signed(NOT(MSBa) AND NOT(MSBb) AND res(31)));
                        NFlag <= res(31);

                    WHEN OTHERS =>
                        IF SBit = '1' THEN
                            IF instr(25) = '0' THEN
                                IF instr(11 DOWNTO 4) = x'"00" THEN
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                ELSE
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                    CFlag <= shiftout;
                                END IF;

                            ELSE
                                IF instr(11 DOWNTO 8) = x'"0" THEN
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                ELSE
                                    ZFlag <= (res = x'"00000000");
                                    NFlag <= res(31);
                                    CFlag <= shiftout;
                                END IF;
                            END IF;
                        ELSE
                            ZFlag <= (res = x'"00000000");
                            NFlag <= res(31);
                        END IF;

                END CASE;
            END IF;
        END IF;
    END PROCESS;
END flag_arch;