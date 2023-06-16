library verilog;
use verilog.vl_types.all;
entity ClkUnit is
    port(
        SysClk          : in     vl_logic;
        EnableRx        : out    vl_logic;
        EnableTx        : out    vl_logic;
        Reset           : in     vl_logic
    );
end ClkUnit;
