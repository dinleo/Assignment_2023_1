library verilog;
use verilog.vl_types.all;
entity armreduced is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0);
        inst            : in     vl_logic_vector(31 downto 0);
        nIRQ            : in     vl_logic;
        be              : out    vl_logic_vector(3 downto 0);
        memaddr         : out    vl_logic_vector(31 downto 0);
        memwrite        : out    vl_logic;
        memread         : out    vl_logic;
        writedata       : out    vl_logic_vector(31 downto 0);
        readdata        : in     vl_logic_vector(31 downto 0)
    );
end armreduced;
