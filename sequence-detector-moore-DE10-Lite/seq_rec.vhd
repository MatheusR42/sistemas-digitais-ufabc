--Sequence Recognizer: VHDL Process Description
library ieee;
use ieee.std_logic_1164.all;

entity seq_rec is
   port (
      KEY    : in std_logic_vector(1 downto 0); -- KEY[1]=x='1', KEY[0]=x='0'
      SW     : in std_logic_vector(0 downto 0); -- SW[0]=reset
      LEDR   : out std_logic_vector(2 downto 0); -- State as binary
      HEX0   : out std_logic_vector(6 downto 0); -- 7-segment display (leftmost)
      HEX1   : out std_logic_vector(6 downto 0);
      HEX2   : out std_logic_vector(6 downto 0);
      HEX3   : out std_logic_vector(6 downto 0);
      HEX4   : out std_logic_vector(6 downto 0);
      HEX5   : out std_logic_vector(6 downto 0);
      Z      : out std_logic
   );
end seq_rec;

architecture process_3 of seq_rec is
   type state_type is (A, B, C, D, E);
   signal state : state_type := A;
   signal x : std_logic := '0'; -- input value from keys
   signal reset : std_logic := '0'; -- reset from SW[0]
begin

   input_control: process (KEY, SW)
		variable tmp: std_logic := '0';
			begin
            if SW(0) = '1' then
               state <= A;
            else 
               if (rising_edge(KEY(0))) then
                  tmp := '0';
               elsif (rising_edge(KEY(1))) then
                  tmp := '1';
               end if;

               if rising_edge(KEY(1)) or rising_edge(KEY(0)) then
                  case state is
                     when A =>
                        if tmp = '1' then
                           state <= B;
                        else
                           state <= A;
                        end if;
                     when B =>
                        if tmp = '1' then
                           state <= C;
                        else
                           state <= A;
                        end if;
                     when C =>
                        if tmp = '1' then
                           state <= C;
                        else
                           state <= D;
                        end if;
                     when D =>
                        if tmp = '1' then
                           state <= E;
                        else
                           state <= A;
                        end if;
                     when E =>
                        if tmp = '1' then
                           state <= C;
                        else
                           state <= A;
                        end if;
                  end case;
               end if;
            end if;
		end process;

   -- Process: State to Gray code for LEDR
   led_control: process(state)
   variable state_bin: std_logic_vector(2 downto 0) := "000";
   begin
      case state is
         when A => state_bin := "000"; -- A (Gray: 000)
         when B => state_bin := "001"; -- B (Gray: 001)
         when C => state_bin := "011"; -- C (Gray: 011)
         when D => state_bin := "010"; -- D (Gray: 010)
         when E => state_bin := "110"; -- E (Gray: 110)
         when others  => state_bin := "111"; -- E (Gray: 111)
      end case;
      
      LEDR <= state_bin;
   end process;


   -- Process: 7-segment display control for HEX0 to HEX5
   seg7_control: process(state)
   begin
      if state = E then
         HEX0 <= "1000000"; -- O
         HEX1 <= "0001100"; -- P
         HEX2 <= "0000110"; -- E
         HEX3 <= "1001000"; -- N
         HEX4 <= "1111111"; -- blank
         HEX5 <= "1111111"; -- blank
      else
         HEX0 <= "1000110"; -- C
         HEX1 <= "1000111"; -- L
         HEX2 <= "1000000"; -- O
         HEX3 <= "0010010"; -- S
         HEX4 <= "0000110"; -- E
         HEX5 <= "0100001"; -- D
      end if;
   end process;


   -- Process: Output logic
   output_func: process (state)
   begin
      case state is
         when E =>
            Z <= '1';
         when others =>
            Z <= '0';
      end case;
   end process;
end process_3;
