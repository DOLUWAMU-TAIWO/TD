----------------------------------------------------------------------------------
-- Company: HSHL
-- Engineer: Doluwamu Kuye  
-- Create Date:    17:05:39 08/23/2011 
--
-- Module Name:    Top - Behavioral 
-- Project Name:  Alarm system
-- Target Devices: Nexys A7
-- Tool versions: Xilinx ISE 13.2 
-- Description: 
--	This file defines a project that outputs the key pressed on the PmodKYPD to the seven segment display
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Alarmsystem is
    Port ( 
			  clk : in  STD_LOGIC;
			  JA : inout  STD_LOGIC_VECTOR (7 downto 0); -- PmodKYPD is designed to be connected to JA
           an : out  STD_LOGIC_VECTOR (7 downto 0);   -- Controls which position of the seven segment display to display
           reset : in std_logic;
           buzzer: out std_logic;
            buzzblue: out std_logic;
              p : in std_logic;
          buzzergreen : out std_logic;
           seg : out  STD_LOGIC_VECTOR (6 downto 0)); -- digit to display on the seven segment display
       
        
            
end Alarmsystem;

architecture Behavioral of Alarmsystem is
component Decoder is
	Port (
        clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        KeyPressed : out STD_LOGIC
    );
	end component;
	
	component comparator is
       port (
        keypad_input : in std_logic_vector(3 downto 0);  -- Input from the keypad
        clk : in std_logic;                             -- Clock signal
        reset : in std_logic;                           -- Reset signal
        running_state : in std_logic;                    -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                   -- Signal indicating if any key is pressed
        nokey : out std_logic;                          -- Signal indicating no key is pressed
        s : out bit;                              -- Signal to set the latch
        r : out bit                               -- Signal to reset the latch
    );
end component comparator;

component latch is
    port (
        s : in bit;               -- Signal to set the latch
        r : in bit;               -- Signal to reset the latch
        clk : in std_logic;       -- Clock signal
        reset : in std_logic;     -- Reset signal
        correct : out bit;        -- Signal representing correct input
        wrong : out bit           -- Signal representing wrong input
    );
end component latch;

component DisplayController is
 Port ( 
        clk         : in  std_logic;                     -- Clock signal
        correct     : in  bit;                            -- Signal representing correct input
        wrong       : in  bit;                            -- Signal representing wrong input
        reset       : in  std_logic;                      -- Reset signal
        idle_state  : in std_logic;                       -- Signal representing idle state
        nokey       : in std_logic;                        -- Signal representing no key pressed
        anode       : out std_logic_vector(7 downto 0);   -- Controls the display digits
        segOut      : out std_logic_vector(6 downto 0);   -- Seven-segment display output
        buzzer  : out std_logic;                      -- Buzzer output for main code
        buzzerblue   : out std_logic ;                      -- Buzzer output for "no key" condition
        buzzergreen : out std_logic
    );
end component DisplayController;

component myFSM is
    port (
        reset: in std_logic;
        p: in std_logic;
        clk: in std_logic;
        q: out bit;
        running_state_sig: out std_logic;
        idle_state_sig: out std_logic
    );
end component myFSM;

signal Decode: STD_LOGIC_VECTOR (3 downto 0);
signal s_state: bit;
signal r_state: bit;
signal command_c: bit;
signal command_w: bit;
signal clk_s: std_logic;
signal running: std_logic;
signal idle: std_logic;
signal akp: std_logic;
signal nk: std_logic;
begin

	
	C0: Decoder port map (clk=>clk, Row =>JA(7 downto 4), Col=>JA(3 downto 0), DecodeOut=>Decode,keypressed=>akp);
	C1: Comparator port map (clk=>clk,reset=>reset,anykeypressed=>akp,keypad_input=>Decode,s=>s_state,r=>r_state,running_state => running,nokey=>nk);
	C2: latch port map (s => s_state, r => r_state, clk => clk, reset => reset, correct => command_c, wrong => command_w);
	C3: DisplayController port map (clk=>clk,correct=>command_c,wrong=>command_w,reset=>reset,anode=>an,segOut=>seg,buzzer=>buzzer,buzzerblue=>buzzblue,idle_state=>idle,nokey=>nk,buzzergreen=>buzzergreen);
    C4: myFSM port map (p=>p,running_state_sig=>running,clk=>clk,reset=>reset,idle_state_sig=>idle);

end Behavioral;

