library verilog;
use verilog.vl_types.all;
entity RxUnit is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        Enable          : in     vl_logic;
        RxD             : in     vl_logic;
        RD              : in     vl_logic;
        FErr            : out    vl_logic;
        OErr            : out    vl_logic;
        DRdy            : out    vl_logic;
        DataIn          : out    vl_logic_vector(7 downto 0)
    );
end RxUnit;
