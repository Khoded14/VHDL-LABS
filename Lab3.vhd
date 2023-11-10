entity thermo is

port (current_temp : in bit_vector(6 downto 0);
      desired_temp : in bit_vector(6 downto 0);
      display_sel  : in bit;
      COOL         : in bit;
      HEAT         : in bit;
      CLK          : in bit; 
      --RESET        : in bit; 
      AC_ON        : out bit;
      Furnace_ON   : out bit;
      display_temp : out bit_vector(6 downto 0));

end thermo;
-- The entity 
architecture test of thermo is

signal reg_current_temp : bit_vector(6 downto 0); 
signal reg_desired_temp : bit_vector(6 downto 0);
signal reg_display_sel  : bit;
signal reg_COOL         : bit;
signal reg_HEAT         : bit; 
begin
 

process(CLK)
begin 
if CLK'event and CLK = '1' then 
reg_current_temp <= current_temp; 
reg_desired_temp <= desired_temp; 
reg_display_sel  <= display_sel; 
reg_COOL <= COOL; 
reg_HEAT <= HEAT; 
end if; 
end process; 

process(CLK)
begin
if CLK'event and CLK = '1' then
    if reg_display_sel = '1'  then
        display_temp <= reg_current_temp; 
    else
        display_temp <= reg_desired_temp;
    end if;  
end if;
end process; 

process(CLK)  
begin 
if CLK'event and CLK = '1' then 
   if (reg_current_temp > reg_desired_temp and reg_COOL = '1' and reg_HEAT = '0') then
    AC_ON <= '1';
    Furnace_ON <= '0'; 
   elsif(reg_current_temp < reg_desired_temp and reg_HEAT = '1' and reg_COOL = '0' ) then
    Furnace_ON <= '1';
    AC_ON <= '0';
   elsif(reg_HEAT = '1' and reg_COOL = '1') then 
    Furnace_ON <= '0';
    AC_ON <= '0';
   else 
    Furnace_ON <= '0';
    AC_ON <= '0';
    end if;   
end if; 
end process; 
end test; 
