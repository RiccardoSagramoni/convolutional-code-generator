library ieee;
use ieee.std_logic_1164.all;

library work;

entity ShiftRegister is
	generic (
		size : natural := 5
	);

	port (
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		enable : in std_ulogic; -- enable, active high
		input_bit : in std_ulogic;
		output_bits : out std_ulogic_vector (size-1 downto 0)
	);
end ShiftRegister_InputBits;

architecture beh of ShiftRegister is

	component DFlipFlop is
		generic( N : natural := 8);
			
		port( 
			clock : in std_ulogic; -- external clock
			reset : in std_ulogic; -- reset, asynchronous, active high
			enable : in std_ulogic; -- enable, active high
			d : in std_ulogic; -- input bit
			q : out std_ulogic -- ouput bit
		);
				
	end component DFlipFlop;

	signal q_s : std_ulogic_vector (size-1 downto 0);

begin

	-- Generate Flip-Flop
	GEN: for i in 0 to size-1 generate
		FIRST: if (i = 0) generate
			FF1: DFlipFlop
			port map (
				clock => clock,
				reset => reset,
				enable => enable,
				d => input_bit,
				q => q_s(i)
			);
		end generate FIRST;

		INTERNAL: if (i > 0) generate
			FFi: DFlipFlop
			port map (
				clock => clock,
				reset => reset,
				enable => enable,
				d => q_s(i-1),
				q => q_s(i)
			);
		end generate INTERNAL;
	end generate GEN;

	output_bits <= q_s;
		

end beh;
