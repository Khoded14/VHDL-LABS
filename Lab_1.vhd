-- Code 
-- This is the code of a simple thermo controller 
entity thermo is 
port (current_temp : in bit_vector(6 downto 0); 
      desired_temp : in bit_vector(6 downto 0); 
      display_sel  : in bit; 
      display_temp : out bit_vector(6 downto 0)); 

end thermo; 

architecture test of thermo is 
begin 

process(current_temp,desired_temp,display_sel)
begin 

if display_sel = '1' then 
display_temp <= current_temp; 

else 
display_temp <= desired_temp; 

end if; 
end process; 
end test; 
