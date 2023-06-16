library verilog;
use verilog.vl_types.all;
entity registerfile is
    port(
        reg1            : in     vl_logic_vector(3 downto 0);
        reg2            : in     vl_logic_vector(3 downto 0);
        regdst          : in     vl_logic_vector(3 downto 0);
        regsrc          : in     vl_logic_vector(31 downto 0);
        newPc           : in     vl_logic_vector(31 downto 0);
        PCsv            : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        we              : in     vl_logic;
        out1            : out    vl_logic_vector(31 downto 0);
        out2            : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0)
    );
end registerfile;
