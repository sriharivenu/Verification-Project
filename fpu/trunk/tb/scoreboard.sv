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
	return {zero_a, inf_in, aeqb, blta, altb, unordered, zero, div_by_zero, underflow, overflow, ine, inf, qnan, snan, out}

endfunction

function [45:0] mul_div (logic [31:0] in_a, logic [31:0] in_b, logic mul, logic [1:0] rmode);
	
	logic [7:0] exp_a;
	logic [22:0] frac_a;
	logic sign_a;
	logic [7:0] exp_b;
	logic [22:0] frac_b;
	logic sign_b;

	exp_a = in_a[30:23];
	sign_a = in_a[31];
	frac_a = in_a[22:0];

	exp_b = in_b[30:23];
	sign_b = in_b[31];
	frac_b = in_b[22:0];

	// Thought of converting it to decimal and proceed but converting it back might be a problem.
	/*real a;
	real b;
	real ans_un;
	integer power_a;
	integer power_b;
	integer bit_s;
	integer bit_pow;
	bit_pow = 1;
	power_a = exp_a - 127;
	power_b = exp_b - 127;
	a = !(| exp_a)? 0: 1;
	for(bit_s = 22; bit_s >=0; bit_s++) begin
		a = a + (frac_a[bit_s]* (2**(-1*bit_pow)));
		bit_pow = bit_pow + 1;
	end
	a = a*(2**power_a);
	a = a*((-1)**sign_a);
	bit_pow = 1;
	b = !(| exp_b)? 0:1;
	for(bit_s = 22; bit_s >=0; bit_s++) begin
		b = b + (frac_b[bit_s]*(2**(-1*bit_pow)));
		bit_pow = bit_pow + 1;
	end
	b = b*(2**power_b);
	b = b*((-1)**sign_b);
	// Multiply and Divide
	if(!mul) begin
		ans_un = a*b;
	end
	else begin
		ans_un = a/b;
	end

	logic [47:0] dec_flt;
	integer index;
	integer count;
	real temp;
	temp = c;
	dec_flt = 48'b0;
	index = 0;
	count = 0;
	if((ans_un >= 1) || (ans_un <= -1)) begin
		for(index = 0; index < 48; index++) begin
			if(temp >= 1) begin
				// To get the value on left of decimal
				temp = temp / 2;*/

	logic [8:0] exp_ans_un;
	logic [47:0] frac_ans_un;
	logic [23:0] frac_ans_div;

	//To calculate the proper exponent
	exp_ans_un = (! mul)? (exp_a + exp_b): (exp_a - exp_b);

	// No need to worry about shifting.
	// Now the fraction part
	frac_ans_un = 48'b0;
	// a * b , so we are going to a as multiplicand and b as multiplier
	logic [23:0] multiplicand;
	logic [23:0] multiplier;
	logic [23:0] temp;
	//logic [50:0] divisor;
	//logic [50:0] divident;
	//logic [50:0] quotient;
	//logic [50:0] remainder;
	// Based on restoring division logic
	logic [23:0] divisor;
	logic [23:0] divident;
	/*logic [47:0] remainder;
	logic [23:0] quo;
	logic [23:0] rem;
	*/
	logic [47:0] quot;
	logic [47:0] remnd;
	logic [7:0] exp_a_n;
	logic [7:0] exp_b_n;
	//logic [4:0] cnt;
	integer count;
	logic a_sub;
	logic b_sub;

	logic more_one_sft;
	logic [5:0] cntr;
	//logic guard;
	//logic rb;

	a_sub = !(| exp_a);
	b_sub = !(| exp_b);
	count = 0;
	multiplicand = {a_sub, frac_a};
	multiplier = {b_sub, frac_b};


	divident = {a_sub,frac_a};
	divisor = {b_sub, frac_b};
	exp_a_n = exp_a;
	exp_b_n = exp_b;
	
	//quotient = 51'b0;
	//remainder = 51'b0;
	//cnt = 5'b0;

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
	else begin // for division 
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




		// Using normal restoration algorithm

		/*remainder[23:0] = divident;
		remainder = remainder << 1;
		while (cnt <= 24) begin
			remainder[47:24] = (remainder[47:24] - divisor);
			if(remainder >= 0) begin
				remainder = remainder << 1;
				remainder[0] = 1'b1;
			end
			else begin
				remainder[47:24] = (remainder[47:24] + divisor);
				remainder = remainder << 1;
			end
		end
		remainder = remainder >> 1;
		quo = remainder[23:0];
		rem = remainder[47:24];
		*/

		/*while (cnt <= 49) begin
			quotient = quotient << 1;
			remainder = remainder << 1;
			remainder[0] = divident[50];
			divident = divident << 1;
			if(remainder >= divisor) begin
				quotient[0] = 1'b1;
				remainder = remainder - divisor;
			end
			cnt = cnt +1;
		end
		frac_ans_div = quotient[26:3];
		guard = quotient[2];
		rb = quotient[1];*/


	// Need to normaliztion for multiplication



	
	//Division normalization
	/*if(mul) begin
		while ((frac_ans_div[23] == 1'b0) && (exp_ans_un - 127) > -126) begin
			exp_ans_un = exp_ans_un - 1;
			frac_ans_div = frac_ans_div << 1;
			frac_ans_div[0] = guard;
			guard = rb;
			rb = 1'b0;
		end
		while ((exp_ans_un - 127 ) < -126) begin
			exp_ans_un = exp_ans_un +1;
			frac_ans_div = frac_ans_div >> 1;
			guard = frac_ans_div[0];
			rb = guard;
		end
	else
*/
	// Need to do rounding for both


endfunction		

endpackage: scoreboard
