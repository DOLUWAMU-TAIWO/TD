entity HA is     --is for declaring inputs and outputs
       port (a:in bit;  -- declaration of a input
             b: in bit; --decalaration of b input
             s: out bit; --declaration of s output
             co: out bit); --declaration of co output
end entity; 

Architecture Behavioural of HA is -- for functional part of code 
begin 
--this is a half adder
s <= a xor b;
co <= a and b;
 end behavioural;
