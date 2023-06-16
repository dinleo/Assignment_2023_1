library verilog;
use verilog.vl_types.all;
entity signalunit is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        flags           : in     vl_logic_vector(11 downto 0);
        zero            : in     vl_logic;
        Mwrite          : out    vl_logic;
        IRwrite         : out    vl_logic;
        PCsave          : out    vl_logic;
        Mread           : out    vl_logic;
        regwrite        : out    vl_logic;
        regdst          : out    vl_logic_vector(1 downto 0);
        regsrc          : out    vl_logic_vector(1 downto 0);
        ALUsrcA         : out    vl_logic_vector(1 downto 0);
        ALUsrcB         : out    vl_logic_vector(1 downto 0);
        ALUop           : out    vl_logic_vector(3 downto 0);
        NZCVwrite       : out    vl_logic;
        immsrc          : out    vl_logic_vector(1 downto 0);
        regbdst         : out    vl_logic
    );
end signalunit;
