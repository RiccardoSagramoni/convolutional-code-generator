library IEEE;
use IEEE.std_logic_1164.all;

library work;

entity tb_shift_register is
end tb_shift_register;

architecture beh of tb_shift_register is
	constant clk_period     :   time    := 8 ns;

	component ShiftRegister is
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
	end component ShiftRegister;

	signal clk  :   std_ulogic   := '1';
	signal en_ext   :   std_ulogic   := '0';
	signal r_ext    :   std_ulogic	:= '1';
	signal testing	:	boolean	:= true;

	signal reg_in : std_ulogic := '0';
	signal reg_out : std_ulogic_vector (4 downto 0);

begin
	clk <= not clk after clk_period/2 when testing else '0';
	en_ext <= '1' when testing else '0';

	reg: ShiftRegister 
		port map (
			clock => clk,
			reset => r_ext,
			enable => en_ext,
			input_bit => reg_in,
			output_bits => reg_out
		);

	stimulus: process
	begin
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		r_ext <= '0';

		reg_in <= '1';
		wait until rising_edge(clk);
		reg_in <= '0';
		wait until rising_edge(clk);
		reg_in <= '1';
		wait until rising_edge(clk);
		reg_in <= '0';
		wait until rising_edge(clk);
		reg_in <= '0';
		wait until rising_edge(clk);
		reg_in <= '1';
		wait until rising_edge(clk);
		reg_in <= '1';
		wait until rising_edge(clk);
		reg_in <= '0';
		wait until rising_edge(clk);
		reg_in <= '1';
		wait until rising_edge(clk);
		reg_in <= '0';
		wait until rising_edge(clk);

		testing <= false;
	end process stimulus;

end beh;