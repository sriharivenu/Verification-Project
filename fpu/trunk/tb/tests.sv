package tests;
`include "uvm_macros.svh"
import modules_pkg::*;
import uvm_pkg::*;
import sequences::*;
import scoreboard::*;

class test1 extends alu_test;
    `uvm_component_utils(test1)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands seq;
	seq = seq_of_commands::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test1

class test2 extends alu_test;
    `uvm_component_utils(test2)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_2 seq;
	seq = seq_of_commands_add_2::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test2

class test3 extends alu_test;
    `uvm_component_utils(test3)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_3 seq;
	seq = seq_of_commands_add_3::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test3

class test4 extends alu_test;
    `uvm_component_utils(test4)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_4 seq;
	seq = seq_of_commands_add_4::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test4

class test5 extends alu_test;
    `uvm_component_utils(test5)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_5 seq;
	seq = seq_of_commands_add_5::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test5

class test6 extends alu_test;
    `uvm_component_utils(test6)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_6 seq;
	seq = seq_of_commands_add_6::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test6

class test7 extends alu_test;
    `uvm_component_utils(test7)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_7 seq;
	seq = seq_of_commands_add_7::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test7

class test8 extends alu_test;
    `uvm_component_utils(test8)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_8 seq;
	seq = seq_of_commands_add_8::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test8

class test9 extends alu_test;
    `uvm_component_utils(test9)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_9 seq;
	seq = seq_of_commands_add_9::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test9


class test10 extends alu_test;
    `uvm_component_utils(test10)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_10 seq;
	seq = seq_of_commands_add_10::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test10


class test11 extends alu_test;
    `uvm_component_utils(test11)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_add_11 seq;
	seq = seq_of_commands_add_11::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test11

class test12 extends alu_test;
    `uvm_component_utils(test12)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_1 seq;
	seq = seq_of_commands_sub_1::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test12

class test13 extends alu_test;
    `uvm_component_utils(test13)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_2 seq;
	seq = seq_of_commands_sub_2::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test13

class test14 extends alu_test;
    `uvm_component_utils(test14)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_3 seq;
	seq = seq_of_commands_sub_3::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test14


class test15 extends alu_test;
    `uvm_component_utils(test15)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_4 seq;
	seq = seq_of_commands_sub_4::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test15


class test16 extends alu_test;
    `uvm_component_utils(test16)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_5 seq;
	seq = seq_of_commands_sub_5::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test16


class test17 extends alu_test;
    `uvm_component_utils(test17)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_6 seq;
	seq = seq_of_commands_sub_6::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test17


class test18 extends alu_test;
    `uvm_component_utils(test18)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_7 seq;
	seq = seq_of_commands_sub_7::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test18


class test19 extends alu_test;
    `uvm_component_utils(test19)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_8 seq;
	seq = seq_of_commands_sub_8::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test19


class test20 extends alu_test;
    `uvm_component_utils(test20)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_9 seq;
	seq = seq_of_commands_sub_9::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test20

class test21 extends alu_test;
    `uvm_component_utils(test21)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_10 seq;
	seq = seq_of_commands_sub_10::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test21


class test22 extends alu_test;
    `uvm_component_utils(test22)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_sub_11 seq;
	seq = seq_of_commands_sub_11::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test22


class test23 extends alu_test;
    `uvm_component_utils(test23)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_1 seq;
	seq = seq_of_commands_mul_1::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test23


class test24 extends alu_test;
    `uvm_component_utils(test24)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_2 seq;
	seq = seq_of_commands_mul_2::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test24


class test25 extends alu_test;
    `uvm_component_utils(test25)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_3 seq;
	seq = seq_of_commands_mul_3::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test25

class test26 extends alu_test;
    `uvm_component_utils(test26)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_4 seq;
	seq = seq_of_commands_mul_4::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test26


class test27 extends alu_test;
    `uvm_component_utils(test27)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_5 seq;
	seq = seq_of_commands_mul_5::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test27


class test28 extends alu_test;
    `uvm_component_utils(test28)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_6 seq;
	seq = seq_of_commands_mul_6::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test28


class test29 extends alu_test;
    `uvm_component_utils(test29)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_7 seq;
	seq = seq_of_commands_mul_7::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test29


class test30 extends alu_test;
    `uvm_component_utils(test30)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_8 seq;
	seq = seq_of_commands_mul_8::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test30


class test31 extends alu_test;
    `uvm_component_utils(test31)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_9 seq;
	seq = seq_of_commands_mul_9::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test31



class test32 extends alu_test;
    `uvm_component_utils(test32)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_10 seq;
	seq = seq_of_commands_mul_10::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test32


class test33 extends alu_test;
    `uvm_component_utils(test33)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_mul_11 seq;
	seq = seq_of_commands_mul_11::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test33


class test34 extends alu_test;
    `uvm_component_utils(test34)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_1 seq;
	seq = seq_of_commands_div_1::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test34


class test35 extends alu_test;
    `uvm_component_utils(test35)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_2 seq;
	seq = seq_of_commands_div_2::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test35


class test36 extends alu_test;
    `uvm_component_utils(test36)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_3 seq;
	seq = seq_of_commands_div_3::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test36


class test37 extends alu_test;
    `uvm_component_utils(test37)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_4 seq;
	seq = seq_of_commands_div_4::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test37


class test38 extends alu_test;
    `uvm_component_utils(test38)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_5 seq;
	seq = seq_of_commands_div_5::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test38


class test39 extends alu_test;
    `uvm_component_utils(test39)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_6 seq;
	seq = seq_of_commands_div_6::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test39


class test40 extends alu_test;
    `uvm_component_utils(test40)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_7 seq;
	seq = seq_of_commands_div_7::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test40


class test41 extends alu_test;
    `uvm_component_utils(test41)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_8 seq;
	seq = seq_of_commands_div_8::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test41


class test42 extends alu_test;
    `uvm_component_utils(test42)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_9 seq;
	seq = seq_of_commands_div_9::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test42


class test43 extends alu_test;
    `uvm_component_utils(test43)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_10 seq;
	seq = seq_of_commands_div_10::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test43


class test44 extends alu_test;
    `uvm_component_utils(test44)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_div_11 seq;
	seq = seq_of_commands_div_11::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start(alu_env_h.alu_agent_in_h.alu_sequencer_in_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test44



endpackage: tests