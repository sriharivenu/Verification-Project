`timescale 1ns / 100ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import modules_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;
import tests::*;

module dut(dut_in _in, dut_out _out);
fpu u0(
    .clk(_in.clk),
    .opa(_in.opa),
    .opb(_in.opb),
    .rmode(_in.rmode),
    .fpu_op(_in.fpu_op),
    .out(_out.out),
    .inf(_out.inf),
    .snan(_out.snan),
    .qnan(_out.qnan),
    .ine(_out.ine),
    .overflow(_out.overflow),
    .underflow(_out.underflow),
    .zero(_out.zero),
    .div_by_zero(_out.div_by_zero)
);
endmodule: dut

module top;    
dut_in dut_in1();
dut_out dut_out1();

initial begin
    dut_in1.clk<=0;
    forever #5 dut_in1.clk<=~dut_in1.clk;
end

initial begin
    dut_out1.clk<=0;
    forever #5 dut_out1.clk<=~dut_out1.clk;
end


dut dut1(._in(dut_in1),._out(dut_out1));

initial begin
    uvm_config_db #(virtual dut_in)::set(null,"uvm_test_top","dut_vi_in",dut_in1);
    uvm_config_db #(virtual dut_out)::set(null,"uvm_test_top","dut_vi_out",dut_out1);
    uvm_top.finish_on_completion=1;

    //TODO:Modify the test name here
    run_test("test1");
end

endmodule: top
