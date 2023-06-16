library verilog;
use verilog.vl_types.all;
entity miniUART is
    port(
        SysClk          : in     vl_logic;
        Reset           : in     vl_logic;
        CS_N            : in     vl_logic;
        RD_N            : in     vl_logic;
        WR_N            : in     vl_logic;
        RxD             : in     vl_logic;
        TxD             : out    vl_logic;
        IntRx_N         : out    vl_logic;
        IntTx_N         : out    vl_logic;
        Addr            : in     vl_logic_vector(1 downto 0);
        DataIn          : in     vl_logic_vector(7 downto 0);
        DataOut         : out    vl_logic_vector(7 downto 0)
    );
end miniUART;
