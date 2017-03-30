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
	covlabel1: coverpoint opa {
	bins low = {[0:143165576]};
	bins low1 = {[143165577:286331153]};
	bins low2 ={[286331154:429496729]};
	bins low3 ={[429496730:572662306]};
	bins low4 ={[572662307:715827882]};
	bins low5 ={[715827883:858993459]};
	bins low6 ={[858993460:1002159035]};
	bins low7 ={[1002159036:1145324612]};
	bins low8 ={[1145324613:1288490188]};
	bins low9 ={[1288490189:1431655765]};
	bins low10 ={[1431655766:1574821341]};
	bins low11 ={[1574821342:1717986918]};
	bins low12 ={[1717986919:1861152494]};
	bins low13 ={[1861152495:2004318071]};
	bins low14 ={[2004318072:2147483647]};
        }
	covlabel2: coverpoint opb  {
	bins low = {[0:143165576]};
        bins low1 = {[143165577:286331153]};
        bins low2 ={[286331153:429496729]};
        bins low3 ={[429496730:572662306]};
        bins low4 ={[572662307:715827882]};
        bins low5 ={[715827883:858993459]};
        bins low6 ={[858993460:1002159035]};
        bins low7 ={[1002159036:1145324612]};
        bins low8 ={[1145324613:1288490188]};
        bins low9 ={[1288490189:1431655765]};
        bins low10 ={[1431655766:1574821341]};
        bins low11 ={[1574821342:1717986918]};
        bins low12 ={[1717986919:1861152494]};
        bins low13 ={[1861152495:2004318071]};
        bins low14 ={[2004318072:2147483647]};
        }
	/*covlabel3: coverpoint cin {
	bins up = {0};
	bins dn = {1};
	}*/
	covlabel4: coverpoint fpu_op {
	bins op1 = {0};
	bins op2 = {1};
	bins op3 = {2};
	bins op4 = {3};
	bins op5 = {4};
	bins op6 = {5};
	bins op7 = {6};
	bins op8 = {7};
	}
	//covlabel3_x_covlabel4: cross covlabel3, covlabel4;
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
    //     inputs.sample();
        
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

    //TODO: Add covergroups for the outputs
/*    	covergroup outputs;
	covlabel1: coverpoint out {
	bins low = {[0:2000]};
	bins high = {[2001:10000]};
	}
	/*covlabel2: coverpoint vout  {
	bins up = {0};
	bins dn = {1};
	}
	covlabel3: coverpoint cout {
	bins up = {0};
	bins dn = {1};
	}*/
//endgroup: outputs
function new(string name, uvm_component parent);
    super.new(name,parent);
  //   outputs=new;
    
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
    //outputs.sample();
    
endfunction: write
endclass: alu_subscriber_out

endpackage: coverage
