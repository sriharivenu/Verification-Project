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
    forever #50 dut_in1.clk<=~dut_in1.clk;
end

initial begin
    dut_out1.clk<=0;
    forever #50 dut_out1.clk<=~dut_out1.clk;
end


dut dut1(._in(dut_in1),._out(dut_out1));

initial begin
    uvm_config_db #(virtual dut_in)::set(null,"uvm_test_top","dut_vi_in",dut_in1);
    uvm_config_db #(virtual dut_out)::set(null,"uvm_test_top","dut_vi_out",dut_out1);
    uvm_top.finish_on_completion=1;

    //TODO:Modify the test name here
    run_test("test1"); // First 11 tests for add with different constraints
    run_test("test2");
    run_test("test3");
    run_test("test4");
    run_test("test5");
    run_test("test6");
    run_test("test7");
    run_test("test8");
    run_test("test9");
    run_test("test10");
    run_test("test11");
    run_test("test12");// Next 11 tests for SUB with different constraints
    run_test("test13");
    run_test("test14");
    run_test("test15");
    run_test("test16");
    run_test("test17");
    run_test("test18");
    run_test("test19");
    run_test("test20");
    run_test("test21");
    run_test("test22");
    run_test("test23");
    run_test("test24");// Next 11 tests for MUL with different constraints
    run_test("test25");
    run_test("test26");
    run_test("test27");
    run_test("test28");
    run_test("test29");
    run_test("test30");
    run_test("test31");
    run_test("test32");
    run_test("test33");
    run_test("test34");
    run_test("test35");// Next 11 tests for DIV with different constraints
    run_test("test36");
    run_test("test37");
    run_test("test38");
    run_test("test39");
    run_test("test40");
    run_test("test41");
    run_test("test42");
    run_test("test43");
    run_test("test44");
    

end

endmodule: top