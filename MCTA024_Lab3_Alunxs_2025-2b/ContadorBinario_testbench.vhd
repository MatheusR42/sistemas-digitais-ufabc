-- Testbench for ContadorBinario - Binary Counter
library ieee;
use ieee.std_logic_1164.all;

entity ContadorBinario_testbench is
end ContadorBinario_testbench;

architecture tb_arch of ContadorBinario_testbench is
    signal KEY : std_logic_vector(1 downto 0);
    signal LEDR : std_logic_vector(9 downto 6);
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.ContadorBinario
        port map (
            KEY => KEY,
            LEDR => LEDR
        );

    -- Stimulus process: generates test vectors
    stimulus_process: process
    begin
        -- Initialize
        KEY <= "00"; -- Reset
        wait for 20 ns;
        
        KEY(1) <= '1'; -- Enable counting
        KEY(0) <= '0'; wait for 10 ns; -- Initial state
        
        -- Simulate rising edges on KEY(0) to increment counter
        for i in 0 to 7 loop
            KEY(0) <= '1'; wait for 10 ns; -- Rising edge
            KEY(0) <= '0'; wait for 10 ns; -- Falling edge
        end loop;
        
        -- Reset counter
        KEY(1) <= '0'; wait for 20 ns;
        KEY(1) <= '1'; wait for 10 ns;
        
        wait;
    end process;

end tb_arch;
