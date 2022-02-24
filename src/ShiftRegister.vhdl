library ieee;
use ieee.std_logic_1164.all;

library work;

-- Data storing element. It uses a cascade of D Flip-Flop (DFF) where
-- the output of one flip-flop is connected to the input of the next.
-- In this way, each bit will move by one "position" at the beginning
-- of a clock cycle.
-- 
-- It takes a bit as data input per clock cycle 
-- and outputs the state of the DFFs.
entity ShiftRegister is
	generic (
		size : natural := 5 -- number of DFFs
	);

	port (
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		input_bit : in std_ulogic;
		output_bits : out std_ulogic_vector (size-1 downto 0)
	);
end ShiftRegister;

architecture beh of ShiftRegister is

	-- Declare D Flip-Flop component
	component DFlipFlop is
		port( 
			clock : in std_ulogic; -- external clock
			reset : in std_ulogic; -- reset, asynchronous, active high
			d : in std_ulogic; -- input bit
			q : out std_ulogic -- ouput bit
		);
				
	end component DFlipFlop;

	-- This signal connect the output of each DFF
	-- to the input of the next one and to the output of
	-- the shift register.
	signal q_s : std_ulogic_vector (size-1 downto 0);

begin

	-- Generate D Flip-Flops
	GEN: for i in 0 to size-1 generate
		-- First DFF: input connected to the input of shift register
		FIRST: if (i = 0) generate
			FF1: DFlipFlop
			port map (
				clock => clock,
				reset => reset,
				d => input_bit,
				q => q_s(i)
			);
		end generate FIRST;

		-- All the other DFFs: input connected to the output of the previouse DFF
		INTERNAL: if (i > 0) generate
			FFi: DFlipFlop
			port map (
				clock => clock,
				reset => reset,
				d => q_s(i-1),
				q => q_s(i)
			);
		end generate INTERNAL;
	end generate GEN;

	-- Asynchronously assign the output of the DFFs 
	-- to the output of the shift register
	output_bits <= q_s;
	
end beh;
