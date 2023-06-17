----------------------------------------------------------------------------------
-- Company: HSHL
-- Engineer: Doluwamu Kuye  
-- Create Date:    17:05:39 06/06/2023 
--
-- Module Name:    Top - Behavioral 
-- Project Name:  Alarm system
-- Target Devices: Nexys A7
-- Tool versions: Xilinx ISE 13.2 
-- Description: 
--	This file defines a module that acts as the top file for our whole system.
--
-- Revision: 1.7
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
          Led1: out std_logic;
          Led2: out std_logic;
          Led3: out std_logic;
          Led4: out std_logic;
          
           seg : out  STD_LOGIC_VECTOR (6 downto 0)); -- digit to display on the seven segment display
       
        
            
end Alarmsystem;

architecture Behavioral of Alarmsystem is
component Decoder is
	 Port (
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC; -- Reset signal
        running_state : in STD_LOGIC; -- Running state signal
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        KeyPressed : out STD_LOGIC
    );
	end component;
	
	component comparator is
     port (
        comp1Complete : out std_logic;
        firstKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match1comp : out std_logic;                          -- Signal indicating a match with the first password
        nokey : out std_logic                               -- Signal indicating no key is pressed
    );
end component comparator;

component comparator2 is
    port (
        comp2Complete : out std_logic;
        secondKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match2comp : out std_logic;                          -- Signal indicating a match with the first password
        nokey : out std_logic                               -- Signal indicating no key is pressed
    );
end component comparator2;

component comparator3 is
    port (
        thirdKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match3comp : out std_logic;
        comp3Complete : out std_logic;                         
        nokey : out std_logic                               -- Signal indicating no key is pressed
    );
end component comparator3;

component comparator4 is
    port (
        fourthkeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match4comp : out std_logic;                        -- Signal indicating a match with the first password
        comp4Complete : out std_logic;
        nokey : out std_logic                               -- Signal indicating no key is pressed
    );
end component comparator4;

component latch is
    port (
        s : in bit;               -- Signal to set the latch
        r : in bit;               -- Signal to reset the latch
        clk : in std_logic;       -- Clock signal
        reset : in std_logic;     -- Reset signal
        latch_active : in std_logic;  -- Signal indicating if the latch process is active
        correct : out bit;        -- Signal representing correct input
        wrong : out bit          -- Signal representing wrong input
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
component SequentialKeyPressProcessor is
   Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        running_state : in STD_LOGIC;
        DecodeOut : in STD_LOGIC_VECTOR (3 downto 0);
        Key1Assigned : out STD_LOGIC;
        Key2Assigned : out STD_LOGIC;
        Key3Assigned : out STD_LOGIC;
        Key4Assigned : out STD_LOGIC;
        Key1Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key2Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key3Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key4Value : out STD_LOGIC_VECTOR (3 downto 0)
    );
end component SequentialKeyPressProcessor;

component comparator_final is
    port (
        comp1Complete : in std_logic;
        comp2Complete : in std_logic;
        comp3Complete : in std_logic;
        comp4Complete : in std_logic;
        match1comp : in std_logic;                           -- Signal indicating a match with the first password
        match2comp : in std_logic;                           -- Signal indicating a match with the second password
        match3comp : in std_logic;                           -- Signal indicating a match with the third password
        match4comp : in std_logic;                           -- Signal indicating a match with the fourth password
        clk : in std_logic;                                  -- Clock signal
        reset : in std_logic;                                -- Reset signal
        running_state : in std_logic;                         -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                         -- Signal indicating if any key is pressed
        s : out bit;                                   -- Signal indicating a successful comparison of the passwords
        r : out bit;                                   -- Signal indicating a failed comparison of the passwords
        processComplete : out std_logic                      -- Signal indicating completion of the process
    );
end component comparator_final;

component controller_fsm is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        running_state : in std_logic;
        processComplete : in std_logic;
        latchActive : out std_logic
    );
end component controller_fsm;

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
signal fk: STD_LOGIC_VECTOR (3 downto 0);
signal sk: STD_LOGIC_VECTOR (3 downto 0);
signal tk: STD_LOGIC_VECTOR (3 downto 0);
signal fourthk: STD_LOGIC_VECTOR (3 downto 0);
signal firstkey: std_logic;
signal secondley :std_logic;
signal pc : std_logic;
signal mc: std_logic;
signal mc2: std_logic;
signal mc3: std_logic;
signal mc4: std_logic;
signal lc: std_logic;
signal co1 : std_logic;
signal co2 : std_logic;
signal co3: std_logic;
signal co4 : std_logic;



begin

	
	C0: Decoder port map (running_state=>running,clk=>clk, Row =>JA(7 downto 4), Col=>JA(3 downto 0), DecodeOut=>Decode,keypressed=>akp,reset=>reset);
	C1: Comparator port map (clk=>clk,match1comp=>mc,reset=>reset,anykeypressed=>akp,running_state => running,nokey=>nk,firstkeypressed=>fk,comp1Complete => co1);
	C2: Comparator2 port map (clk=>clk,match2comp=>mc2,reset=>reset,anykeypressed=>akp,running_state => running,nokey=>nk,secondkeypressed=>sk,comp2Complete => co2);
	C3: Comparator3 port map (clk=>clk,match3comp=>mc3,reset=>reset,anykeypressed=>akp,running_state => running,nokey=>nk,thirdkeypressed=>tk,comp3Complete => co3);
	C4: Comparator4 port map (clk=>clk,match4comp=>mc4,reset=>reset,anykeypressed=>akp,running_state => running,nokey=>nk,fourthkeypressed=>fourthk,comp4Complete => co4);
	C5: Comparator_final port map (clk=>clk,match1comp=>mc,match2comp=>mc2,match3comp=>mc3,match4comp=>mc4,reset=>reset,s=>s_state,r=>r_state,running_state =>running,processcomplete=>pc,anykeypressed=>akp,comp1Complete => co1,comp2Complete => co2,comp3Complete => co3,comp4Complete => co4);
	C6: latch port map (s => s_state, r => r_state, clk => clk, reset => reset, correct => command_c, wrong => command_w,latch_active=>lc);
	C7: DisplayController port map (clk=>clk,correct=>command_c,wrong=>command_w,reset=>reset,anode=>an,segOut=>seg,buzzer=>buzzer,buzzerblue=>buzzblue,idle_state=>idle,nokey=>nk,buzzergreen=>buzzergreen);
    C8: myFSM port map (p=>p,running_state_sig=>running,clk=>clk,reset=>reset,idle_state_sig=>idle);
    C9: SequentialKeyPressProcessor port map (decodeout=>decode,Key1Assigned=>Led1,Key2Assigned=>Led2,key3assigned=>Led3,Key4assigned=>Led4,clk=>clk,reset=>reset,running_state=>running,Key1value=>fk,Key2value=>sk,key3value=>tk,key4value=>fourthk);
    C10:controller_fsm port map (running_state=>running,clk=>clk,reset=>reset,processcomplete=>pc,latchactive=>lc);

end Behavioral;
