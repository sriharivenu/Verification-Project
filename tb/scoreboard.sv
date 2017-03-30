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

    extern virtual function [33:0] getresult; 
    extern virtual function void compare; 
        
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
	
	logic [33:0] res;
	res=getresult();
	if(tx_out.VOUT==res[33] && tx_out.OUT==res[31:0]&& tx_out.COUT==res[32])
	begin//`uvm_info("0",$sformatf("\nActual Input Values  \n RST =%b A =%b B =%b CIN =%b Opcode =%b\nActual Outputs \n COUT =%b VOUT =%b OUT =%b\nExpected Output \n COUT =%b VOUT =%b OUT =%b \n",tx_in.rst,tx_in.A,tx_in.B,tx_in.CIN,tx_in.opcode,tx_out.COUT, tx_out.VOUT, tx_out.OUT,res[32],res[33],res[31:0]) ,UVM_HIGH);
	end
	if(tx_out.VOUT!=res[33] || $isunknown(tx_out.VOUT))
         begin
	`uvm_info("1",$sformatf("\nActual Input Values  \n RST =%b A =%b B =%b CIN =%b Opcode =%b\nActual Outputs \n COUT =%b VOUT =%b OUT =%b\nExpected Output \n COUT =%b VOUT =%b OUT =%b \n",tx_in.rst,tx_in.A,tx_in.B,tx_in.CIN,tx_in.opcode,tx_out.COUT, tx_out.VOUT, tx_out.OUT,res[32],res[33],res[31:0]) ,UVM_HIGH);
	 end
	if(tx_out.COUT!=res[32] || $isunknown(tx_out.COUT))
         begin
	`uvm_info("2",$sformatf("\nActual Input Values  \n RST =%b A =%b B =%b CIN =%b Opcode =%b\nActual Outputs \n COUT =%b VOUT =%b OUT =%b\nExpected Output \n COUT =%b VOUT =%b OUT =%b \n",tx_in.rst,tx_in.A,tx_in.B,tx_in.CIN,tx_in.opcode,tx_out.COUT, tx_out.VOUT, tx_out.OUT,res[32],res[33],res[31:0]) ,UVM_HIGH);
	 end
	if(tx_out.OUT!=res[31:0] || $isunknown(res[31:0]))
         begin
	`uvm_info("3",$sformatf("\nActual Input Values  \n RST =%b A =%b B =%b CIN =%b Opcode =%b\nActual Outputs \n COUT =%b VOUT =%b OUT =%b\nExpected Output \n COUT =%b VOUT =%b OUT =%b \n",tx_in.rst,tx_in.A,tx_in.B,tx_in.CIN,tx_in.opcode,tx_out.COUT, tx_out.VOUT, tx_out.OUT,res[32],res[33],res[31:0]) ,UVM_HIGH);
	 end
endfunction

function [33:0] alu_scoreboard::getresult;
    //TODO: Remove the statement below
    //Modify this function to return a 34-bit result {VOUT, COUT,OUT[31:0]} which is
    //consistent with the given spec.
//    alu_transaction_in tx;

    logic [31:0] out;logic cout;logic vout;
     if(tx_in.rst)
	begin
	return 34'd0;
    	//cout=0;
	//vout=0;
	end
    else
     if(tx_in.opcode==3'b000)
	begin
	out= tx_in.A;
    	cout=0;
	vout=0;
	//`uvm_info("2",tx_out.convert2string(),UVM_HIGH);
	end
    else
	if(tx_in.opcode==3'b001)
	begin
	out= tx_in.A&tx_in.B;
	cout=0;
	vout=0;
	//`uvm_info("2",tx_out.convert2string(),UVM_HIGH);
	end
    else
	if(tx_in.opcode==3'b010)
	begin
	out= ~tx_in.A;
	cout=0;
	vout=0;
	end
    else
	if(tx_in.opcode==3'b011)
	begin
	out= tx_in.A|tx_in.B;
	cout=0;
	vout=0;
	//`uvm_info("2",tx_out.convert2string(),UVM_HIGH);
	end
    else
	if(tx_in.opcode==3'b100)
	begin	
	out= tx_in.A^tx_in.B;
	cout=0;
	vout=0;
	end    
    else
	if(tx_in.opcode==3'b101)
	begin
	{cout,out}= tx_in.A+tx_in.B+tx_in.CIN;
	//cout=(tx_in.A&tx_in.B)|(tx_in.A&tx_in.CIN)|(tx_in.B&tx_in.CIN);		
	if(tx_in.A[31]==tx_in.B[31] && tx_in.A[31]!=out[31])
	begin	
	vout=1;
	//`uvm_info("4",tx_in.convert2string(),UVM_HIGH);
	//`uvm_info("4",$sformatf("out = %b",out[31:0]),UVM_HIGH);
	end
	else
	begin
	vout=0;
	end
	end    
    else
	if(tx_in.opcode==3'b110)
	begin
		logic [31:0] B;
		B=~tx_in.B+1;
		//cout=(tx_in.A&B)|(tx_in.A&tx_in.CIN)|(B&tx_in.CIN);		
		{cout,out}= tx_in.A+B;
		if(tx_in.A[31]!=tx_in.B[31] && tx_in.A[31]!=out[31])
		begin	
		vout=1;
		end
		else
		begin
		vout=0;
		end
	end   
    else	
    	begin
	return 34'd0;
	end
return {vout,cout,out};
endfunction

endpackage: scoreboard
