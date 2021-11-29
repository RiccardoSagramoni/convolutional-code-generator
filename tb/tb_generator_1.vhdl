library IEEE;
use IEEE.std_logic_1164.all;

library work;

entity tb_generator_1 is
end tb_generator_1;

architecture beh of tb_generator_1 is

	constant clock_period : time := 10 ns;

	component convolutional_code_generator is
		port (
			clock : in std_ulogic; -- external clock
			reset : in std_ulogic; -- reset, asynchronous, active high
			a_in : in std_ulogic;
			a_out : out std_ulogic;
			c_out : out std_ulogic
		);
	end component convolutional_code_generator;

	signal clock : std_ulogic   := '1';
	signal reset : std_ulogic	:= '1';
	signal a_in : std_ulogic := '0';
	signal a_out : std_ulogic;
	signal c_out : std_ulogic;
	
	signal testing : boolean := true;
	signal generating : boolean := false;

begin

	cc_generator: convolutional_code_generator
	port map (
		clock => clock,
		reset => reset,
		a_in => a_in,
		a_out => a_out,
		c_out => c_out
	);

	clock <= not clock after clock_period/2 when testing else '0';

	stimulus: process
	begin
		-- Reset the components
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		reset <= '0';
		wait until rising_edge(clock);
		generating <= true;

		-- Test message '10101010101010' ('01' 10 times)
		for i in 1 to 10 loop
			a_in <= '1';
			wait until rising_edge(clock);
			
			a_in <= '0';
			wait until rising_edge(clock);
		end loop;

		generating <= false;
		a_in <= '0'; -- reset a_in

		-- wait two clock cycles for the complete convolutional code
		wait until rising_edge(clock);
		wait until rising_edge(clock);

		testing <= false; -- stop simulation

	end process stimulus;

end beh;