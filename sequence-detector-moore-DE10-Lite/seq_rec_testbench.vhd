-- Testbench for seq_rec - Sequence Detector
library ieee;
use ieee.std_logic_1164.all;

entity seq_rec_testbench is
end seq_rec_testbench;

architecture tb_arch of seq_rec_testbench is
   signal KEY  : std_logic_vector(1 downto 0);
   signal SW   : std_logic_vector(0 downto 0);
   signal LEDR : std_logic_vector(2 downto 0);
   signal Z    : std_logic;
begin

   -- Instantiate the Unit Under Test (UUT)
   uut: entity work.seq_rec(process_3)
      port map (
         KEY  => KEY,
         SW   => SW,
         LEDR => LEDR,
         HEX0 => open,
         HEX1 => open,
         HEX2 => open,
         HEX3 => open,
         HEX4 => open,
         HEX5 => open,
         Z    => Z
      );

   -- Stimulus process: generates test vectors

   stimulus_process: process
   begin
      -- Initialize
      SW(0) <= '1'; -- Assert reset
      KEY <= "00";
      wait for 20 ns;

      SW(0) <= '0'; -- Deassert reset
      wait for 10 ns;

      -- Send bit sequence: 1 1 0 1 -> should detect 1101 → Z='1'
      -- Simulate rising edges on KEY(0) to increment counter
      KEY(1) <= '1'; wait for 10 ns; -- Rising edge
      KEY(1) <= '0'; wait for 10 ns; -- Falling edge

      KEY(1) <= '1'; wait for 10 ns; -- Rising edge
      KEY(1) <= '0'; wait for 10 ns; -- Falling edge

      KEY(0) <= '1'; wait for 10 ns; -- Rising edge
      KEY(0) <= '0'; wait for 10 ns; -- Falling edge

      KEY(1) <= '1'; wait for 10 ns; -- Rising edge
      KEY(1) <= '0'; wait for 10 ns; -- Falling edge

      -- for i in 0 to 7 loop
      --    KEY(0) <= '1'; wait for 10 ns; -- Rising edge
      --    KEY(0) <= '0'; wait for 10 ns; -- Falling edge
      -- end loop;

      wait;
   end process;

end tb_arch;
