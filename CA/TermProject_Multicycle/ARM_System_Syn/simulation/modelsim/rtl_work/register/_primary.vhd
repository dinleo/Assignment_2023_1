library verilog;
use verilog.vl_types.all;
entity \register\ is
    port(
        regin           : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        write           : in     vl_logic;
        reset           : in     vl_logic;
        regout          : out    vl_logic_vector(31 downto 0)
    );
end \register\;
