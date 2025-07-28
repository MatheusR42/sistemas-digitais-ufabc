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
      HEX5   : out std_logic_vector(6 downto 0)
   );
end seq_rec;

architecture process_3 of seq_rec is
   type state_type is (A, B, C, D, E);
   signal state, next_state : state_type;
   signal x : std_logic := '0'; -- input value from keys
   signal reset : std_logic := '0'; -- reset from SW[0]
   signal state_bin : std_logic_vector(2 downto 0); -- binary state for LEDR
begin

   -- Process: Input control (KEYs and SW)
   input_control: process(KEY, SW)
   begin
      -- SW[0] is reset (active high)
      if SW(0) = '1' then
         reset <= '1';
      else
         reset <= '0';
      end if;

      -- KEY[1] = x='1', KEY[0] = x='0' (active low)
      if KEY(1) = '0' then
         x <= '1';
      elsif KEY(0) = '0' then
         x <= '0';
      else
         x <= '0'; -- default
      end if;
   end process;

   -- Process: State register with asynchronous reset and rising_edge for KEYs
   state_register: process(KEY, reset)
   begin
      if reset = '1' then
         state <= A;
      elsif rising_edge(KEY(1)) or rising_edge(KEY(0)) then
         state <= next_state;
      end if;
   end process;

   -- Process: Next state logic
   next_state_func: process(x, state)
   begin
      case state is
         when A =>
            if x = '1' then
               next_state <= B;
            else
               next_state <= A;
            end if;
         when B =>
            if x = '1' then
               next_state <= C;
            else
               next_state <= A;
            end if;
         when C =>
            if x = '1' then
               next_state <= C;
            else
               next_state <= D;
            end if;
         when D =>
            if x = '1' then
               next_state <= E;
            else
               next_state <= A;
            end if;
         when E =>
            if x = '1' then
               next_state <= C;
            else
               next_state <= A;
            end if;
      end case;
   end process;

   -- Process: State to Gray code for LEDR
   led_control: process(state)
   begin
      case state is
         when A => state_bin <= "000"; -- A (Gray: 000)
         when B => state_bin <= "001"; -- B (Gray: 001)
         when C => state_bin <= "011"; -- C (Gray: 011)
         when D => state_bin <= "010"; -- D (Gray: 010)
         when E => state_bin <= "110"; -- E (Gray: 110)
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
end process_3;
