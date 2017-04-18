`include "uvm_macros.svh"
package sequences;

    import uvm_pkg::*;

    class alu_transaction_in extends uvm_sequence_item;
        `uvm_object_utils(alu_transaction_in)

        rand logic [31:0] opa;
        rand logic [31:0] opb;
        rand logic [2:0] fpu_op;
        rand logic [1:0] rmode;

        //TODO: Add constraints here
	
	    constraint opcode_constraint{fpu_op inside{[0:7]};}
        constraint rmode_constraint {rmode inside {[0:3]};}

	constraint op_a { (opa == 32'h5);}
	//constraint op_b { (opb == 32'd1073741824);}
	 
        constraint opcode_0 { fpu_op inside {0}; }
        constraint opcode_1 { fpu_op inside {1}; }
        constraint opcode_2 { fpu_op inside {2}; }  
        constraint opcode_3 { fpu_op inside {3}; }
        constraint opcode_4 { fpu_op inside {4}; }
        constraint opcode_5 { fpu_op inside {5}; }
        constraint opcode_6 { fpu_op inside {6}; }
        constraint opcode_7 { fpu_op inside {7}; }

        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={$sformatf("Operand A = %b, Operand B = %b, Opcode = %b, RMODE = %b",opa,opb,fpu_op,rmode)};
        endfunction: convert2string

    endclass: alu_transaction_in


    class alu_transaction_out extends uvm_sequence_item;
        `uvm_object_utils(alu_transaction_out)

        logic [31:0] out;
        logic inf,snan,qnan;
        logic ine;
	    logic overflow,underflow;
	    logic zero;
	    logic div_by_zero;
        //logic unordered;
        //logic altb, blta, aeqb;
       // logic inf_in, zero_a;
        
        function new(string name = "");
            super.new(name);
        endfunction: new;
        
        function string convert2string;
            convert2string={$sformatf("Output = %b Snan = %b Qnan = %b Inf = %b Ine = %b Overflow = %b Underflow = %b Div By Zero = %b Zero = %b",out,snan,qnan,inf,ine,overflow,underflow,div_by_zero,zero)};
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
            tx.opcode_0.constraint_mode(0);
            tx.opcode_1.constraint_mode(0);
            tx.opcode_2.constraint_mode(0);
            tx.opcode_3.constraint_mode(0);
            tx.opcode_4.constraint_mode(1);
            tx.opcode_5.constraint_mode(0);
            tx.opcode_6.constraint_mode(0);
            tx.opcode_7.constraint_mode(0);
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
