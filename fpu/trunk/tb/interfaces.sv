interface dut_in;
    logic           clk;
    logic   [1:0]   rmode;
    logic   [2:0]   fpu_op;
    logic   [31:0]  opa, opb;
endinterface: dut_in

interface dut_out;
    logic           clk;
    logic   [31:0]  out;
    logic   	    inf,snan,qnan;
    logic           ine;
    logic           overflow, underflow;
    logic   	    zero;
    logic           div_by_zero;
endinterface: dut_out
