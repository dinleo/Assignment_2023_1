library verilog;
use verilog.vl_types.all;
entity LogicUnit is
    port(
        inpa            : in     vl_logic_vector(31 downto 0);
        inpb            : in     vl_logic_vector(31 downto 0);
        andor           : in     vl_logic;
        xorop           : in     vl_logic;
        outp            : out    vl_logic_vector(31 downto 0)
    );
end LogicUnit;
