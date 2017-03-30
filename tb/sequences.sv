`include "uvm_macros.svh"
package sequences;

    import uvm_pkg::*;

    class alu_transaction_in extends uvm_sequence_item;
        `uvm_object_utils(alu_transaction_in)

        rand logic [31:0] A;
        rand logic [31:0] B;
        rand logic [2:0] opcode;
        rand logic rst;
        rand logic CIN;

        //TODO: Add constraints here
	
	constraint opc{
	opcode inside{[0:7]};}
        
	constraint cin_1{	
	(opcode==3'b110)->(CIN==1'b1);
	}        

/*	constraint opci_0{
(opcode == 3'b110);}

	constraint rst_0{
	(rst==0);
	}*/
/*  						//Constraints tested to make the error report more accurate 
	constraint opci_0{
	(opcode == 3'b000);}
	
	constraint opci_7{
	(opcode == 3'b111);}
	
	constraint opci_7{
	(opcode == 3'b100);}
	
	constraint opci_7{
	(opcode == 3'b111);}
	
	constraint rst_0{
	(rst==0);
	}
	constraint rst_1{
	(rst==1);
	}
*/



        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={$sformatf("Operand A = %b, Operand B = %b, Opcode = %b, CIN = %b",A,B,opcode,CIN)};
        endfunction: convert2string

    endclass: alu_transaction_in


    class alu_transaction_out extends uvm_sequence_item;
        `uvm_object_utils(alu_transaction_out)

        logic [31:0] OUT;
        logic COUT;
        logic VOUT;

        function new(string name = "");
            super.new(name);
        endfunction: new;
        
        function string convert2string;
            convert2string={$sformatf("OUT = %b, COUT = %b, VOUT = %b",OUT,COUT,VOUT)};
        endfunction: convert2string

    endclass: alu_transaction_out

    class simple_seq extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        endtask: body
    endclass: simple_seq


    class seq_of_commands extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(seq_of_commands)
        `uvm_declare_p_sequencer(uvm_sequencer#(alu_transaction_in))

        function new (string name = "");
            super.new(name);
        endfunction: new

        task body;
            repeat(100)
            begin
                simple_seq seq;
                seq = simple_seq::type_id::create("seq");
                assert( seq.randomize() );
                seq.start(p_sequencer);
            end
        endtask: body

    endclass: seq_of_commands

endpackage: sequences
