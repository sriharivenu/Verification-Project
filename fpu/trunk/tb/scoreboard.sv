`include "uvm_macros.svh"
package scoreboard; 
import uvm_pkg::*;
import sequences::*;

class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)

    uvm_analysis_export #(alu_transaction_in) sb_in;
    uvm_analysis_export #(alu_transaction_out) sb_out;

    uvm_tlm_analysis_fifo #(alu_transaction_in) fifo_in;
    uvm_tlm_analysis_fifo #(alu_transaction_out) fifo_out;

    alu_transaction_in tx_in;
    alu_transaction_out tx_out;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        tx_in=new("tx_in");
        tx_out=new("tx_out");
    endfunction: new

    function void build_phase(uvm_phase phase);
        sb_in=new("sb_in",this);
        sb_out=new("sb_out",this);
        fifo_in=new("fifo_in",this);
        fifo_out=new("fifo_out",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        sb_in.connect(fifo_in.analysis_export);
        sb_out.connect(fifo_out.analysis_export);
    endfunction: connect_phase

    task run();
        forever begin
            fifo_in.get(tx_in);
            fifo_out.get(tx_out);
            compare();
        end
    endtask: run

    extern virtual function [45:0] getresult; 
    extern virtual function void compare; 
    extern virtual function [45:0] add_sub (logic [31:0] in_a, logic [31:0] in_b, logic add, logic [1:0] rmode);
    extern virtual function [45:0] mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic [1:0] rmode);
    extern virtual function [45:0] int_flt ()    
endclass: alu_scoreboard

function void alu_scoreboard::compare;
    //TODO: Write this function to check whether the output of the DUT matches
    //the spec.
    //Use the getresult() function to get the spec output.
    //Consider using `uvm_info(ID,MSG,VERBOSITY) in this function to print the
    //results of the comparison.
    //You can use tx_in.convert2string() and tx_out.convert2string() for
    //debugging purposes
    //alu_transaction_out tx;

endfunction

function [45:0] alu_scoreboard::getresult;

// This function returns a 46 bit answer, for the input and used to comapre the results of the DUT.
// The concatination of the output: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out}
	alu_transaction_in tx;
	
	case(tx.fpu_op)
		3'b000: return add_sub(tx.opa, tx.opb, 0, tx.rmode); // For addition - 0
		3'b001: return add_sub(tx.opa, tx.opb, 1, tx.rmode); // For subtraction - 1
		3'b010: return mul_div(tx,opa, tx.opb, 0, tx.rmode); // For multiplication - 0
		3'b011: return mul_div(tx.opa, tx.opb, 1, tx.rmode); // For division - 0
		

		// Need to write cases for other opcodes


return 46'b0;
endfunction


function [45:0] alu_scoreboard::add_sub(logic [31:0] in_a, logic [31:0] in_b, logic add, logic [1:0] rmode) ;
	// First need to pre normalise the result and then proceed to addition or subtraction.
	logic [7:0] exp_a;
	logic sign_a;
	logic [22:0] fraction_a;
	logic [7:0] exp_b;
	logic sign_b;
	logic [22:0] fraction_b;

	// Output needed to find
	logic zero_a, inf_in, aeqb, blta, altb, unordered;
	logic zero, div_by_zero, underflow, overflow;
	logic ine, inf, qnan, snan, out;
	logic [31:0] out;

	// Inputs
	exp_a = in_a[30:23];
	sign_a = in_a[31];
	fraction_a = in_a[22:0];

	exp_b = in_b[30:23];
	sign_b = in_b[31];
	fraction_b = in_b[22:0];

	// Normalization of the input for proper addition/subtraction.
	logic exp_altb;
	logic expa_subnormal;
	logic expb_subnormal;
	
	
	// FCMP scoreboard answers.

	if(exp_a == 8'b0)
		expa_subnormal = 1'b1;
	if(exp_b == 8'b0)
		expb_subnormal = 1'b1;

	// Zero_a is high if input A is zero
	if(expb_subnormal && fraction_a == 23'b0)
		zero_a = 1'b1;
	else
		zero_a = 1'b0;
	// Inf_in is high if anyone of the input is infinity
	inf_in = ( ( (& exp_a) && !(| fraction_a)) || ( (& exp_b) && !(| fraction_b)) );
	
	// Finding the comparison between the inputs
	altb = exp_a > exp_b;
	blta = (altb)? 1'b0: (exp_a < exp_b)? 1: 0;
	if(!(altb) && !(blta))
	begin
		altb = (fraction_a > fraction_b)? 1:0;
		blta = (fraction_b > fraction_a)? 1:0;
		aeqb = (!(blta) && !(altb)) ? 1: 0;
	end

	// Unordered is high is any one of the input is NAN
	unordered = ( ((& exp_a) && (| fraction_a)) || ((& exp_b) && (| fraction_b)) ); 


	

endfunction
endpackage: scoreboard
