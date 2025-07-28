-- Testbench for seq_rec - Sequence Detector
library ieee;
use ieee.std_logic_1164.all;

entity seq_rec_testbench is
end seq_rec_testbench;

architecture tb_arch of seq_rec_testbench is
   signal CLK, RESET, X : std_logic;
   signal Z : std_logic;
begin

   -- Instantiate the Unit Under Test (UUT)
   uut: entity work.seq_rec(process_3)
      port map (
         CLK => CLK,
         RESET => RESET,
         X => X,
         Z => Z
      );

   -- Clock process: 20 ns period (10 ns high, 10 ns low)
   clk_process: process
   begin
      CLK <= '0';
      wait for 10 ns;
      CLK <= '1';
      wait for 10 ns;
   end process;

   -- Stimulus process: generates test vectors
   stimulus_process: process
   begin
      -- Initialize
      RESET <= '1';
      X <= '0';
      wait for 20 ns;

      RESET <= '0';  -- Deassert reset
      
      -- Send bit sequence: 1 1 0 1 -> should detect 1101 → Z='1'
      X <= '1'; wait for 20 ns;  -- First 1
      X <= '1'; wait for 20 ns;  -- Second 1
      X <= '0'; wait for 20 ns;  -- Zero
      X <= '1'; wait for 20 ns;  -- Final 1 (should trigger Z='1')

      -- Another sequence: 1 1 0 1 again (overlapping)
      X <= '1'; wait for 20 ns;
      X <= '1'; wait for 20 ns;
      X <= '0'; wait for 20 ns;
      X <= '1'; wait for 20 ns;

      -- Send a false pattern: 1 0 1 1 (should NOT trigger Z='1')
      X <= '0'; wait for 20 ns;
      X <= '1'; wait for 20 ns;
      X <= '0'; wait for 20 ns;
      X <= '1'; wait for 20 ns;
      X <= '1'; wait for 20 ns;
      wait;
   end process;

end tb_arch;
