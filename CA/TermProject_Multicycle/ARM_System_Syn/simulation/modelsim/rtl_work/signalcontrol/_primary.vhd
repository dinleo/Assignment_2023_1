library verilog;
use verilog.vl_types.all;
entity signalcontrol is
    port(
        flags           : in     vl_logic_vector(11 downto 0);
        zero            : in     vl_logic;
        s1              : out    vl_logic_vector(4 downto 0);
        s2              : out    vl_logic_vector(8 downto 0);
        s3              : out    vl_logic_vector(1 downto 0);
        s4              : out    vl_logic_vector(4 downto 0)
    );
end signalcontrol;
