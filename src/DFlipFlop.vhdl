library ieee;
use ieee.std_logic_1164.all;

library work;

-- Circuit which stores and keeps stable a single bit for a clock cycle.
--
-- It takes and input bit on the port "d" and stores it on a rising edge
-- of the clock. The stored bit is replicated on the "q" port for a clock cycle.
entity DFlipFlop is
	port( 
		clock : in std_ulogic; -- external clock
		reset : in std_ulogic; -- reset, asynchronous, active high
		d : in std_ulogic; -- input bit
		q : out std_ulogic -- ouput bit
	);
			
end DFlipFlop;

-- Implementation of the D Flip-Flop
architecture beh of DFlipFlop is   
begin
   
	DFF_proc: process(clock, reset)
		begin
			if(reset = '1') then -- Reset the circuit (output equals to zero)
				q <= '0';
			elsif(rising_edge(clock)) then -- Store a new bit
				q <= d;
			end if;
		end process;
	
end beh;
