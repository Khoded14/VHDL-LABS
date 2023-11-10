-- Adding other functions in the Thermocooler 
--  add the functionality of controlling the A_C_ON and the FURNACE_ON outputs with the added input COOL and HEAT. 
entity thermo is 
port (current_temp : in bit_vector(6 downto 0); 
      desired_temp : in bit_vector(6 downto 0); 
      display_sel  : in bit; 
      COOL         : in bit; 
      HEAT         : in bit;
      AC_ON        : out bit; 
      Furnace_ON   : out bit; 
      display_temp : out bit_vector(6 downto 0)); 

end thermo; 

architecture test of thermo is 
begin 
process(current_temp,desired_temp,display_sel,COOL,HEAT) 
begin 

if display_sel = '1' then 
display_temp <= current_temp; 
else 
display_temp <= desired_temp;
end if; 
-- Other Bits added to it
if ((current_temp) > (desired_temp) and COOL = '1' and HEAT = '0') then
 AC_ON <= COOL; 
 Furnace_ON <= HEAT; 
elsif((current_temp) < (desired_temp) and HEAT = '1' and COOL = '0') then
Furnace_ON <= HEAT; 
AC_ON <= COOL;
elsif(HEAT = '1' and COOL = '1') then
AC_ON <= '0'; 
Furnace_ON <= '0';
else 
AC_ON <= COOL;
Furnace_ON <= HEAT;
end if; 
end process; 
end test;







