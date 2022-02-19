LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pc IS
    PORT (
        pcin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clk : IN STD_LOGIC;
        predicate : IN STD_LOGIC
    );
END pc;

ARCHITECTURE pc_arch OF pc IS
    SIGNAL S_ext : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL S_offset : STD_LOGIC_VECTOR (23 DOWNTO 0);

BEGIN
    S_offset <= instr (23 DOWNTO 0);
    S_ext <= "111111" WHEN (instr(23) = '1') ELSE
        "000000";

    pcout <= STD_LOGIC_VECTOR (signed(pcout) + signed(S_ext & S_offset & "00") + 8) WHEN instr(27 DOWNTO 26) = "10" AND predicate = '1'
        ELSE
        STD_LOGIC_VECTOR (signed(pcout) + signed(S_ext & S_offset & "00") + 8) WHEN instr(27 DOWNTO 26) = "10" AND instr(29 DOWNTO 28) = "10"
        ELSE
        STD_LOGIC_VECTOR(signed(pcin) + 4);

END pc_arch;