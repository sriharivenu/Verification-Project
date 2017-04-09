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
	
	if(tx_out.out!=res[31:0])
	begin
	`uvm_info("0","OUT is wrong" ,UVM_HIGH);
	end
	if(tx_out.zero==res[39])
	begin
	`uvm_info("1","zero is wrong" ,UVM_HIGH);
	end
	if(tx_out.div_by_zero==res[38])
	begin
	`uvm_info("2","div by zero is wrong" ,UVM_HIGH);
	end	
	if(tx_out.underflow==res[37])
	begin
	`uvm_info("3","underflow is wrong" ,UVM_HIGH);
	end	
	if(tx_out.overflow==res[36])
	begin
	`uvm_info("4","overflow is wrong" ,UVM_HIGH);
	end	
	if(tx_out.ine==res[35])
	begin
	`uvm_info("5","ine is wrong" ,UVM_HIGH);
	end	
	if(tx_out.inf==res[34])
	begin
	`uvm_info("6","inf is wrong" ,UVM_HIGH);
	end	
	if(tx_out.qnan==res[34])
	begin
	`uvm_info("7","qnan is wrong" ,UVM_HIGH);
	end	
	if(tx_out.snan==res[33])
	begin
	`uvm_info("8","snan is wrong" ,UVM_HIGH);
	end	
	

endfunction

function [39:0] alu_scoreboard::getresult;
// This function returns a 46 bit answer, for the input and used to comapre the results of the DUT.
// The concatination of the output: {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out}
	alu_transaction_in tx;
	
	case(tx.fpu_op)
		3'b000: return add_sub(tx.opa, tx.opb, 0, tx.rmode); // For addition - 0
		3'b001: return add_sub(tx.opa, tx.opb, 1, tx.rmode); // For subtraction - 1
		3'b010: return mul_div(tx,opa, tx.opb, 0, tx.rmode); // For multiplication - 0
		3'b011: return mul_div(tx.opa, tx.opb, 1, tx.rmode); // For division - 0
		3'b100: return int_flt(tx.opa); 					 // For int to float conversion
		3'b101: return flt_int(tx.opa);						 // For float to int
		default: return {40'b0};
	endcase
		// Need to write cases for other opcodes

return 40'b0;
endfunction

// Not sure how the float to integer works





// endfunction




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
	logic [7:0] exp_diff;
	logic expa_subnormal;
	logic expb_subnormal;
	logic [7:0] temp_exp_var;
	logic [22:0] temp_frac_var;
	logic temp_sign_var;
	logic altb_a, blta_a, aeqb_a;
	logic [27:0] fraction_b_sft;
	logic [4:0] exp_sft;
	logic [27:0] fraction_a_ext; // Extension of fraction A by 5 bits to help in rounding;
	logic [27:0] fraction_ans_un;// These _un are the answers that are unnormalized.
	logic sign_ans_un;
	logic [7:0] exp_ans_un;
	logic [1:0] carry_un;

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
	// Inf_in is high if anyone of the input is infinity, it is absolute value
	inf_in = ( ( (& exp_a) && !(| fraction_a)) || ( (& exp_b) && !(| fraction_b)) );
	
	// Finding the comparison between the input's absolute values
	altb_a = exp_a > exp_b;
	blta_a = (altb_a)? 1'b0: (exp_a < exp_b)? 1: 0;
	if(!(altb_a) && !(blta_a))
	begin
		altb_a = (fraction_a > fraction_b)? 1:0;
		blta_a = (fraction_b > fraction_a)? 1:0;
		aeqb_a = (!(blta_a) && !(altb_a)) ? 1: 0;
	end

	// Final comparison based on sign bit
	// if both are 1, the lesser the absolute value the higher the number
	if(sign_a && sign_b) begin
		altb = blta_a;
		blta = altb_a;
		aeqb = aeqb_a;
	end
	else if(!(sign_a && sign_b) ) begin 	// If both are 0, then normal comparison
		altb = altb_a;
		blta = blta_a;
		aeqb = aeqb_a;
	end
	else if(sign_a) begin					// If only A is negative
		blta = 1'b1;
		altb = 1'b0;
		aeqb = 1'b0;
	end
	else if(sign_b) begin					// If only B is negative
		blta = 1'b0;
		altb = 1'b1;
		aeqb = 1'b0;
	end

	// Unordered is high is any one of the input is NAN
	unordered = ( ((& exp_a) && (| fraction_a)) || ((& exp_b) && (| fraction_b)) ); 
	
	qnan= (&exp_a) && (&exp_b) && (sign_a!=sign_b);



	// Finding if it is SNAN
	//qnan = unordered;
	// Now for normalization

	Bfr_point = !(expa_subnormal && expb_subnormal);  // This is the number present to the left side of the decimal point
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
	end
		// From now on abs(A) is greater or equal to abs(B).
	// This is the exponential difference between A and B, so now we need to shift B to match A.
	exp_diff = exp_a - exp_b;
	// The fraction bit is made 28 bits to help in rounding
	fraction_b_sft = {!(expb_subnormal), fraction_b, 4'b0};
	exp_sft = ( exp_diff > 28) ? 5'd28: exp_diff[4:0];
	fraction_b_sft = fraction_b_sft >> exp_sft;
	fraction_a_ext = {fraction_a, 5'b0};

	// Now we have both input normalized and the output will have the power of input A.
	// Now lets check the sign bits and addition and subtraction.
	
	// Carry is made zero at start
	carry_un = 2'b0;

	if(! add) begin
		// This is for adding two numbers
		if(sign_b == sign_a) begin
			sign_ans_un = sign_a;
			{carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft; // This is to make sure if there is any carry generated from addition of fraction.
			carry_un = carry_un + 1'b1;
			exp_ans_un = exp_a;
		end
		else if(sign_a) begin
			if(aeqb) begin
				sign_ans_un = 1'b0;
				fraction_ans_un = 28'b0;
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
		// Taking care of Overflow, Assuming Overflow need not signal if one of the input is infinity as other exception 
		// Can underflow happen in Addition ?????????????? Not sure
		if(carry_un > 1'b1) begin
			if(exp_ans_un + 1'b1 >= 8'hff) begin
				overflow = 1'b1;
			end
		end
	end
	else begin
		if((sign_a == 1'b0) && (sign_b == 1'b0)) begin
			if(aeqb) begin
				sign_ans_un = 1'b0;
				fraction_ans_un = 28'b0;
				exp_ans_un = 8'b0;
			end
			else begin
				sign_ans_un = sign_a;
				fraction_ans_un = fraction_a_ext - fraction_b_sft;
				exp_ans_un = exp_a;
			end
		end
		else if(sign_a && sign_b) begin
			if(aeqb) begin
				sign_ans_un = 1'b0;
				fraction_ans_un = 28'b0;
				exp_ans_un = 8'b0;
			end
			else begin
				sign_ans_un = 1'b1;
				fraction_ans_un = fraction_a_ext - fraction_b_sft;
				exp_ans_un = exp_a;
			end
		end
		else if(sign_a) begin
			sign_ans_un = 1'b1;
			{carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft;
			carry_un = carry_un + 1'b1;
			exp_ans_un = exp_a;
		end
		else if(sign_b) begin
			sign_ans_un = 1'b0;
			{carry_un, fraction_ans_un} = fraction_a_ext + fraction_b_sft;
			carry_un = carry_un + 1'b1;
			exp_ans_un = exp_a;
		end
		// Can underflow happen in subtraction ????????  Not sure.
		// Taking care of Overflow, Assuming Overflow need not signal if one of the input is infinity as other exception 
		if(carry_un > 1'b1) begin
			if(exp_ans_un + 1'b1 >= 8'hff) begin
				overflow = 1'b1;
			end
		end
	end

	if(carry_un > 1'b1) begin// It can only have 10 as answer greater than 1, because we normalized it at start
		fraction_ans_un = fraction_ans_un >> 1;
		exp_ans_un = exp_ans_un + 1'b1;
	end

	// Normalization the answer.
	logic [4:0] exp_sft_ans;
	logic sign_ans;
	logic ch;logic [4:0]count;
	ch=1'b0;
	while(ch==1'b0)
	begin
		{ch,fraction_ans_un}=fraction_ans_un << 1'b1;
		count=count+5'd1;
	end
	exp_ans_un=exp_ans_un-count;	
	
	  

	// Rounding method.

	if(fraction_ans_un[4:0]==5'd0)begin
	ine = 1'b0;
	end
	else
	begin
	ine = 1'b1;	
	end


	logic [4:0] round_value;
	logic carry;
	logic [22:0] frac_final;

	original_value_fraction_ans_un = fraction_ans_un;
	round_value = fraction_ans_un[4:0];
	case(rmode)
		2'b00:	begin
				//Rounding to nearest even
				// Not sure what to round if it overflows.
				// I am thinking to round it of to highest value -1
				// If it is odd number then it is added with 1, if it is even it is added with 0
				// Example: -23.5 and -24.5 both will round to -24.
					if(fraction_ans_un[5]) begin// To check if it is ODD
							{carry, fraction_ans_un} = fraction_ans_un + 6'b100000;
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							fraction_ans_un = fraction_ans_un[27:1]>>carry;
							frac_final=fraction_ans_un[27:5];
						end
					
					else begin // Because roundin to nearest even needs it to get truncated.
						frac_final = fraction_ans_un[27:5];
					end
				end
		2'b01:	begin
				// Rounding to zero is simply truncation
					frac_final = {fraction_ans_un[27:5]};
			end
		2'b10:	begin
				// Rounding to +INF
				// Here it depends on the sign if it is -24.5 it is rounded of to -24, but if it is 24.5 it is rounded of to 25
				if(sign_ans_un) begin
						frac_final = {fraction_ans_un[27:5]};
				end
				else begin
						if(fraction_ans_un[4:0]==5'd0)
						begin
							frac_final=fraction_ans_un[27:5];
						end
						else
						begin
							
						{carry, fraction_ans_un} = fraction_ans_un + 6'b100000;
						exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							fraction_ans_un = fraction_ans_un[27:1]>>carry;
							frac_final=fraction_ans_un[27:5];
						end
				end
			end
		2'b11:	begin
				// Rounding to -INF
				// Here if it 24.5 it is rounded of to 24, but if it is -24.5 it is rounded of to -25
				if(sign_ans_un) begin
					{carry, fraction_ans_un} = fraction_ans_un + 6'b100000;
					exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
					fraction_ans_un = fraction_ans_un[27:1]>>carry;
					frac_final=fraction_ans_un[27:5];
					end
				else begin
						frac_final = {fraction_ans_un[27:5]};
				end
			end
	endcase // rmode


	div_by_zero = 1'b0;
	qnan = ((&exp_ans_un) && (|frac_final))|| qnan; 
	overflow = !qnan &&  (&exp_ans_un) ;
	zero = ( !(| exp_ans_un) && !(| fraction_ans_un[27:5])) ? 1'b1: 1'b0;
	inf = Inf_in; // Inf can happen in Add/SUb if any one of the input is INF.
	//Underflow -  Not sure about this !!!!!!!!!!!!!!!!!!!!!!!!!
	underflow = 1'b0;

	//SNAN - not sure, but if any input is NaN it is considered as SNAN
	snan = unordered;


	// Sign doesn't change with normalization
	sign_ans = sign_ans_un;
	out = {sign_ans, exp_ans_un, frac_final};
	return {zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out};
endfunction

function [45:0] mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic [1:0] rmode);
	
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
	integer count;
	logic a_sub;
	logic b_sub;

	logic more_one_sft;
	logic [5:0] cntr;

	// Output needed to find
	logic zero_a, inf_in, aeqb, blta, altb, unordered;
	logic zero, div_by_zero, underflow, overflow;
	logic ine, inf, qnan, snan, out;
	logic [31:0] out;
	logic zero_a;
	logic zero_b;

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

	// If inp_ A is zero

	zero_a = !(| exp_a)&& !(| frac_a); 

	// If inp B is zero

	zero_b = !(| exp_b)&& !(| frac_b);
	//To calculate the proper exponent
	exp_ans_un = (! mul)? (exp_a + exp_b): (exp_a - exp_b);

	// No need to worry about shifting.
	// Now the fraction part
	frac_ans_un = 48'b0;
	// a * b , so we are going to a as multiplicand and b as multiplier

	a_sub = !(| exp_a);
	b_sub = !(| exp_b);
	count = 0;
	multiplicand = {a_sub, frac_a};
	multiplier = {b_sub, frac_b};


	divident = {a_sub,frac_a};
	divisor = {b_sub, frac_b};
	exp_a_n = exp_a;
	exp_b_n = exp_b;
	
	quot = 48'b0;
	remnd = 48'b0;
	more_one_sft = 1'b0;
	cntr = 6'b0;

	while(!divident[23]) begin
		divident = divident << 1;
		exp_a_n = exp_a_n -1;
	end

	while(!divisor[23]) begin
		divisor = divisor << 1;
		exp_b_n = exp_b_n -1;
	end

	divident = divident << 27;

	//Multiplication
	if(!mul) begin
		while (count < 24) begin
			temp = (multiplier[count])? multiplicand : 24'b0;
			frac_ans_un = frac_ans_un + (temp << count);
			count =  count + 1;
		end
	end
	else if((! div_by_zero) && mul ) begin // for division 
		// Long division method
		// quot is the final answer
		remnd = remnd << 1;
		remnd[0] = divident[23];
		divident = divident << 1;
		while (cntr < 48) begin
			if(remnd < divisor) begin
				if(more_one_sft) begin
					quot = quot << 1;
				end
				remnd = remnd << 1;
				remnd[0] = divident[23];
				divident = divident << 1;
				more_one_sft = 1'b1;

			end
			else begin
				remnd = remnd - divisor;
				remnd = remnd << 1;
				remnd[0] = divident[23];
				divident = divident << 1;
				quot = quot << 1;
				quot[0] = 1'b1;
				more_one_sft = 1'b0;
			end
		end
	end
	else if(mul && div_by_zero) begin
		quot = 48'b0;
	end



	// Normalization
	logic ch;
	logic [4:0]count;
	if(! mul) begin
		ch=1'b0;
		while(ch==1'b0)
		begin
			{ch,frac_ans_un}=frac_ans_un << 1'b1;
			count=count+5'd1;
		end

		exp_ans_un = exp_ans_un + count;
	end
	else begin
		ch=1'b0;
		while(ch==1'b0)
		begin
			{ch,quot}=quot << 1'b1;
			count=count+5'd1;
		end

		exp_ans_un = exp_ans_un + count;
	end

	//INE
	if(!mul) begin
		if((frac_ans_un[24:0]==25'd0) && !(zero_a || zero_b)) begin
			ine = 1'b0;
		end
		else begin
			ine = 1'b1;	
		end
	end
	else begin
		if((quot[24:0]==25'd0) && (! div_by_zero) && (zero_a)) begin
			ine = 1'b0;
		end
		else begin
			ine = 1'b1;	
		end

	// Rounding method

	case(rmode)
		2'b00:	begin
				//Rounding to nearest even
				// Not sure what to round if it overflows.
				// I am thinking to round it of to highest value -1
				// If it is odd number then it is added with 1, if it is even it is added with 0
				// Example: -23.5 and -24.5 both will round to -24.
					if(!mul) begin	
						if(frac_ans_un[25]) begin// To check if it is ODD
							{carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25'b0};
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							frac_ans_un = frac_ans_un[47:1]>>carry;
							frac_final=frac_ans_un[47:25];
						end
						else begin // Because roundin to nearest even needs it to get truncated.
							frac_final = fraction_ans_un[47:25];
						end
					end
					else begin // division
						if(quot[25]) begin// To check if it is ODD
							{carry, quot} = quot + {|(quot[24:0]), 25'b0};
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							quot = quot[47:1]>>carry;
							frac_final=quot[47:25];
						end
						else begin // Because roundin to nearest even needs it to get truncated.
							frac_final = quot[47:25];
						end

				end
		2'b01:	begin
				// Rounding to zero is simply truncation

					frac_final = (mul)? quot[47:25]: frac_ans_un[47:25];
			end
		2'b10:	begin
				// Rounding to +INF
				// Here it depends on the sign if it is -24.5 it is rounded of to -24, but if it is 24.5 it is rounded of to 25
				if(sign_ans_un) begin
						frac_final = (mul) ? quot[47:25] : fraction_ans_un[47:25];
				end
				else begin
						if(!mul) begin
							{carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25b'0};
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							frac_ans_un = frac_ans_un[47:1]>>carry;
							frac_final=frac_ans_un[47:25];
							end
						else begin
							{carry, quot} = quot + {|(quot[24:0]), 25'b0};
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							quot = quot[47:1]>>carry;
							frac_final=quot[47:25];
						end
				end
			end
		2'b11:	begin
				// Rounding to -INF
				// Here if it 24.5 it is rounded of to 24, but if it is -24.5 it is rounded of to -25
				if(sign_ans_un) begin
					if(! mul) begin
						{carry, frac_ans_un} = frac_ans_un + {|(frac_ans_un[24:0]), 25b'0};
						exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
						frac_ans_un = frac_ans_un[47:1]>>carry;
						frac_final = frac_ans_un[47:5];
						end
					else begin
						{carry, quot} = quot + {|(quot[24:0]), 25'b0};
							exp_ans_un = exp_ans_un + carry; // This line is added if we have any carry
							quot = quot[47:1]>>carry;
							frac_final=quot[47:25];
					end	
				else begin
						frac_final = (mul) ? quot[47:25] : fraction_ans_un[47:25];
				end
			end
	endcase // rmode

	//Qnan

	qnan = ((& exp_ans_un) && (|frac_final));

	//snan
	snan = ((& exp_a) && (| frac_a))|| ((& exp_b) && (| frac_b));

	// Inf

	inf = ((& exp_a) && !(| frac_a)) || ((& exp_b) && !(| frac_b));

	// Overflow

	overflow = ((& exp_ans_un) && !(| frac_final));

	// Underflow

	if(! mul) begin
		// For multiplication
		if( (! (!(| exp_a) && !(| frac_a)) || (!(| exp_b) && !(| frac_b)) )) begin // If neither are zero
			underflow = (!(| exp_ans_un) && !(| frac_final));
		end
		else
			underflow = 1'b0;
	end
	else begin
		if(!div_by_zero) begin
			if(!(| exp_a) && !(| frac_a)) begin
				underflow = 1'b0;
			end
			else begin
				underflow = (!(| exp_ans_un) && !(| frac_final));
			end
		end
	end

	// Zero

	zero = (!(| exp_ans_un) && !(| frac_final));

	out = {sign_ans,exp_ans_un,frac_final};
	return {zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out};
endfunction		

endpackage: scoreboard
