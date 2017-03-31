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
    extern virtual function [45:0] add_sub (logic [31:0] in_a, logic [31:0] in_b, logic add, logic rmode);
    extern virtual function [45:0] mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic rmode);
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
	
	// Output values needed
	logic zero_a, inf_in, aeqb, blta, unordered;
	logic zero, div_by_zero, underflow, overflow;
	logic ine, inf, qnan, snan, out;
	logic [31:0] out;

	case(tx.fpu_op)
		3'b000: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out} = add_sub(tx.opa, tx.opb, 0, tx.rmode); // For addition - 0
		3'b001: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out} = add_sub(tx.opa, tx.opb, 1, tx.rmode); // For subtraction - 1
		3'b010: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out} = mul_div(tx,opa, tx.opb, 0, tx.rmode); // For multiplication - 0
		3'b011: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out} = mul_div(tx.opa, tx.opb, 1, tx.rmode); // For division - 0
		

		// Need to write cases for other opcodes
return {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out};
endfunction

endpackage: scoreboard
