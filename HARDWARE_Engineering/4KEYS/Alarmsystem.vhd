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
--	This file defines a project that s the key pressed on the PmodKYPD to the seven segment display
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
              p : in std_logic;
           seg : out  STD_LOGIC_VECTOR (6 downto 0)); -- digit to display on the seven segment display
        
            
end Alarmsystem;

architecture Behavioral of Alarmsystem is
component Decoder is
	Port (
			 clk : in  STD_LOGIC;
          Row : in  STD_LOGIC_VECTOR (3 downto 0);
			 Col : out  STD_LOGIC_VECTOR (3 downto 0);
          DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component comparator is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        key: in std_logic_vector(3 downto 0);
        passwordMatch: out std_logic;
        s: out bit;
        r: out bit;
        firstKey: in std_logic;   -- Input signal for First Key state
        secondKey: in std_logic;  -- Input signal for Second Key state
        thirdKey: in std_logic;   -- Input signal for Third Key state
        fourthKey: in std_logic;  -- Input signal for Fourth Key state
        runningState: in std_logic -- Input signal for Running State
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
        clk     : in  std_logic;                     -- Clock signal
        correct : in  bit;                            -- Signal representing correct input
        wrong   : in  bit;                            -- Signal representing wrong input
        reset   : in  std_logic;                      -- Reset signal
        idle_state : in std_logic;                    -- Signal representing idle state
        anode   : out std_logic_vector(7 downto 0);   -- Controls the display digits
        segOut  : out std_logic_vector(6 downto 0);   -- Seven-segment display output
        buzzer  : out std_logic                       -- Buzzer output
    );
end component DisplayController;

component myFSM is
    port (
        reset:in std_logic;
        p : in std_logic;
        clk: in std_logic;
        q: out bit;
        idle_state_sig: out std_logic;
        running_state_sig: out std_logic
    );
end component myFSM;

component FSM_password is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        decodedKey: in std_logic_vector(3 downto 0);
        outputReady: out std_logic;
        key1: out std_logic_vector(3 downto 0);
        passwordMatch: in std_logic;
        fsmTransition: in std_logic;
        keysent: out std_logic
    );
end component ;

component FSM_comparator is
     Port (
        reset: in std_logic;
        clk: in std_logic;
        outputReady_First: in std_logic;
        outputReady_Second: in std_logic;
        outputReady_Third: in std_logic;
        outputReady_Fourth: in std_logic;
        firstKey: out std_logic;
        secondKey: out std_logic;
        thirdKey: out std_logic;
        fourthKey: out std_logic;
        fsmTransition: out std_logic  -- Added fsmTransition signal
    );
end component FSM_comparator;

component FSM_output_ready_generator is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        outputReady: in std_logic;
        outputReady_First: out std_logic;
        outputReady_Second: out std_logic;
        outputReady_Third: out std_logic;
        outputReady_Fourth: out std_logic
    );
end component FSM_output_ready_generator;


signal Decode: STD_LOGIC_VECTOR (3 downto 0);
signal s_state: bit;
signal r_state: bit;
signal command_c: bit;
signal command_w: bit;
signal clk_s: std_logic;
signal running: std_logic;
signal idle: std_logic;
signal k1: STD_LOGIC_VECTOR (3 downto 0);
signal Pm: std_logic;
signal Outready: std_logic;
signal Outready1: std_logic;
signal Outready2: std_logic;
signal Outready3: std_logic;
signal Outready4: std_logic;
signal ks: std_logic;
signal fk: std_logic;
signal sk: std_logic;
signal tk: std_logic;
signal fourthk: std_logic;
signal fsmt: std_logic;

begin

	
	C0: Decoder port map (clk=>clk, Row =>JA(7 downto 4), Col=>JA(3 downto 0), DecodeOut=>Decode);
    C1: comparator port map (clk => clk, reset => reset,key=>k1,runningstate => running, passwordmatch => pm, s => s_state, r => r_state,firstkey=>fk,secondkey=>sk,thirdkey=>tk,fourthkey=>fourthk);
    C2: latch port map (s => s_state, r => r_state, clk => clk, reset => reset, correct => command_c, wrong => command_w);
	C3: DisplayController port map (clk=>clk,correct=>command_c,wrong=>command_w,reset=>reset,anode=>an,segOut=>seg,buzzer=>buzzer,idle_state=>idle);
	C4: myFSM port map (p=>p,running_state_sig=>running,clk=>clk,reset=>reset,idle_state_sig=>idle);
	C5: FSM_password port map (clk=>clk,reset=>reset,decodedkey=>Decode,key1=>k1,passwordmatch=>pm,outputready=>outready,keysent=>ks,fsmtransition=>fsmt);
	C6: FSM_Comparator port map (reset=>reset,clk=>clk,firstkey=>fk,secondkey=>sk,thirdkey=>tk,fourthkey=>fourthk,fsmtransition=>fsmt,outputReady_First=>outready1,outputReady_Second=>outready2,outputReady_third=>outready3,outputReady_Fourth=>outready4);
    C7: FSM_output_ready_generator port map (clk=>clk,reset=>reset,outputready=>outready,outputReady_First=>outready1,outputReady_Second=>outready2,outputReady_third=>outready3,outputReady_Fourth=>outready4);

end Behavioral;