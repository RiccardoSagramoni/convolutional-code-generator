library ieee;
use ieee.std_logic_1164.all;

library work;

entity DFlipFlop is
	generic( N : natural := 8);
		
	port( 
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		enable : in std_ulogic; -- enable, active high
		d : in std_ulogic; -- input bit
		q : out std_ulogic -- ouput bit
	);
			
end DFlipFlop;

architecture beh of DFlipFlop is   
begin
   
	DFF_proc: process(clock, reset)
		begin
			if(reset = '1') then
				q <= '0';

			elsif(rising_edge(clock)) then
				if(enable = '1') then
					q <= d;
				end if;
			end if;
		end process;
   
end beh;
