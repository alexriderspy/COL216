LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyTypes.ALL;

ENTITY mul_accu IS
    PORT (
        Rd_val : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rn_val : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rs_val : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rm_val : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mul_acc : IN mul_acc_type;
        result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END mul_accu;

ARCHITECTURE beh_mul_acc OF mul_accu IS

    SIGNAL p_s : signed (63 DOWNTO 0);
    SIGNAL p_u : unsigned (63 DOWNTO 0);
    SIGNAL res : STD_LOGIC_VECTOR(63 DOWNTO 0);
BEGIN

    p_s <= signed (Rm_val) * signed (Rs_val);
    p_u <= unsigned (Rm_val) * unsigned (Rs_val);

    res <= STD_LOGIC_VECTOR(p_s) WHEN (mul_acc = mul OR mul_acc = smull OR mul_acc = smlal OR mul_acc = mla) ELSE
        STD_LOGIC_VECTOR(p_u);

    result <= STD_LOGIC_VECTOR(signed(res) + signed(Rn_val)) WHEN (mul_acc = mla) ELSE
        res WHEN (mul_acc = mul OR mul_acc = smull OR mul_acc = umull) ELSE
        STD_LOGIC_VECTOR(signed(res) + signed(Rd_val & Rn_val));

END beh_mul_acc;