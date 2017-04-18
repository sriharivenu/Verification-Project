`include "uvm_macros.svh"
package coverage;
import sequences::*;
import uvm_pkg::*;

class alu_subscriber_in extends uvm_subscriber #(alu_transaction_in);
    `uvm_component_utils(alu_subscriber_in)

    //Declare Variables
    logic [32:0] opa;
    logic [32:0] opb;
    logic [2:0] fpu_op;
    logic [1:0] rmode;

    //TODO: Add covergroups for the inputs
    covergroup inputs;
        opa_cov: coverpoint opa {
        
    bins zero_po = {0};
    bins zero_ng = {-2147483648};
    bins subs_po = {[1: 8388607]};
    bins subs_ng = {[-2147483649 : -2155872255]};
    bins norm_po = {[16777216: 2139095039]};
    bins norm_ng = {[-2164260864: -4286578687]};
    bins inf_po = {2139095040};
    bins inf_ng = {-4286578688};
    bins nan_po = {[2139095041: 2147483647]};
    bins nan_ng = {[-4286578689: -4294967295]};
    //    option.auto_bin_max = 64;
        // bins low = {[0:143165576]};
        // bins low1 = {[143165577:286331153]};
        // bins low2 ={[286331154:429496729]};
        // bins low3 ={[429496730:572662306]};
        // bins low4 ={[572662307:715827882]};
        // bins low5 ={[715827883:858993459]};
        // bins low6 ={[858993460:1002159035]};
        // bins low7 ={[1002159036:1145324612]};
        // bins low8 ={[1145324613:1288490188]};
        // bins low9 ={[1288490189:1431655765]};
        // bins low10 ={[1431655766:1574821341]};
        // bins low11 ={[1574821342:1717986918]};
        // bins low12 ={[1717986919:1861152494]};
        // bins low13 ={[1861152495:2004318071]};
        // bins low14 ={[2004318072:2147483647]};
            }
        opb_cov: coverpoint opb  {
        bins zero_p = {0};
    bins zero_n = {2147483648};
    bins subs_p = {[1: 8388607]};
    bins subs_n = {[2147483649 : 2155872255]};
    bins norm_p = {[16777216: 2139095039]};
    bins norm_n = {[2164260864: 4286578687]};
    bins inf_p = {2139095040};
    bins inf_n = {4286578688};
    bins nan_p = {[2139095041: 2147483647]};
    bins nan_n = {[4286578689: 4294967295]};
    //   option.auto_bin_max = 64;
        // bins low = {[0:143165576]};
     //        bins low1 = {[143165577:286331153]};
     //        bins low2 ={[286331153:429496729]};
     //        bins low3 ={[429496730:572662306]};
     //        bins low4 ={[572662307:715827882]};
     //        bins low5 ={[715827883:858993459]};
     //        bins low6 ={[858993460:1002159035]};
     //        bins low7 ={[1002159036:1145324612]};
     //        bins low8 ={[1145324613:1288490188]};
     //        bins low9 ={[1288490189:1431655765]};
     //        bins low10 ={[1431655766:1574821341]};
     //        bins low11 ={[1574821342:1717986918]};
     //        bins low12 ={[1717986919:1861152494]};
     //        bins low13 ={[1861152495:2004318071]};
     //        bins low14 ={[2004318072:2147483647]};
            }
        /*covlabel3: coverpoint cin {
        bins up = {0};
        bins dn = {1};
        }*/
        fpu_op_cov: coverpoint fpu_op {
            bins op1 = {0};
            bins op2 = {1};
            bins op3 = {2};
            bins op4 = {3};
            bins op5 = {4};
            bins op6 = {5};
            bins op7 = {6};
            bins op8 = {7};
        }

        rmode_cov: coverpoint rmode {
            bins rmode_0 = {0};
            bins rmode_1 = {1};
            bins rmode_2 = {2};
            bins rmode_3 = {3};
        }
        
        rmode_opcode_cross: cross fpu_op_cov, rmode_cov;
        in_A_opcode_cross:  cross fpu_op_cov, opa_cov;
        in_B_opcode_cross:  cross fpu_op_cov, opb_cov;
    inp_cross:      cross opa_cov, opb_cov;
    endgroup: inputs
    function new(string name, uvm_component parent);
        super.new(name,parent);
        inputs=new;
        
    endfunction: new

    function void write(alu_transaction_in t);
        opa={t.opa};
        opb={t.opb};
        fpu_op={t.fpu_op};
        rmode={t.rmode};
        /* TODO: Uncomment*/
         inputs.sample();
        
    endfunction: write

endclass: alu_subscriber_in

class alu_subscriber_out extends uvm_subscriber #(alu_transaction_out);
    `uvm_component_utils(alu_subscriber_out)

    logic [31:0] out;
    logic  inf,snan,qnan;
    logic ine;
    logic overflow,underflow;
    logic zero;
    logic div_by_zero;

    covergroup outputs;
        output_cov: coverpoint out {
            //option.auto_bin_max = 64;
    bins zero_p = {0};
    bins zero_n = {2147483648};
    bins subs_p = {[1: 8388607]};
    bins subs_n = {[2147483649 : 2155872255]};
    bins norm_p = {[16777216: 2139095039]};
    bins norm_n = {[2164260864: 4286578687]};
    bins inf_p = {2139095040};
    bins inf_n = {4286578688};
    bins nan_p = {[2139095041: 2147483647]};
    bins nan_n = {[4286578689: 4294967295]};
        }
        
        inf_cov: coverpoint inf {
            bins inf_0 = {0};
            bins inf_1 = {1};
        }

        snan_cov: coverpoint snan {
            bins snan_0 = {0};
            bins snan_1 = {1};
        }

        qnan_cov: coverpoint qnan {
            bins qnan_0 = {0};
            bins qnan_1 = {1};
        }

        ine_cov: coverpoint ine {
            bins ine_0 = {0};
            bins ine_1 = {1};
        }

        overflow_cov: coverpoint overflow{
            bins overflow_0 = {0};
            bins overflow_1 = {1};
        }

        underflow_cov: coverpoint underflow {
            bins underflow_0 = {0};
            bins underflow_1 = {1};
        }

        zero_cov: coverpoint zero {
            bins zero_0 = {0};
            bins zero_1 = {1};
        }

        div_by_zero_cov: coverpoint div_by_zero {
            bins div_by_zero_0 = {0};
            bins div_by_zero_1 = {1};
        }

        //snan_qnan_out_cross: cross output_cov, snan_cov, qnan_cov;
        //inf_overflow_underflow_out_cross: cross inf_cov, out_cov, overflow_cov, underflow_cov;
        //ine_zero_div_out_cross: cross ine_cov, zero_cov, div_by_zero_cov, output_cov; 

    endgroup: outputs

function new(string name, uvm_component parent);
    super.new(name,parent);
     outputs=new;
    
endfunction: new

function void write(alu_transaction_out t);
    out={t.out};
    inf={t.inf};
    snan={t.snan};
    qnan={t.qnan};
    ine={t.ine};
    overflow={t.overflow};
    underflow={t.underflow};
    zero={t.zero};
    div_by_zero={t.div_by_zero};        
    outputs.sample();
    
endfunction: write
endclass: alu_subscriber_out

endpackage: coverage