library verilog;
use verilog.vl_types.all;
entity ArithUnit is
    port(
        inpa            : in     vl_logic_vector(31 downto 0);
        inpb            : in     vl_logic_vector(31 downto 0);
        cin             : in     vl_logic;
        addsub          : in     vl_logic;
        carryop         : in     vl_logic;
        outp            : out    vl_logic_vector(31 downto 0);
        cout            : out    vl_logic;
        overflow        : out    vl_logic
    );
end ArithUnit;
