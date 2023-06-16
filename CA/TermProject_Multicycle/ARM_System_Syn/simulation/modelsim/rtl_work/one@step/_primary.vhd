library verilog;
use verilog.vl_types.all;
entity oneStep is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        new_flag        : in     vl_logic_vector(11 downto 0);
        step1           : out    vl_logic_vector(11 downto 0);
        step2           : out    vl_logic_vector(11 downto 0);
        step3           : out    vl_logic_vector(11 downto 0);
        step4           : out    vl_logic_vector(11 downto 0)
    );
end oneStep;
