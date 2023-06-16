library verilog;
use verilog.vl_types.all;
entity signextmux is
    port(
        \in\            : in     vl_logic_vector(23 downto 0);
        \select\        : in     vl_logic_vector(1 downto 0);
        extVal          : out    vl_logic_vector(31 downto 0)
    );
end signextmux;
