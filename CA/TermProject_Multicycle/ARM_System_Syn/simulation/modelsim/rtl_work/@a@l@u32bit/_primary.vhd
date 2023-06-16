library verilog;
use verilog.vl_types.all;
entity ALU32bit is
    port(
        inpa            : in     vl_logic_vector(31 downto 0);
        inpb            : in     vl_logic_vector(31 downto 0);
        cin             : in     vl_logic;
        aluop           : in     vl_logic_vector(2 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        negative        : out    vl_logic;
        zero            : out    vl_logic;
        cout            : out    vl_logic;
        overflow        : out    vl_logic
    );
end ALU32bit;
