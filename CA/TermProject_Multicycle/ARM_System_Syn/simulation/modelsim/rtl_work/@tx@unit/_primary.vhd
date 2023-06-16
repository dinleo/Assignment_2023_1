library verilog;
use verilog.vl_types.all;
entity TxUnit is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        Enable          : in     vl_logic;
        Load            : in     vl_logic;
        TxD             : out    vl_logic;
        TRegE           : out    vl_logic;
        TBufE           : out    vl_logic;
        DataO           : in     vl_logic_vector(7 downto 0)
    );
end TxUnit;
