library verilog;
use verilog.vl_types.all;
entity register_1bit is
    port(
        regin           : in     vl_logic;
        clk             : in     vl_logic;
        write           : in     vl_logic;
        reset           : in     vl_logic;
        regout          : out    vl_logic
    );
end register_1bit;
