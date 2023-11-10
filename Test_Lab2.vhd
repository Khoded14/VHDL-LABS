entity T_thermo is 
end T_thermo; 

architecture test of T_thermo is 

component thermo
port (current_temp : in bit_vector(6 downto 0); 
      desired_temp : in bit_vector(6 downto 0); 
      display_sel  : in bit; 
      COOL         : in bit; 
      HEAT         : in bit;
      AC_ON        : out bit; 
      Furnace_ON   : out bit; 
      display_temp : out bit_vector(6 downto 0));
end component;
      
signal current_temp, desired_temp : bit_vector(6 downto 0);
signal display_temp : bit_vector(6 downto 0);
signal display_sel,COOL,HEAT : bit;
signal AC_ON,Furnace_ON  : bit;

begin
UUT: thermo port map (current_temp => current_temp,
             desired_temp => desired_temp, 
             display_sel => display_sel,
             COOL => COOL,
             HEAT => HEAT,
             AC_ON =>  AC_ON, 
             Furnace_ON => Furnace_ON, 
             display_temp => display_temp);
                         
process -- no sensitivity list
begin
current_temp <= "1010101"; 
desired_temp <= "0101010"; 
display_sel  <= '0';
COOL <= '1';
HEAT <= '0'; 
wait for 200 ns;
display_sel <= '1';
COOL <= '0';
HEAT <= '1';
wait for 200 ns;
display_sel  <= '0';
COOL <= '1';
HEAT <= '1'; 
wait for 200 ns;
display_sel <= '1';
COOL <= '0';
HEAT <= '0';
wait for 200 ns;
display_sel  <= '0';
COOL <= '1';
HEAT <= '0';
wait for 200 ns;
wait; 
end process;
end test; 