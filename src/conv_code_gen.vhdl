library ieee;
use ieee.std_logic_1164.all;

library work;

entity conv_code_gen is
	port (
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		input_bit : in std_ulogic;
		output_bits : out std_ulogic_vector (size-1 downto 0)
	);
end conv_code_gen;
