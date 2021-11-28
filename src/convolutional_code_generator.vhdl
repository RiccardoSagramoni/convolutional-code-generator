library ieee;
use ieee.std_logic_1164.all;

library work;

entity convolutional_code_generator is
	port (
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		a_in : in std_ulogic;
		a_out : out std_ulogic;
		c_out : out std_ulogic
	);

end convolutional_code_generator;

architecture beh of convolutional_code_generator is
	
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
	
	constant a_reg_size : natural := 5;
	constant c_reg_size : natural := 10;

	signal a_reg_out : std_ulogic_vector(a_reg_size-1 downto 0);
	signal c_reg_out : std_ulogic_vector(c_reg_size-1 downto 0);

	signal c_out_signal : std_ulogic;

begin
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

	proc: process (reset, a_reg_out)
	begin
		if (reset = '1') then
			a_out <= '0';
			c_out_signal <= '0';
		else
			-- Generate convolutional codes
			a_out <= a_reg_out(0);
			c_out_signal <= a_reg_out(0) xor a_reg_out(3) xor a_reg_out(4) xor c_reg_out(8) xor c_reg_out(10);
		end if;
	end process;

	c_out <= c_out_signal;

end beh;
