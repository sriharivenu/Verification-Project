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
    
    //constraint opcode_constraint{fpu_op inside{[0:7]};}
        constraint rmode_constraint {rmode inside {[0:3]};}
    //constraint rmode_constraint {rmode inside {0};}
    // Two zeros
    constraint input_A_z { opa inside {32'h00000000};}
    constraint input_B_z { opb inside {32'h00000000};}
    
    // Two subnormals        
    constraint input_A_s { opa inside {[32'h0000001 : 32'h000fffff]};}
    constraint input_B_s { opb inside {[32'h0000001 : 32'h000fffff]};}
        
    // Cross between zero, subnormal and normal
    constraint input_A_c { opa inside {32'h00000000, 32'h1003f0ff, 32'h43565c29}; }
    constraint input_B_c { opb inside {32'h00000000, 32'h0000dcab, 32'h488de0eb}; }
    
    // Infinity numbers
    constraint input_A_if { opa inside {32'h7f800000}; }
    constraint input_B_if { opb inside {32'hff800000}; }

    // When numbers are NaN
    constraint input_A_N { opa inside {32'h7fffffff}; }
    constraint input_B_N { opb inside {32'hffff0000}; }
    
    // crossing zero subs and inf
    constraint input_A_c1 { opa inside {32'h00000000, [32'h10000001: 32'h100fffff],32'h7f800000, 32'hff800000}; }
    constraint input_B_c1 { opb inside {32'h00000000, [32'h00000001: 32'h000fffff],32'hff800000, 32'h7f800000}; }
    //constraint input_A_c1 { opa inside {32'h00000000, 32'h1003f0ff,32'h7f800000, 32'hff800000}; }
    //constraint input_B_c1 { opb inside {32'h00000000, 32'h0000dcab,32'hff800000, 32'h7f800000}; }
    
    // crossing subs infs and nans
    
    constraint input_A_c2 { opa inside {[32'h10000001: 32'h1000000f], 32'h7f800000, 32'hff800000, 32'hffff0000}; }
    constraint input_B_c2 { opb inside {[32'h00000001: 32'h000000ff], 32'hff800000, 32'h7f800000, 32'hffff0000}; }

    //constraint input_A_c2 { opa inside {32'h1003f0ff, 32'h7f800000, 32'hff800000, 32'hffff0000}; }
    //constraint input_B_c2 { opb inside {32'h0000dcab, 32'hff800000, 32'h7f800000, 32'hffff0000}; }    
    
    // crossing zero infs and NaNs
    constraint input_A_c3 { opa inside {32'h00000000, 32'h7f800000, 32'hff800000, 32'hffff0000}; }
    constraint input_B_c3 { opb inside {32'h00000000, 32'hff800000, 32'h7f800000, 32'hffff0000}; }
    
    // crossing Normal infs NaNs

    constraint input_A_c4 { opa inside {[32'h4f800000: 32'h7f7fffff], 32'h7f800000, 32'hff800000, 32'hffff0000}; }
    constraint input_B_c4 { opb inside {[32'h4f800000: 32'h7f7fffff], 32'hff800000, 32'h7f800000, 32'hffff0000}; }


    //constraint input_A_c4 { opa inside {32'h43565c29, 32'h7f800000, 32'hff800000, 32'hffff0000}; }
    //constraint input_B_c4 { opb inside {32'h488de0eb, 32'hff800000, 32'h7f800000, 32'hffff0000}; }

    // Cross everything
    constraint input_A_cc { opa inside {32'h00000000, [32'h10000001: 32'h100fffff], [32'h00800000: 32'h7f7fffff], 32'h7f800000, 32'hffff0000}; }
    constraint input_B_cc { opb inside {32'h00000000, [32'h00000001: 32'h000fffff], [32'h00800000: 32'h7f7fffff], 32'hff800000, 32'hffff0000}; }

    //constraint input_A_cc { opa inside {32'h00000000, 32'h1003f0ff, 32'h43565c29, 32'h7f800000, 32'hffff0000}; }
    //constraint input_B_cc { opb inside {32'h00000000, 32'h0000dcab, 32'h488de0eb, 32'hff800000, 32'hffff0000}; }

    // To cover every region
    constraint input_A_ce1 { opa inside {[32'h80000001: 32'hffffffff]}; }
    constraint input_B_ce1 { opb inside {[32'h80000001: 32'hffffffff]}; }
    
    constraint input_A_ce2 { opa inside {[32'h4f800001: 32'h4fb80000]}; }
    constraint input_B_ce2 { opb inside {[32'h4f800001: 32'h4fb80000]}; }

    constraint input_A_ce3 { opa inside {[32'h4fb80001: 32'h50000039]}; }
    constraint input_B_ce3 { opb inside {[32'h4fb80001: 32'h50000039]}; }
    

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
        tx.input_A_z.constraint_mode(0);
        tx.input_B_z.constraint_mode(0);
        tx.input_A_s.constraint_mode(0);
        tx.input_B_s.constraint_mode(0);
        tx.input_A_c.constraint_mode(0);
        tx.input_B_c.constraint_mode(0);
        tx.input_A_if.constraint_mode(0);
        tx.input_B_if.constraint_mode(0);
        tx.input_A_N.constraint_mode(0);
        tx.input_B_N.constraint_mode(0);
        tx.input_A_cc.constraint_mode(1);
        tx.input_B_cc.constraint_mode(1);
        tx.input_A_c1.constraint_mode(0);
        tx.input_B_c1.constraint_mode(0);
        tx.input_A_c2.constraint_mode(0);
        tx.input_B_c2.constraint_mode(0);
        tx.input_A_c3.constraint_mode(0);
        tx.input_B_c3.constraint_mode(0);
        tx.input_A_c4.constraint_mode(0);
        tx.input_B_c4.constraint_mode(0);
        tx.input_A_ce1.constraint_mode(0);
        tx.input_B_ce1.constraint_mode(0);
            tx.input_A_ce2.constraint_mode(0);
        tx.input_B_ce2.constraint_mode(0);
            tx.input_A_ce3.constraint_mode(0);
        tx.input_B_ce3.constraint_mode(0);
            tx.opcode_0.constraint_mode(1);
            tx.opcode_1.constraint_mode(0);
            tx.opcode_2.constraint_mode(0);
            tx.opcode_3.constraint_mode(0);
            tx.opcode_4.constraint_mode(0);
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