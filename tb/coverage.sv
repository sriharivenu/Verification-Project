`include "uvm_macros.svh"
package coverage;
import sequences::*;
import uvm_pkg::*;

class alu_subscriber_in extends uvm_subscriber #(alu_transaction_in);
    `uvm_component_utils(alu_subscriber_in)

    //Declare Variables
    logic [32:0] A;
    logic [32:0] B;
    logic [2:0] opcode;
    logic cin;

    //TODO: Add covergroups for the inputs
    /*covergroup inputs;
       
    endgroup: inputs
    */
	covergroup inputs;
	covlabel1: coverpoint A {
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
	/*bins low15 ={[2147483648:2290649224]};
	bins low16 ={[2290649225:2433814800]};
	bins low17 ={[2433814801:2576980377]};
	bins low18 ={[2576980377:2720145953]};
	bins low19 ={[2720145954:2863311530]};
	bins low20 ={[2863311531:3006477106]};
	bins low21 ={[3006477107:3149642683]};
	bins low22 ={[3149642684:3292808259]};
	bins low23 ={[3292808260:3435973836]};
	bins low24 ={[3435973837:3579139412]};
	bins low25 ={[3579139413:3722304989]};
	bins low26 ={[3722304990:3865470565]};
	bins low27 ={[3865470566:4008636142]};
	bins low28 ={[4008636143:4151801718]};
	bins low29 ={[4151801719:4294967295]};*/
        }
	covlabel2: coverpoint B  {
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
       /* bins low15 ={[2147483648:2290649224]};
        bins low16 ={[2290649225:2433814800]};
        bins low17 ={[2433814801:2576980377]};
        bins low18 ={[2576980377:2720145953]};
        bins low19 ={[2720145954:2863311530]};
        bins low20 ={[2863311531:3006477106]};
        bins low21 ={[3006477107:3149642683]};
        bins low22 ={[3149642684:3292808259]};
        bins low23 ={[3292808260:3435973836]};
        bins low24 ={[3435973837:3579139412]};
        bins low25 ={[3579139413:3722304989]};
        bins low26 ={[3722304990:3865470565]};
        bins low27 ={[3865470566:4008636142]};
        bins low28 ={[4008636143:4151801718]};
        bins low29 ={[4151801719:4294967295]};
        */}
	covlabel3: coverpoint cin {
	bins up = {0};
	bins dn = {1};
	}
	covlabel4: coverpoint opcode {
	bins op1 = {0};
	bins op2 = {1};
	bins op3 = {2};
	bins op4 = {3};
	bins op5 = {4};
	bins op6 = {5};
	bins op7 = {6};
	bins op8 = {7};
	}
	covlabel3_x_covlabel4: cross covlabel3, covlabel4;
	endgroup: inputs
    function new(string name, uvm_component parent);
        super.new(name,parent);
        /* TODO: Uncomment*/
         inputs=new;
        
    endfunction: new

    function void write(alu_transaction_in t);
        A={t.A};
        B={t.B};
        opcode={t.opcode};
        cin={t.CIN};
        /* TODO: Uncomment*/
         inputs.sample();
        
    endfunction: write

endclass: alu_subscriber_in

class alu_subscriber_out extends uvm_subscriber #(alu_transaction_out);
    `uvm_component_utils(alu_subscriber_out)

    logic [31:0] out;
    logic cout;
    logic vout;

    //TODO: Add covergroups for the outputs
    /*
     covergroup outputs;
        ...
    endgroup: outputs
    */
    	covergroup outputs;
	covlabel1: coverpoint out {
	bins low = {[0:2000]};
	bins high = {[2001:10000]};
	}
	covlabel2: coverpoint vout  {
	bins up = {0};
	bins dn = {1};
	}
	covlabel3: coverpoint cout {
	bins up = {0};
	bins dn = {1};
	}
endgroup: outputs
function new(string name, uvm_component parent);
    super.new(name,parent);
    /* TODO: Uncomment
    */ outputs=new;
    
endfunction: new

function void write(alu_transaction_out t);
    out={t.OUT};
    cout={t.COUT};
    vout={t.VOUT};
    /*TODO: Uncomment
    */ outputs.sample();
    
endfunction: write
endclass: alu_subscriber_out

endpackage: coverage
