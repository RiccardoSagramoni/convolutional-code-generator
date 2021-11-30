library ieee;
use ieee.std_logic_1164.all;

library work;

-- VHDL design a generator of convolutional code.
-- The chosen architecture is recursive (i.e. the future outputs depends on the previous ones)
-- and systematic (the input bit stream is replicated as one of the output).
-- Our generator's rate is 1/2 and the system implements the relationship
-- c[k] = a[k] + a[k-3] + a[k-4] + c[k-8] + c[k-10]
entity convolutional_code_generator is
	port (
		clock : in std_ulogic; 	-- external clock
		reset : in std_ulogic; 	-- reset, asynchronous, active high
		a_in : in std_ulogic;	-- input bit stream
		a_out : out std_ulogic;	-- 1st ouput. It's the replicated input
		c_out : out std_ulogic	-- 2nd output. It implements the relationship
	);

end convolutional_code_generator;

-- The generator is composed by two shift register, a combinational logic 
-- that implements the c[k] relationship and two D-Flip-Flop for the output signals
architecture beh of convolutional_code_generator is
	
	-- The shift registers are used to keep in memory the previous bits
	-- of the a[k] and c[k] streams.
	component ShiftRegister is
		generic (
			size : natural := 5
		);
	
		port (
			clock : in std_ulogic; -- external clock
			reset : in std_ulogic; -- reset, asynchronous, active high
			input_bit : in std_ulogic;
			output_bits : out std_ulogic_vector (size-1 downto 0)
		);
	end component ShiftRegister;

	-- The D-Flip-Flop are used to keep the output signals stable over a clock cycle
	component DFlipFlop is
		port( 
			clock : in std_ulogic; -- external clock
			reset : in std_ulogic; -- reset, asynchronous, active high
			d : in std_ulogic; -- input bit
			q : out std_ulogic -- ouput bit
		);
	end component DFlipFlop;
	
	-- Size of the two shift-registers
	constant a_reg_size : natural := 5;
	constant c_reg_size : natural := 10;

	-- The output signals of the two shift registers.
	-- The indexes are structured so that
	-- a[k - i] = a_reg_out(i), 0 <= i <= 4
	-- c[k - i] = c_reg_out(i), 1 <= i <= 10
	-- where k is the current time
	signal a_reg_out : std_ulogic_vector(a_reg_size-1 downto 0);
	signal c_reg_out : std_ulogic_vector(c_reg_size downto 1);

	-- Output signals of the D-Flip-Flop
	signal a_out_signal : std_ulogic;
	signal c_out_signal : std_ulogic;

begin
	-- Shift register that stores the last 5 a[...] values (from a[k] to a[k-4])
	a_register: ShiftRegister
	generic map (
		size => a_reg_size
	)
	port map (
		clock => clock,
		reset => reset,
		input_bit => a_in,
		output_bits => a_reg_out
	);

	-- Shift register that stores the last 10 c[..] values (from c[k-1] to c[k-10])
	c_register: ShiftRegister
	generic map (
		size => c_reg_size
	)
	port map (
		clock => clock,
		reset => reset,
		input_bit => c_out_signal,
		output_bits => c_reg_out
	);

	-- Flip-Flop to hold a[k] stable for a clock cycle
	output_a_k_dff: DFlipFlop
	port map (
		clock => clock,
		reset => reset,
		d => a_out_signal,
		q => a_out
	);

	-- Flip-Flop to hold c[k] stable for a clock cycle
	output_c_k_dff: DFlipFlop
	port map (
		clock => clock,
		reset => reset,
		d => c_out_signal,
		q => c_out
	);


	-- Generate convolutional codes
	a_out_signal <= a_reg_out(0);
	c_out_signal <= ( a_reg_out(0) xor a_reg_out(3) ) xor ( a_reg_out(4) xor ( c_reg_out(8) xor c_reg_out(10) ) );
	-- The XOR tree is balanced in order to minimize the path between the shift register and the output DDF

end beh;
