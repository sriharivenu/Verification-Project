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

    extern virtual function [39:0] getresult; 
    extern virtual function void compare; 
    extern virtual function [39:0] add_sub (logic [31:0] in_a, logic [31:0] in_b, logic add, logic [1:0] rmode);
    extern virtual function [39:0] mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic [1:0] rmode);
    extern virtual function [39:0] int_flt (logic [31:0] in_a);    
    extern virtual function [39:0] flt_int (logic [31:0] in_a);
    extern virtual function [26:0] divide (logic [23:0] in_a, logic [23:0] in_b);
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


     logic [39:0]res;
         res=getresult;
    
    // General order of exception:
    // 1) Stack Overflow and Underflow
    // 2) SNaN operand
    // 3) Divide by zero
    // 4) Numeric overflow and underflow
    // 5) Inexact
    // 6) QNaN (divide by zero is QNaN and not divide by zero)
    
    // Order of the bits:
    // zero - 39
    // div by zero - 38,
    // underflow - 37
    // overflow - 36
    // ine - 35
    // inf - 34
    // qnan - 33,
    // snan - 32, 
    if(tx_out.snan != res[32]) begin
        `uvm_info("ERROR MSG-1", $sformatf("SNaN is wrong!!! SB snan: %b, DUT snan: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[32], tx_out.snan, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    if(tx_out.div_by_zero != res[38]) begin
        `uvm_info("ERROR MSG-2", $sformatf("Div by zero is wrong!!! SB DIV by zero: %b, DUT DIV by zero: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[38], tx_out.div_by_zero, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    if(tx_out.inf != res[34]) begin
        `uvm_info("ERROR MSG-3", $sformatf("Inf is wrong!!! SB Inf: %b, DUT Inf: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[34], tx_out.inf, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    //`uvm_info("OVERFLOW", $sformatf("DUT Overflow: %b, SB Overflow: %b", tx_out.overflow, res[36]), UVM_HIGH);
    if(tx_out.overflow != res[36]) begin
        `uvm_info("ERROR MSG-4", $sformatf("Overflow is wrong!!! SB overflow: %b, DUT overflow: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[36], tx_out.overflow, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    //`uvm_info("UNDERFLOW", $sformatf("DUT underflow: %b, SB underflow: %b", tx_out.underflow, res[37]), UVM_HIGH);
    if(tx_out.underflow != res[37]) begin
        `uvm_info("ERROR MSG-5", $sformatf("Underflow is wrong!!! SB underflow: %b, DUT underflow: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[37], tx_out.underflow, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    //`uvm_info("INE", $sformatf("DUT ine: %b, SB ine: %b", tx_out.ine, res[35]), UVM_HIGH);
    if(tx_out.ine != res[35]) begin
        `uvm_info("ERROR MSG-6", $sformatf("Inexact is wrong!!! SB ine: %b, DUT ine: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[35], tx_out.ine, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    if(tx_out.zero != res[39]) begin
        `uvm_info("ERROR MSG-7", $sformatf("Zero is wrong!!! SB zero: %b, DUT zero: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[39], tx_out.zero, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    if(tx_out.qnan != res[33]) begin
        `uvm_info("ERROR MSG-8", $sformatf("QNaN is wrong!!! SB QNaN: %b, DUT QNaN: %b, DUT out: %h, SB out: %h, In A: %h, In B: %h, opcode: %d", res[33], tx_out.qnan, tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.fpu_op) ,UVM_HIGH);
    end
    if((tx_out.out != res[31:0]) && !(tx_out.overflow) && !(tx_out.underflow) && !(tx_out.snan) && !(tx_out.qnan) && !(tx_out.div_by_zero) && !(tx_out.inf)) begin
        `uvm_info("ERROR MSG-9", $sformatf("OUT is wrong!!! DUT out: %h, SB out: %h, In A: %h, In B: %h, rmode: %d, snan: %b, qnan: %b, inf: %b, opcode: %d", tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.rmode, tx_out.snan, tx_out.qnan, tx_out.inf, tx_in.fpu_op) ,UVM_HIGH);
    end
    //`uvm_info("OUT", $sformatf("OUT!!! DUT out: %h, SB out: %h, In A: %h, In B: %h, rmode: %d", tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.rmode) ,UVM_HIGH);
    /*if(tx_out.out != res[31:0]) begin
        `uvm_info("ERROR MSG-9", $sformatf("OUT is wrong!!! DUT out: %h, SB out: %h, In A: %h, In B: %h, rmode: %d", tx_out.out, res[31:0], tx_in.opa, tx_in.opb, tx_in.rmode) ,UVM_HIGH);
    end
    */
endfunction

function [39:0] alu_scoreboard::getresult;
// This function returns a 46 bit answer, for the input and used to comapre the results of the DUT.
// The concatination of the output: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out}
    //alu_transaction_in tx;
    
    case(tx_in.fpu_op)
        3'b000: return add_sub(tx_in.opa, tx_in.opb, 0, tx_in.rmode); // For addition - 0
        3'b001: return add_sub(tx_in.opa, tx_in.opb, 1, tx_in.rmode); // For subtraction - 1
        3'b010: return mul_div(tx_in.opa, tx_in.opb, 0, tx_in.rmode); // For multiplication - 0
        3'b011: return mul_div(tx_in.opa, tx_in.opb, 1, tx_in.rmode); // For division - 0
        3'b100: return int_flt(tx_in.opa);                   // For int to float conversion
        3'b101: return flt_int(tx_in.opa);                       // For float to int
        default: return {40'b0};
    endcase
        // Need to write cases for other opcodes

return 40'b0;
endfunction


function [39:0] alu_scoreboard::flt_int(logic [31:0] in_a);
    logic [30:0] int_num;
    logic [7:0] exp_ans;
    logic [22:0] frac;
    logic sign;
    sign=in_a[31];
    exp_ans=in_a[30:23]-127;
    frac=in_a[22:0];
    while(exp_ans>8'd0)
        begin
            int_num=frac<<1;
            exp_ans=exp_ans-8'd1;
        end 
    return {sign,int_num,8'b0};
    //return {8'b0, sign, int_num};
endfunction


function [39:0] alu_scoreboard::int_flt(logic [31:0] in_a);
    // I am guessing that it only uses int_flt for in_a
    logic [22:0] frac_final;
    logic [7:0] exp_ans;
    logic sign_ans;
    //Assuming the MSB is a sign bit
    sign_ans = in_a[31];
    frac_final = 23'b0;
    exp_ans = 8'b0;
    in_a = in_a << 1;
    
    while(! in_a[31]) begin
        in_a = in_a << 1;
        exp_ans = exp_ans + 1;
    end
    // Getting the bit to left of the point "1.111" getting rid of the first 1 before point.
    in_a = in_a << 1;
    exp_ans = exp_ans + 1;
    frac_final = in_a[31:9];

    return {8'b0, sign_ans, exp_ans, frac_final}; 
endfunction

function [39:0] alu_scoreboard::add_sub(logic [31:0] in_a, logic [31:0] in_b, logic add, logic [1:0] rmode) ;
    
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
    logic ine, inf, qnan, snan;
    logic [31:0] out;
    logic expa_subnormal;
    logic expb_subnormal;
    logic [7:0] temp_exp_var;
    logic [22:0] temp_frac_var;
    logic temp_sign_var;
    logic altb_a, blta_a, aeqb_a;
    logic [28:0] fraction_b_sft;
    logic [4:0] exp_sft;
    logic [28:0] fraction_a_ext; // Extension of fraction A by 5 bits to help in rounding;
    logic [28:0] fraction_ans_un;// These _un are the answers that are unnormalized.
    logic sign_ans_un;
    logic [7:0] exp_ans_un;
    logic [1:0] carry_un;
    logic [7:0] exp_diff;
    logic [4:0] exp_sft_ans;
    logic sign_ans;
    logic ch;logic [4:0]count;
    logic [4:0] round_value;
    logic carry;
    logic [22:0] frac_final;
    logic Bfr_point;
    logic original_value_fraction_ans_un ;
    logic Inf_in;
    logic swap;
    logic [2:0] prec;
    logic gone_bits;
    logic [7:0] itrt;
    logic inp_zero;
    logic temp_vari;
    logic zero_b;

    inf = 1'd0;
    zero_a = 1'd0;
    zero_b = 1'd0;
    temp_vari = 1'b0;   
    inp_zero = 1'b0;
    itrt = 8'd0;
    gone_bits = 1'b0;
    prec = 3'd0;
    swap = 1'b0;
    // Inputs
    exp_a = in_a[30:23];
    sign_a = in_a[31];
    fraction_a = in_a[22:0];
    //`uvm_info("A",$sformatf("Sign of ans: %b", sign_a), UVM_HIGH);
    exp_b = in_b[30:23];
    sign_b = in_b[31];
    fraction_b = in_b[22:0];
    expb_subnormal=1'd1;
    expa_subnormal = 1'd1;
    if(exp_a == 8'b0)
        expa_subnormal = 1'b0;
    if(exp_b == 8'b0)
        expb_subnormal = 1'b0;


    inp_zero = ( (!(| exp_a) && !(| fraction_a)) || (!(| exp_b) && !(| fraction_b)) );
    
    blta_a = 1'b0;
    aeqb = 1'b0;
    // Now we are going to check which number is greater
    if(exp_a > exp_b) begin
        blta_a = 1'b0;
    end
    else if (exp_a < exp_b) begin
        blta_a = 1'b1;
    end
    else if (exp_a == exp_b) begin
        if(fraction_a > fraction_b) begin
            blta_a = 1'b0;
        end
        else if(fraction_a < fraction_b) begin
            blta_a = 1'b1;
        end
        else if( fraction_a == fraction_b) begin
            blta_a = 1'b0;
            aeqb = 1'b1;
        end
    end
 


    qnan= (&exp_a) && (&exp_b) && (sign_a!=sign_b);

    // Finding if it is SNAN
    //qnan = unordered;
    // Now for normalization

    //Bfr_point = !(expa_subnormal && expb_subnormal);  // This is the number present to the left side of the decimal point
    // It is 1 for normal numbers and 0 for subnormal numbers

    // This is for swapping the input if abs(B) is greater than abs(A).
    if(blta_a) begin
        temp_exp_var = exp_b;
        temp_frac_var = fraction_b;
        temp_sign_var = sign_b;
        exp_b = exp_a;
        sign_b = sign_a;
        fraction_b = fraction_a;
        exp_a = temp_exp_var;
        sign_a = temp_sign_var;
        fraction_a = temp_frac_var;
        temp_vari = expb_subnormal;
        expb_subnormal = expa_subnormal;
        expa_subnormal = temp_vari;
        swap = 1'b1;
    end
        // From now on abs(A) is greater or equal to abs(B).

    zero_a = (!(| exp_a) && !(| fraction_a));
    zero_b = (!(| exp_b) && !(| fraction_b));
    // This is the exponential difference between A and B, so now we need to shift B to match A.

    exp_diff = exp_a - exp_b;
    //`uvm_info("EXP A nd B result", $sformatf("expdiff = %d , exp a: %d, exp b: %d, inA: %h, inB: %h",exp_diff, exp_a, exp_b, in_a, in_b) ,UVM_HIGH);
    // The fraction bit is made 28 bits to help in rounding
    fraction_b_sft = 29'b0;
    fraction_b_sft = {expb_subnormal, fraction_b, 5'b0};

    exp_sft = ( exp_diff > 28) ? 5'd28: exp_diff[4:0];
    
    
    for(itrt = 8'd0; itrt < exp_sft; itrt = itrt + 1'b1) begin
        gone_bits = gone_bits || fraction_b_sft[itrt];
    end


    fraction_b_sft = fraction_b_sft >> exp_diff;
    if((exp_diff >= 8'd27) && !(!(| exp_b) && !(| fraction_b)) ) begin
        fraction_b_sft[0] = 1'b1;
    end 
    fraction_b_sft[0] = fraction_b_sft[0] || gone_bits;
    fraction_a_ext = 29'b0;
    //fraction_a_ext = {expa_subnormal,fraction_a, 5'b0};
    fraction_a_ext[28] = expa_subnormal;
    fraction_a_ext[27:5] = fraction_a;
    fraction_a_ext[4:0] = 5'b0;
    //`uvm_info("frac result", $sformatf("expa_sub: %b,fraca: %h",expa_subnormal, fraction_a), UVM_HIGH);

    // Now we have both input normalized and the output will have the power of input A.
    // Now lets check the sign bits and addition and subtraction.
    
    // Carry is made zero at start
    carry_un = 2'b0;
    fraction_ans_un = 29'b0;
    if(! add) begin
        // This is for adding two numbers
        if(sign_b == sign_a) begin
            sign_ans_un = sign_a;
            {carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft; // This is to make sure if there is any carry generated from addition of fraction.
            //carry_un = carry_un + 1'b1;
            exp_ans_un = exp_a;         
            if(carry_un) begin      
                fraction_ans_un = fraction_ans_un >> 1'd1;
                fraction_ans_un[28] = 1'b1;
                exp_ans_un = exp_a +1'd1;
            end
        //`uvm_info("print result", $sformatf("OUT!!!exp: %d, fraction_ans: %h", exp_ans_un,{1'd0, exp_ans_un, fraction_ans_un[28:5]}), UVM_HIGH); 
        //`uvm_info("print result", $sformatf("OUT!!!expdiff = %h A = %h B= %h SB out: %h",exp_diff, fraction_a_ext,fraction_b_sft,{sign_ans_un,exp_ans_un,fraction_ans_un[28:5]}) ,UVM_HIGH);
        end
        else if(sign_a) begin
            if(aeqb) begin
                sign_ans_un = 1'b0;
                fraction_ans_un = 29'b0;
                exp_ans_un = 8'b0;
            end
            else begin
                sign_ans_un = sign_a;
                fraction_ans_un = fraction_a_ext - fraction_b_sft;
                exp_ans_un = exp_a;
            end
        end
        else if(sign_b) begin
            sign_ans_un = sign_a;
            fraction_ans_un = fraction_a_ext - fraction_b_sft;
            exp_ans_un = exp_a;
        end
        //`uvm_info("print result", $sformatf("OUT is wrong!!!  SB out: %h", fraction_ans_un[28:5]) ,UVM_HIGH);
        // Taking care of Overflow, Assuming Overflow need not signal if one of the input is infinity as other exception 
        // Can underflow happen in Addition ?????????????? Not sure
        /*if(carry_un > 1'b0) begin
            if(exp_ans_un + 1'b1 >= 8'hff) begin
                overflow = 1'b1;
            end
        end*/
    end
    else begin
        if((sign_a == 1'b0) && (sign_b == 1'b0)) begin
            if(aeqb) begin
                sign_ans_un = 1'b0;
                fraction_ans_un = 29'b0;
                exp_ans_un = 8'b0;
            end
            else begin
                sign_ans_un = sign_a;
                if(swap) begin
                    sign_ans_un = (sign_a)? 1'b0:1'b1;
                end
                fraction_ans_un = fraction_a_ext - fraction_b_sft;
                exp_ans_un = exp_a;
            end
        end
        else if(sign_a && sign_b) begin
            if(aeqb) begin
                sign_ans_un = 1'b0;
                fraction_ans_un = 29'b0;
                exp_ans_un = 8'b0;
            end
            else begin
                sign_ans_un = 1'b1;
                if(swap) begin
                    sign_ans_un = (sign_a)? 1'b0:1'b1;
                end 
                fraction_ans_un = fraction_a_ext - fraction_b_sft;
                exp_ans_un = exp_a;
            end
        end
        else if(sign_a) begin
            
            sign_ans_un = 1'b1;
            if(swap) begin
                    sign_ans_un = (sign_a)? 1'b0:1'b1;
            end 
                
            //`uvm_info("A is neg",$sformatf("Sign of ans: %b", sign_ans_un), UVM_HIGH);            
            {carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft;
            //carry_un = carry_un + 1'b1;
            exp_ans_un = exp_a;
            if(carry_un) begin      
            fraction_ans_un = fraction_ans_un >> 1'd1;
            fraction_ans_un[28] = 1'b1;
            exp_ans_un = exp_a +1'd1;
            end
        end
        else if(sign_b) begin
            sign_ans_un = 1'b0;
            if(swap) begin
                    sign_ans_un = (sign_a)? 1'b0:1'b1;
            end 
                            
            {carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft;
            //carry_un = carry_un + 1'b1;
            exp_ans_un = exp_a;
            if(carry_un) begin      
            fraction_ans_un = fraction_ans_un >> 1'd1;
            fraction_ans_un[28] = 1'b1;
            exp_ans_un = exp_a +1'd1;
            end
        end
        // Can underflow happen in subtraction ????????  Not sure.
        // Taking care of Overflow, Assuming Overflow need not signal if one of the input is infinity as other exception 
        /*if(carry_un > 1'b1) begin
            if(exp_ans_un + 1'b1 >= 8'hff) begin
                overflow = 1'b1;
            end
        end*/
    end
    if(!add) begin
        if( ((& exp_a) && !(| fraction_a)) && ((& exp_b) && !(| fraction_b)) ) begin
            // If both are infinity
            //`uvm_info("INFI", $sformatf("Enterred!!!"), UVM_HIGH);
            if(sign_a != sign_b) begin
                fraction_ans_un=29'h18000000;
                exp_ans_un = 8'hfe;
            end
            else begin
                fraction_ans_un=29'h00000000;
                exp_ans_un = 8'hfe;
                inf = 1'd1;
            end
        end
        else if( (((& exp_a) && !(| fraction_a)) && !((& exp_b) && !(| fraction_b))) || (!((& exp_a) && !(| fraction_a)) && ((& exp_b) && !(| fraction_b)))) begin
                fraction_ans_un=29'h00000000;
                exp_ans_un = 8'hfe;
                inf  = 1'd1;
                if(((& exp_a) && (| fraction_a)) || ((& exp_b) && (| fraction_b)) ) begin
                    inf = 1'd0;
                end
            end                     
            
        if( ((& exp_a) && (| fraction_a)) || ((& exp_b) && (| fraction_b)) ) begin
            // If any one is NaN then answer is NaN
            //`uvm_info("NaN", $sformatf("NaN enterred!!!"), UVM_HIGH);
            fraction_ans_un = 29'h1f000000;
            exp_ans_un = 8'hff;
        end
    end
    else begin
        if( ((& exp_a) && !(| fraction_a)) && ((& exp_b) && !(| fraction_b)) ) begin
            if(sign_a == sign_b) begin
                fraction_ans_un=29'h30000000;
                exp_ans_un = 8'hff;
            end
            else begin
                fraction_ans_un=29'h00000000;
                exp_ans_un = 8'hfe;
                inf = 1'd1;
            end
        end
        else if( (((& exp_a) && !(| fraction_a)) && !((& exp_b) && !(| fraction_b))) || (!((& exp_a) && !(| fraction_a)) && ((& exp_b) && !(| fraction_b)))) begin
                fraction_ans_un=29'h00000000;
                exp_ans_un = 8'hfe;
                inf  = 1'd1;
            end
        if( ((& exp_a) && (| fraction_a)) || ((& exp_b) && (| fraction_b)) ) begin
            // If any one is NaN then answer is NaN
            fraction_ans_un = 29'h1f000000;
            exp_ans_un = 8'hff;
        end
    end
                    
    /*if(carry_un > 1'b1) begin// It can only have 10 as answer greater than 1, because we normalized it at start
        fraction_ans_un = fraction_ans_un >> 1;
        exp_ans_un = exp_ans_un + 1'b1;
    end*/

    //`uvm_info("print result", $sformatf("expdiff = %d FracA = %h FracB= %h fracA+/-fracB: %h",exp_diff, fraction_a_ext,fraction_b_sft,fraction_ans_un) ,UVM_HIGH);

    // Normalization the answer.

    count = 5'b0;
    ch=1'b0;
    while((ch==1'b0) && (! inp_zero) && !((! expa_subnormal) && (! expb_subnormal)) && !inf)
    begin
        
        {ch,fraction_ans_un}=fraction_ans_un << 1'b1;
        count=count+5'd1;
    end
    //`uvm_info("NOR", $sformatf("Value : %b, ch : %b", ((| exp_a) && (| fraction_a)) || ((| exp_b) && (| fraction_b)) , ch), UVM_HIGH);
    while ((ch == 1'b0) && ( (!(zero_a) && zero_b)) && expa_subnormal && !inf) begin
        //`uvm_info("NOR", $sformatf("Enterred!!!"), UVM_HIGH);
        {ch,fraction_ans_un}=fraction_ans_un << 1'b1;
        count=count+5'd1;
    end
    if((! inp_zero) && !((! expa_subnormal) && (! expb_subnormal)))
        exp_ans_un=exp_ans_un-count+1'b1;   
    if(((! expa_subnormal) && (! expb_subnormal)))
        fraction_ans_un = fraction_ans_un << 1'b1;
    
    //`uvm_info("After normalization", $sformatf(" fraction ans: %h, fraction_a: %h, exp ans: %d", fraction_ans_un, fraction_a_ext, exp_ans_un), UVM_HIGH);
      
    
    // Rounding method.

    if(fraction_ans_un[5:0]==6'd0)begin
    ine = 1'b0;
    end
    else
    begin
    ine = 1'b1;
    if(inf)
        ine = 1'b0; 
    end


    /*logic [4:0] round_value;
    logic carry;
    logic [22:0] frac_final;*/
    carry = 1'b0;
    frac_final = 23'b0;
    original_value_fraction_ans_un = fraction_ans_un;
    round_value = fraction_ans_un[4:0];


    prec = {fraction_ans_un[5], fraction_ans_un[4], ((| fraction_ans_un[3:0]))}; //|| gone_bits)};
    //`uvm_info("PREC", $sformatf("prec: %b, fraction_ans_un: %b", prec, fraction_ans_un[5:0]),UVM_HIGH);
    case(rmode)
        2'b00:  begin
                //Rounding to nearest even
                // Not sure what to round if it overflows.
                // I am thinking to round it of to highest value -1
                // If it is odd number then it is added with 1, if it is even it is added with 0
                // Example: -23.5 and -24.5 both will round to -24.
                //`uvm_info("before rounding", $sformatf("fraction_ans_un: %h",fraction_ans_un), UVM_HIGH);
                
                    if(fraction_ans_un[6]) begin// To check if it is ODD
                            // If it is odd check the last 6 bits, if they are greater than or equal to half
                            //if(fraction_ans_un[5:0] > 6'b011111) begin
                            if(prec > 3'b100) begin                         
                                {carry, fraction_ans_un} = fraction_ans_un + 7'b1000000;
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                //`uvm_info("In rounding", $sformatf("fraction_ans_un: %h and carry : %d",fraction_ans_un, carry), UVM_HIGH); 
                                fraction_ans_un = fraction_ans_un >>carry;
                                //`uvm_info("After shifting", $sformatf("fraction_ans_un: %h and carry : %d",fraction_ans_un, carry), UVM_HIGH);                                                            
                                frac_final=fraction_ans_un[28:6];
                            end
                            //else if(fraction_ans_un[5:0] < 6'b011111) begin
                            else if(prec <  3'b100) begin                       
                                frac_final = fraction_ans_un[28:6];
                            end
                            //else if(fraction_ans_un[5:0] == 6'b011111) begin
                            else if(prec == 3'b100) begin                           
                                {carry, fraction_ans_un} = fraction_ans_un + 7'b1000000;
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                fraction_ans_un = fraction_ans_un >> carry;
                                frac_final=fraction_ans_un[28:6];
                            end         
                    end
                    
                    else begin // Because roundin to nearest even needs it to get truncated.
                        //`uvm_info("After rounding even ", $sformatf("fraction_ans_un: %h", fraction_ans_un),  UVM_HIGH);                      
                        //if(fraction_ans_un[5:0] > 6'b011111) begin
                        if(prec > 3'b100) begin                         
                            {carry, fraction_ans_un} = fraction_ans_un + 7'b1000000;
                            exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                            fraction_ans_un = fraction_ans_un >> carry;
                            frac_final=fraction_ans_un[28:6];
                            //`uvm_info("After rounding even ", $sformatf("frac_final: %h, fraction_ans_un: %h", frac_final, fraction_ans_un), UVM_HIGH);
                        end
                        else begin
                            frac_final = fraction_ans_un[28:6];
                        end                         
                    end
                //`uvm_info("After rounding", $sformatf("frac_final: %h, fraction_ans_un: %h", frac_final, fraction_ans_un), UVM_HIGH);
                end
        2'b01:  begin
                // Rounding to zero is simply truncation
                    frac_final = {fraction_ans_un[28:6]};
                    //frac_final = frac_final - 23'd1;
                    //`uvm_info("After rounding to zero", $sformatf("frac_final: %h, fraction_ans_un: %h", frac_final, fraction_ans_un), UVM_HIGH);
            end
        2'b10:  begin
                // Rounding to +INF
                // Here it depends on the sign if it is -24.5 it is rounded of to -24, but if it is 24.5 it is rounded of to 25
                //`uvm_info("INF+", $sformatf("prec: %b", prec),UVM_HIGH);
                if(sign_ans_un) begin
                        frac_final = {fraction_ans_un[28:6]};
                end
                else begin
                        //if(fraction_ans_un[5:0]==6'd0)
                        if(prec == 3'b000)                      
                        begin
                            frac_final=fraction_ans_un[28:6];
                        //`uvm_info("INF all zero", $sformatf("Fails"),UVM_HIGH);
                        end
                        else
                        begin
                            
                        {carry, fraction_ans_un} = fraction_ans_un + 7'b1000000;
                        exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                            fraction_ans_un = fraction_ans_un >> carry;
                            frac_final=fraction_ans_un[28:6];
                        //`uvm_info("After rounding to +INF", $sformatf("frac_final: %h, fraction_ans_un: %h, INA: %h", frac_final, fraction_ans_un, in_a), UVM_HIGH);
                        end
                end
            end
        2'b11:  begin
                // Rounding to -INF
                // Here if it 24.5 it is rounded of to 24, but if it is -24.5 it is rounded of to -25
                if(sign_ans_un) begin
                    if(prec == 3'b000)
                    begin
                        frac_final=fraction_ans_un[28:6];
                        //`uvm_info("INF all zero", $sformatf("Fails"),UVM_HIGH);
                    end
                    else begin                      
                    {carry, fraction_ans_un} = fraction_ans_un + 7'b1000000;
                    exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                    fraction_ans_un = fraction_ans_un >> carry;
                    frac_final=fraction_ans_un[28:6];
                    end
                end
                else begin
                        frac_final = {fraction_ans_un[28:6]};
                end
            end
    endcase // rmode


    div_by_zero = 1'b0;
    qnan = ((&exp_ans_un) && (|frac_final)) && (frac_final[22]); 
    overflow = !inf &&  (&exp_ans_un) && !(| frac_final) ;
    zero = ( !(| exp_ans_un) && !(| fraction_ans_un[27:5])) ? 1'b1: 1'b0;
    //inf = Inf_in || inf; // Inf can happen in Add/SUb if any one of the input is INF.
    //Underflow -  Not sure about this !!!!!!!!!!!!!!!!!!!!!!!!!
    underflow = 1'b0;

    //SNAN - not sure, but if any input is NaN it is considered as SNAN
    snan = unordered;
    if(zero_b) begin
        // Then answer should be B if ADD
        if(! add) begin
            frac_final = fraction_a;
            exp_ans_un = exp_a;
            sign_ans = sign_a;
        end
        else begin
            frac_final = fraction_a;
            exp_ans_un = exp_a;
            sign_ans = sign_a;
            if(swap) 
                sign_ans = !sign_a;
        end
        ine = 1'd0;
    end


    // Sign doesn't change with normalization
    sign_ans = sign_ans_un;
    out = {sign_ans, exp_ans_un, frac_final};
    //`uvm_info("OUT answer", $sformatf("OUT is: %h", out), UVM_HIGH);
    return {zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out};
endfunction


function [26:0] alu_scoreboard:: divide (logic [23:0] in_a, logic [23:0] in_b);
    // Divide

    logic [23:0] a_m;
    logic [23:0] b_m;
    logic [23:0] z_m;
    logic guard, rb, sticky;
    logic [50:0] quotient, remainder, divisor, divident;
    logic [5:0] count;

    a_m = in_a;
    b_m = in_b;
    quotient = 51'd0;
    remainder = 51'd0;
    divisor = 51'd0;
    divident = 51'd0;
    count = 6'd0;   

    divident = a_m << 27;
    divisor = b_m;
    
    while(count <= 6'd49) begin
        quotient = quotient << 1;
        remainder = remainder << 1;
        remainder[0] = divident[50];
        divident = divident << 1;
        if(remainder >= divisor) begin
            quotient[0] = 1;
            remainder = remainder - divisor;
        end
        count = count + 5'd1;
    end
    z_m = quotient[26:3];
    guard = quotient[2];
    rb = quotient[1];
    sticky = (quotient[0] | (remainder != 51'd0));
    //`uvm_info("Sticky", $sformatf("Sticky: %b, remainder: %b, stk: %b",quotient[0], (| remainder), sticky) ,UVM_HIGH);
    return {quotient[26:3], guard, rb, sticky};
endfunction






function [39:0] alu_scoreboard:: mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic [1:0] rmode);
    logic [7:0] exp_a;
    logic [22:0] frac_a;
    logic sign_a;
    logic [7:0] exp_b;
    logic [22:0] frac_b;
    logic sign_b;
    logic sign_ans;
    logic [8:0] exp_ans_un;
    logic [47:0] frac_ans_un;
    logic [23:0] frac_ans_div;
    logic [23:0] multiplicand;
    logic [23:0] multiplier;
    logic [23:0] temp;
    logic [23:0] divisor;
    logic [23:0] divident;
    logic [47:0] quot;
    logic [47:0] remnd;
    logic [7:0] exp_a_n;
    logic [7:0] exp_b_n;
    logic a_sub;
    logic b_sub;
    logic more_one_sft;
    logic [5:0] cntr;
    logic [22:0] frac_final;
    logic neg_pos;
    logic alternate;
    logic [2:0] last_three;
    // Output needed to find
    
    logic zero_a, inf_in, aeqb, blta, altb, unordered;
    logic zero, div_by_zero, underflow, overflow;
    logic ine, inf, qnan, snan;
    logic [31:0] out;
    logic zero_b;
    logic ch;
    logic [4:0]count;
    logic carry;
    logic sign_ans_un;
    logic [5:0] itr;
    logic [2:0] prec;
    logic [26:0] quot_ans;
    real epa;
    real epb;
    integer jtr;
    real denorm;
    logic first;
    logic stk;
    logic inp_zero;
    logic infin;
    logic infa;
    logic infb;
    
    infa = 1'b0;
    infb = 1'b0;
    infin = 1'd0;
    inp_zero = 1'b0;
    stk = 1'b0;
    first = 1'd0;
    epa = 0.0;
    denorm = 0.0;
    epb = 0.0;
    jtr = 0;
    last_three = 3'd0;
    quot_ans = 27'd0;
    carry = 1'b0;
    prec = 3'd0;
    itr = 6'b0; 
    exp_a = in_a[30:23];
    sign_a = in_a[31];
    frac_a = in_a[22:0];
    exp_b = in_b[30:23];
    sign_b = in_b[31];
    frac_b = in_b[22:0];
    
    // sign bit

    sign_ans = (sign_b == sign_a)? 1'b0: 1'b1; 


    // Div by zero
    div_by_zero = (mul) ?(!(|(exp_b)) && !(|(frac_b)) ) : 1'b0;


    inp_zero = ( (!(| exp_a) && !(| frac_a)) || (!(| exp_b) && !(| frac_b)) );
    // If inp_ A is zero

    zero_a = !(| exp_a)&& !(| frac_a); 

    // If inp B is zero

    zero_b = !(| exp_b)&& !(| frac_b);
    //To calculate the proper exponent
    underflow = 1'b0;
    overflow = 1'b0;
    neg_pos = 1'b0;

    // No need to worry about shifting.
    // Now the fraction part
    frac_ans_un = 48'b0;
    // a * b , so we are going to a as multiplicand and b as multiplier
    a_sub = 1'b0;
    b_sub = 1'b0;
    a_sub = !(| exp_a);
    b_sub = !(| exp_b);
    count = 5'b0;
    multiplicand = {!a_sub, frac_a};
    multiplier = {!b_sub, frac_b};

    //`uvm_info("MULTI", $sformatf("Multiplier: %b, Multiplicand: %b", multiplier, multiplicand), UVM_HIGH);
    divident = {!a_sub,frac_a};
    divisor = {!b_sub, frac_b};
    exp_a_n = exp_a;
    exp_b_n = exp_b;

    quot = 48'b0;
    remnd = 48'b0;
    more_one_sft = 1'b0;
    cntr = 6'b0;
    alternate = 1'b0;
    if(mul) begin
        while(!divident[23] && ! inp_zero) begin
            //`uvm_info("DIVident",$sformatf("Divident entered"), UVM_HIGH);
            divident = divident << 1;
            exp_a = exp_a -1;
        end

        while(!divisor[23] && ! inp_zero && !b_sub) begin
            divisor = divisor << 1;
            exp_b = exp_b -1;
        end
    end


    
    exp_ans_un = (! mul)? ((exp_a)  + (exp_b) + 2'd2): (exp_a - exp_b);
    //`uvm_info("Exp", $sformatf("expans: %d",exp_ans_un) ,UVM_HIGH);

    //`uvm_info("EXP", $sformatf("EXP A: %b, EXP B: %b", exp_a, exp_b), UVM_HIGH);
    for(jtr = 7; jtr >= 0; jtr = jtr -1) begin
        epa = epa + (exp_a[jtr]*(2**(jtr)) );
    end
    
    for(jtr = 7; jtr >= 0; jtr = jtr -1) begin
        epb = epb + (exp_b[jtr]*(2**(jtr)) );
    end

    //`uvm_info("At start", $sformatf("expa: %f expb: %f, expa: %d, expb: %d",epa, epb, exp_a, exp_b) ,UVM_HIGH);
    if(! mul) begin
        if(((epa + epb) - 127) <= 0) begin // This is because any value less than -126 can't be expressed.
            //`uvm_info("UND", $sformatf("Enterred!!!"), UVM_HIGH);         
            underflow = 1'b1;      // exp_a + exp_b < -126, as both are informat of 0 to 255, so it is converted as -126+127+127=128    
            if(inp_zero)
                underflow = 1'b0;
        end
        if((epa + epb - 127) > 255) begin
            //`uvm_info("OVERfl", $sformatf("Exp: %d", (epa + epb - 127)), UVM_HIGH);
            overflow = 1'b1;
        end
    end
    else begin
        if((epa - epb + 127) <= 0) begin // This is because any value less than -126 can't be expressed.
            underflow = 1'b1;      // exp_a + exp_b < -126, as both are informat of 0 to 255, so it is converted as -126+127+127=128
            if(zero_a)
                underflow = 1'b0;   
        end
        if((epa - epb + 127) > 255) begin
            overflow = 1'b1;
        end
    end
    
    infin = ((& exp_a) && !(| frac_a)) || ((& exp_b) && !(| frac_b));
    infa = ((& exp_a) && !(| frac_a));
    infb = ((& exp_b) && !(| frac_b));
    //divident = divident << 27;

    //Multiplication
    if(!(underflow) || !(overflow)) begin 
    if(!mul) begin
        if( ((&exp_a) && (| frac_a)) || ((& exp_b) && (| frac_b)) ) begin
            // If any one is NaN
            frac_ans_un = 48'd1;
            exp_ans_un = 9'hff;
        end
        else if( (&exp_a) && (!(| frac_a)) ) begin
            // If A is INF
            frac_ans_un = 48'd0;
            exp_ans_un = 9'hff;
            if( !(| exp_b) && !(| frac_b)) begin
                //If B is zero
                frac_ans_un = 48'd1;
                exp_ans_un = 9'hff;
            end
            
        end
        else if( (& exp_b) && (!(| frac_b)) ) begin
            // If B is INF
            frac_ans_un = 48'd0;
            exp_ans_un = 9'hff;
        end
        else if( !(| exp_a) && !(| frac_a)) begin
            // If A is zero
            frac_ans_un = 48'd0;
            exp_ans_un = 9'd0;
        end
        else if( !(| exp_b) && !(| frac_b) ) begin
            // If B is zero
            frac_ans_un = 48'd0;
            exp_ans_un = 9'd0;
        end
        else begin  
            while (count < 24) begin
                temp = (multiplier[count])? multiplicand : 24'b0;
                frac_ans_un = frac_ans_un + (temp << count);
                count =  count + 1;
            end
        end 
    end
    else if((! div_by_zero) && mul ) begin // for division 
        // Long division method
        // quot is the final answer
        if( ((&exp_a) && (| frac_a)) || ((& exp_b) && (| frac_b)) ) begin
            // If any one is NaN
            quot = 48'b1;
            exp_ans_un = 9'hff;
        end
        else if( ((& exp_a) && !(| frac_a)) && ((& exp_b) && !(|frac_b)) ) begin
            // It both are infinity
            quot = 48'b1;
            exp_ans_un = 9'hff;
        end
        else if ((& exp_a) && !(| frac_a)) begin
            // If A is inf
            quot = 48'd0;
            exp_ans_un = 9'hff;
        end
        else if((& exp_b) && !(|frac_b)) begin
            // If B is inf
            quot = 48'b0;
            exp_ans_un = 9'h00;
        end
        else if( (!(| exp_b) && !(| frac_b)) && (!(& exp_a) && (| frac_a) )) begin
            // If B is zero and A is finite
            quot = 48'b0;
            exp_ans_un = 9'hff;
        end
        else begin


            quot_ans = divide(divident, divisor);
            quot = {quot_ans, 21'd0};
            last_three = quot_ans[2:0];
            stk = quot_ans[0];
            //`uvm_info("Last three", $sformatf("last three: %b",last_three) ,UVM_HIGH);
            
        end
    end
    else if(mul && div_by_zero) begin
        quot = 48'b0;
    end
    
    end
    //`uvm_info("print result", $sformatf("expans: %d frac_ans_un: %b, INA: %h, INB: %h",exp_ans_un,frac_ans_un, in_a, in_b) ,UVM_HIGH);


    count = 5'b0;
    // Normalization
    /*logic ch;
    logic [4:0]count;*/
    if(! mul) begin
        ch=1'b0;
        while(((ch==1'b0) && (itr < 48)) && (!a_sub && !b_sub))
        begin
            {ch,frac_ans_un}=frac_ans_un << 1'b1;
            count=count+5'd1;
            itr = itr + 1;
        end
        while(((ch==1'b0) && (itr < 48)) && ((a_sub && !b_sub) || (!a_sub && b_sub)))
        begin
            {ch,frac_ans_un}=frac_ans_un << 1'b1;
            count=count+5'd1;
            itr = itr + 1;
        end
        exp_ans_un = exp_ans_un - count;
        exp_ans_un = (exp_ans_un - 9'd127);
        //`uvm_info("EXP", $sformatf("Val: %d", exp_ans_un), UVM_HIGH);
        
        //`uvm_info("VAL", $sformatf("IT: %b",(!frac_ans_un[47]) && (exp_ans_un != 9'd0)&&(a_sub || b_sub)), UVM_HIGH); 
        while((!frac_ans_un[47]) && (exp_ans_un != 9'd0)&&(a_sub || b_sub)) begin
            // It is subnormal
            frac_ans_un = frac_ans_un << 1'b1;
            exp_ans_un = exp_ans_un - 9'd1;
        end 
        
    end
    else begin
        ch=1'b0;
        while((ch==1'b0) && (itr < 48))
        begin
            //`uvm_info("Disp-2", $sformatf("Got stuck!!!"), UVM_HIGH);
            {ch,quot}=quot << 1'b1;
            if( (((epa - epb + 127) <= 0) && ((epa - epb + 127) > -22))  && ! first) begin
                //`uvm_info("NOR", $sformatf(" Enterred!!!"), UVM_HIGH);
                ch = 1'd0;
                first = 1'd1;
            end
            count=count+5'd1;
            itr = itr + 1;
        end
        last_three = last_three << (count - 6'd1);
        last_three[0] = stk;
        //`uvm_info("Last three", $sformatf("last three: %b, stk: %b",last_three, quot_ans[0]) ,UVM_HIGH);
        exp_ans_un = exp_ans_un - count;
        exp_ans_un = (exp_ans_un + 9'd128);
    end
    //`uvm_info("After normalisation", $sformatf("expans: %d",exp_ans_un - 9'd127) ,UVM_HIGH);
    //`uvm_info("After normalisation", $sformatf("expans: %d frac_ans_un: %b, INA: %h, INB: %h",exp_ans_un,frac_ans_un, in_a, in_b) ,UVM_HIGH);

    // Checking for INF and zero based on the exponents
    //`uvm_info("After normalisation", $sformatf("expa: %f expb: %f, diff: %f",epa, epb, (epa - epb + 127)) ,UVM_HIGH);
    if(mul) begin
        // divide
        if( ((epa - epb) + 127) > 255) begin
            // Answer should be highest value

            // Check this!!!!!!!!!!!!!!!!!!!!!
            //`uvm_info("DIV", $sformatf("Enterred!!!"), UVM_HIGH);
            exp_ans_un = 9'hfe;
            quot = 48'hffffff000000;
            last_three = quot[27:25];
        end
        else if( (epa - epb + 127) <= -22) begin
            // Answer should be zero
            exp_ans_un = 9'd0;
            quot = 48'd0;
        end
        if( (epa - epb +127) <= 0) begin
            exp_ans_un = 9'd0;
        end
        if( ((epa - epb + 127) <= 0) && ((epa - epb + 127) > -22) ) begin
            denorm = (epa - epb + 127);
            quot = quot >>1;
            quot[47] = 1'd1;
            while(denorm <= 0) begin
                quot = quot >> 1;
                last_three = last_three >> 1;
                denorm = denorm + 1;
            end
        end
        denorm = (epa - epb + 127);
        if( (denorm <= 0) && (denorm > -22) ) begin
            last_three = quot[27:25];
        end 
        if(inp_zero && div_by_zero) begin
            exp_ans_un = 9'hff;
            quot= 48'h80000000;
        end
        if(!zero_a && div_by_zero) begin
            exp_ans_un = 9'hff;
            quot = 48'h0000000;
        end
        if(infin) begin
            exp_ans_un = 9'hff;
            frac_ans_un = 48'h800000000001;
        end
        if(!infa && infb) begin
            //`uvm_info("DIV", $sformatf("Enterred!!!!", ), UVM_HIGH);
            exp_ans_un = 9'd0;
            quot = 48'd0;
        end
        if(infa && infb) begin
            exp_ans_un = 9'hff;
            quot = 48'h800000000001;
        end
        
    end
    else begin
        // Multiply
        //`uvm_info("SUB", $sformatf(" Diff: %f", (epa)), UVM_HIGH);
        if( ((epa + epb) - 127) > 255) begin
            // Answer should be highest value 
            exp_ans_un = 9'hfe;
            frac_ans_un = 48'hffffff000000;
        end
        else if( (epa + epb - 127) <= -22) begin
            //`uvm_info("SUB", $sformatf("Enterred!!!"), UVM_HIGH);
            // Answer should be zero
            exp_ans_un = 9'd0;
            quot = 48'd0;
        end
        if(inp_zero) begin
            exp_ans_un = 9'd0;
            frac_ans_un = 48'd0;
        end
        if(infin) begin
            exp_ans_un = 9'hff;
            frac_ans_un = 48'd0;
        end
        if((infa && zero_b) || (infb && zero_a) ) begin
            //`uvm_info("Z and I", $sformatf("Enterred!!!"), UVM_HIGH);
            exp_ans_un = 9'hff;
            frac_ans_un = 48'hf00000000000;
            inf = 1'd0;
        end
    end

    



    //INE
    if(!mul) begin
        if((frac_ans_un[24:0]==25'd0) && (inp_zero)) begin
            ine = 1'b0;
        end
        else begin
            ine = 1'b1;
            if(infin) begin
                ine = 1'd0;
            end 
        end
    end
    else begin
        if((last_three==3'd0) && (! div_by_zero)) begin
            ine = 1'b0;
        end
        else begin
            ine = 1'b1;
            if(zero_a)
                ine = 1'd0;
            if(!zero_a && div_by_zero)
                ine = 1'd0;     
        end
    end
    // Rounding method

    // ONLY MUL FOR NOW
    prec = (! mul)? {frac_ans_un[24], frac_ans_un[23], (| frac_ans_un[22:0])}: last_three;

    case(rmode)
        2'b00:  begin
                //Rounding to nearest even
                // Not sure what to round if it overflows.
                // I am thinking to round it of to highest value -1
                // If it is odd number then it is added with 1, if it is even it is added with 0
                // Example: -23.5 and -24.5 both will round to -24.
                    if(!mul) begin  
                        if(frac_ans_un[25]) begin// To check if it is ODD
                            if( prec > 3'b100) begin
                                {carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                frac_ans_un = frac_ans_un >>carry;
                                frac_final=frac_ans_un[47:25];
                            end
                            else if( prec < 3'b100) begin
                                frac_final = frac_ans_un[47:25];
                            end
                            else if( prec == 3'b100) begin
                                {carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                frac_ans_un = frac_ans_un >>carry;
                                frac_final=frac_ans_un[47:25];
                            end
                        end
                        else begin // Because roundin to nearest even needs it to get truncated.
                            if( prec > 3'b100) begin
                                {carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                frac_ans_un = frac_ans_un >>carry;
                                frac_final=frac_ans_un[47:25];
                            end
                            else begin
                                frac_final = frac_ans_un[47:25];
                            end
                        end
                    end
                    else begin // division
                        if(quot[25]) begin// To check if it is ODD
                            if( prec > 3'b100) begin                            
                                {carry, quot} = quot + {22'd0,1'd1, 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                quot = quot >>carry;
                                frac_final=quot[47:25];
                            end
                            else if( prec < 3'b100) begin
                                frac_final = quot[47:25];
                            end
                            else if( prec == 3'b100) begin
                                //`uvm_info("RNE", $sformatf("Enterred!!!"), UVM_HIGH);
                                {carry, quot} = quot + {1'd1, 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                quot = quot >>carry;
                                //`uvm_info("RNE", $sformatf("Carry: %b, quot + 1: %h", carry, {quot + {22'd0,1'd1, 25'd0}}), UVM_HIGH);
                                frac_final=quot[47:25];
                            end
                        end
                        else begin // Because roundin to nearest even needs it to get truncated.
                            if( prec > 3'b100) begin
                                {carry, quot} = quot + {1'd1, 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                quot = quot >>carry;
                                frac_final=quot[47:25];
                            end
                            else begin
                                frac_final = quot[47:25];
                            end
                        end

                end
            end
        2'b01:  begin
                // Rounding to zero is simply truncation

                    frac_final = (mul)? quot[47:25]: frac_ans_un[47:25];
            end
        2'b10:  begin
                // Rounding to +INF
                // Here it depends on the sign if it is -24.5 it is rounded of to -24, but if it is 24.5 it is rounded of to 25
                if(sign_ans) begin
                        frac_final = (mul) ? quot[47:25] : frac_ans_un[47:25];
                end
                else begin
                        if(!mul) begin
                            if( prec == 3'b000) begin
                                frac_final = frac_ans_un[47:25];
                            end
                            else begin
                                {carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                frac_ans_un = frac_ans_un >>carry;
                                frac_final=frac_ans_un[47:25];
                            end
                        end
                        else begin
                            if( prec == 3'b000) begin
                                frac_final = quot[47:25];
                            end
                            else begin                          
                                {carry, quot} = quot + {1'd1, 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                quot = quot >>carry;
                                frac_final=quot[47:25];
                            end
                        end
                end
            end
        2'b11:  begin
                // Rounding to -INF
                // Here if it 24.5 it is rounded of to 24, but if it is -24.5 it is rounded of to -25
                
                    if(! mul) begin
                        if(sign_ans) begin
                            //`uvm_info("INF-", $sformatf("frac_ans: %h, prec: %b",frac_ans_un[47:25], prec), UVM_HIGH);
                            if( prec == 3'b000) begin
                                    frac_final = frac_ans_un[47:25];
                            end
                            else begin                      
                                {carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                frac_ans_un = frac_ans_un >>carry;
                                frac_final = frac_ans_un[47:25];
                            end
                        end
                        else begin
                            frac_final = frac_ans_un[47:25];
                        end                     
                    end
                    else begin
                        if(sign_ans) begin
                            //`uvm_info("INF-", $sformatf("prec: %b", prec), UVM_HIGH);
                            if( prec == 3'b000) begin
                                frac_final = quot[47:25];
                            end
                            else begin              
                                {carry, quot} = quot + {1'd1, 25'd0};
                                exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
                                quot = quot >>carry;
                                frac_final=quot[47:25];
                            end
                        end
                        else begin
                            frac_final = quot[47:25];
                        end
                    end 
                
            end
    endcase // rmode

    //Qnan

    qnan = ((& exp_ans_un[7:0]) && (|frac_final)) && frac_final[22];
    //`uvm_info("QNAN", $sformatf("QNAN: %b", qnan), UVM_HIGH);
    //snan
    snan = ((& exp_a) && (| frac_a))|| ((& exp_b) && (| frac_b)) && !frac_final[22];

    if(qnan)
        ine = 1'd0;
    // Inf

    //inf = ((& exp_a) && !(| frac_a)) || ((& exp_b) && !(| frac_b));
    inf = ((&exp_ans_un[7:0]) && !(| frac_final));
    if(inp_zero && div_by_zero) begin 
        inf = 1'b0;
    end
    if( zero_a && infb) begin
        inf = 1'd0;
    end
    if( (! zero_a) && div_by_zero && mul) begin
        inf = 1'b1;
    end
    if(!mul && infin) begin
        inf = 1'b1;
        if(zero_a || zero_b) begin
            inf = 1'd0;
        end
    end
    //`uvm_info("INF", $sformatf("inf: %b, !zero_a: %b, div_by_zero: %b", inf, !zero_a, div_by_zero), UVM_HIGH);
    // Overflow
    //`uvm_info("OVERFLOW", $sformatf("Overflow: %b", overflow), UVM_HIGH);
    overflow = ((& exp_ans_un[7:0]) && !(| frac_final)) || overflow;
    if(! zero_a && div_by_zero) begin
        overflow = 1'b0;
    end
    if( mul && zero_a && infb) begin
        overflow = 1'd0;
    end
    if(mul && infa && (!infb && !div_by_zero) ) begin
        overflow = 1'd0;
    end
    if(!mul && infin) begin
        overflow = 1'b0;
    end
    // Underflow

    if(! mul) begin
        // For multiplication
        if( !inp_zero) begin // If neither are zero
            underflow = ((!(| exp_ans_un[7:0]) && !(| frac_final))) || underflow;
        end
    
        else
        begin
            underflow = 1'b0 || underflow;
        end
    end
    
    else begin
        if(!div_by_zero) begin
            if(!(| exp_a) && !(| frac_a)) begin
                underflow = 1'b0 || underflow;
            end
            else begin
                underflow = (!(| exp_ans_un[7:0]) && !(| frac_final)) || underflow;
            end
        end
        if(infb) begin
            if(! infa) begin
                underflow = 1'd0;
            end
        end
    end 

    // Zero
    if(mul) begin // for division if B is INF and A is finite then the answer is zero.
        if( ((& exp_b) && !(| frac_b)) && ( !(& exp_a)) ) begin
            zero = 1'b1;
        end
    end
    if(zero_a && !div_by_zero && mul) begin
        frac_final = 23'd0;
        exp_ans_un = 9'd0;
    end

    
    zero = (!(| exp_ans_un[7:0]) && !(| frac_final)) || zero;
    /*if( ((exp_a - 8'd127) + (exp_b - 8'd127)) > 9'd127) begin
        inf = inf || 1'b1;
        exp_ans_un = 8'hff;
        frac_final = 23'd0;
    end*/

    if( ((& exp_a) && (| frac_a)) || ((& exp_b) && (| frac_b)) ) begin
        // When any either one is NaN
        frac_final = 23'h600000;
        exp_ans_un = 9'hff;
        div_by_zero = 1'd0;
        overflow = 1'd0;
        underflow = 1'd0;
        ine = 1'd0;
        inf = 1'd0;
        qnan = ((& exp_ans_un[7:0]) && (|frac_final)) && frac_final[22];
        snan = ((& exp_ans_un[7:0]) && (|frac_final)) && !frac_final[22];
        zero = 1'd0;
    end
    out = {sign_ans,exp_ans_un[7:0],frac_final};
    
    //`uvm_info("SIGN", $sformatf("sign ans: %b", sign_ans), UVM_HIGH);

return {zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out};
endfunction     



endpackage: scoreboard
