library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity T_thermo is

end T_thermo;



architecture test of T_thermo is



component thermo

port (CLK         : in std_ulogic;
      
      RESET       : in std_ulogic; 
      
      Current_temp : in std_ulogic_vector(6 downto 0);

      Desired_temp : in std_ulogic_vector(6 downto 0);

      Display_sel  : in std_ulogic;
      
      COOL         : in std_ulogic;

      HEAT         : in std_ulogic;
      
      Furnace_hot  : in std_ulogic;
      
      AC_ready		: in std_logic;
      
      Temp_display	: out std_ulogic_vector(6 downto 0);
     
      AC_on        : out std_ulogic;

      Furnace_on	   : out std_ulogic;

      FAN_on           : out std_ulogic);

end component;

signal CLK, RESET: std_ulogic :='0';      

signal Current_temp, Desired_temp : std_ulogic_vector(6 downto 0);

signal Display_sel,COOL,HEAT,Furnace_hot,AC_ready : std_ulogic;

signal Temp_display : std_ulogic_vector(6 downto 0);

signal AC_on,Furnace_on,FAN_on   : std_ulogic;

begin

CLK <= not CLK after 50 ns; 
RESET <= '1', '0' after 100 ns;

UUT: thermo port map ( CLK => CLK,
            
                       RESET => RESET,

             Current_temp => Current_temp,

             Desired_temp => Desired_temp,

             Display_sel => display_sel,

             COOL => COOL,

             HEAT => HEAT,
             
             Furnace_hot => Furnace_hot, 
             
             AC_ready => AC_ready,
             
             Temp_display => Temp_display,
             
             AC_on =>  AC_on,

             Furnace_on => Furnace_on,
             
             FAN_on=> FAN_on );

                 
process -- no sensitivity list
begin
Current_temp <= "0101010"; --"0101010"
Desired_temp <= "1101110"; -- 1101110
COOL <= '0'; 
HEAT <= '0'; 
Furnace_hot <= '0'; 
AC_ready <= '0'; 
Display_sel <= '0'; 
wait for 200 ns;
Display_sel <= '1'; 
wait for 200 ns;
HEAT <= '1';
wait until Furnace_on = '1';
Furnace_hot <= '1';
wait until FAN_on = '1';
HEAT <= '0';
wait until Furnace_on = '0';
Furnace_hot <= '0';
wait for 200 ns;
HEAT <= '0';
wait for 500 ns;
Current_temp <= "1111111";
Desired_temp <= "0010010"; 
wait for 200 ns; 
COOL <= '1';  
wait until AC_on <= '1';
AC_ready <= '1';
wait until FAN_on = '1';
COOL <= '0'; 
AC_ready <= '0';
wait for 200 ns;
COOL <= '1';
wait; 
end process; 
end test;