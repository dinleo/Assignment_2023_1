library verilog;
use verilog.vl_types.all;
entity ALTPLL_clkgen_altpll is
    port(
        clk             : out    vl_logic_vector(5 downto 0);
        fbout           : out    vl_logic;
        inclk           : in     vl_logic_vector(1 downto 0);
        locked          : out    vl_logic
    );
end ALTPLL_clkgen_altpll;
