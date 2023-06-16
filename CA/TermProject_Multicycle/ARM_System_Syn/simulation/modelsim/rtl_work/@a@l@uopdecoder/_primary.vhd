library verilog;
use verilog.vl_types.all;
entity ALUopdecoder is
    port(
        instop          : in     vl_logic_vector(3 downto 0);
        aluop           : out    vl_logic_vector(2 downto 0)
    );
end ALUopdecoder;
