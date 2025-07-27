library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ContadorHexadecimal is
	port(
		KEY: in std_logic_vector(1 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
end ContadorHexadecimal;

architecture comportamental of ContadorHexadecimal is
	signal matheus: std_logic_vector(3 downto 0);
	begin
		process (KEY)
		variable tmp: std_logic_vector(3 downto 0);
			begin
				if (KEY(1)='0') then
					tmp := "0000";
				elsif (rising_edge(KEY(0))) then
					tmp := tmp + "0001";
				end if;
				--LEDR <= tmp;
				 matheus <= tmp;
		end process;
		
		with matheus select
      HEX0(6 downto 0) <=
			"1000000" when "0000",  -- 0
			"1111001" when "0001",  -- 1
			"0100100" when "0010",  -- 2
			"0110000" when "0011",  -- 3
			"0011001" when "0100",  -- 4
			"0010010" when "0101",  -- 5
			"0000010" when "0110",  -- 6 ✔
			"1111000" when "0111",  -- 7 ✔
			"0000000" when "1000",  -- 8 ✔
			"0010000" when "1001",  -- 9 ✔
			"0001000" when "1010",  -- A ✔
			"0000011" when "1011",  -- b ✔
			"1000110" when "1100",  -- C ✔
			"0100001" when "1101",  -- d ✔
			"0000110" when "1110",  -- E ✔
			"0001110" when others;  -- F ✔
end;
