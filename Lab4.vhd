-- Incorporating a state machine into the thermostat
-- Adding new inputs to the state machine such as Furnace_hot and  AC_ready
-- Registering the inputs with a clocked process 
-- IDLE, HEATON, FURNACE_NOW_HOT, FURNACE_COOL,COOLON, AC_NOW_READY, AC_DONE is the state machine in the entire thermostat 
--
 
library IEEE; 
USE IEEE.STD_LOGIC_1164.all; 
entity thermo is 

port(CLK 		: in std_ulogic;
     RESET		: in std_ulogic;
     Current_temp       : in std_ulogic_vector(6 downto 0); 
     Desired_temp	: in std_ulogic_vector(6 downto 0); 
     Display_sel        : in std_ulogic; 
     COOL		: in std_ulogic;
     HEAT               : in std_ulogic; 
     Furnace_hot	: in std_ulogic; 
     AC_ready		: in std_logic;
     Temp_display	: out std_ulogic_vector(6 downto 0);
     AC_on		: out std_ulogic;
     Furnace_on		: out std_ulogic; 
     FAN_on             : out std_ulogic); 
end thermo;

architecture RTL of thermo is 
signal Current_temp_reg :  std_ulogic_vector(6 downto 0);
signal Desired_temp_reg :  std_ulogic_vector(6 downto 0);
signal Display_sel_reg  :  std_ulogic;
signal COOL_reg         :  std_ulogic;
signal HEAT_reg         :  std_ulogic;
signal Furnace_hot_reg  :  std_ulogic;
signal AC_ready_reg     :  std_ulogic;

type IO_FSM_STATE is(IDLE, HEATON, FURNACE_NOW_HOT, FURNACE_COOL,COOLON, AC_NOW_READY, AC_DONE);
                                             
signal CURRENT_STATE, NEXT_STATE : IO_FSM_STATE; 
begin

process(CLK,RESET)
begin
if RESET = '1' then 
CURRENT_STATE <= IDLE; 
elsif CLK'event and CLK = '1' then
CURRENT_STATE <= NEXT_STATE; 
end if; 
end process; 
-- Registering all the inputs of the state machine
     
process(CLK) begin
if CLK'event and CLK = '1' then
Current_temp_reg <= Current_temp;
Desired_temp_reg <= Desired_temp; 
Display_sel_reg <= Display_sel; 
COOL_reg <= COOL; 
HEAT_reg <= HEAT; 
Furnace_hot_reg <= Furnace_hot; 
AC_ready_reg <= AC_ready;
end if; 
end process; 

process(CLK)
begin 
if CLK'event and CLK = '1' then
    if Display_sel_reg = '1' then 
        Temp_display <= Current_temp; 
    else 
        Temp_display <= Desired_temp;
    end if;
end if;
end process;

-- Adding the state types to the state machine
     
process(CURRENT_STATE,Current_temp_reg, Desired_temp_reg,HEAT_reg,COOL_reg,Furnace_hot_reg,AC_ready_reg)
begin 
case CURRENT_STATE is 
when IDLE => 
if(Current_temp_reg< Desired_temp_reg  and HEAT_reg = '1' and COOL_reg = '0') then 
NEXT_STATE <= HEATON; 
elsif(Current_temp_reg> Desired_temp_reg and HEAT_reg ='0' and COOL_reg = '1') then 
NEXT_STATE <= COOLON; 
else
NEXT_STATE <= IDLE;
end if; 

when HEATON => 
if(Furnace_hot_reg = '1') then 
NEXT_STATE <= FURNACE_NOW_HOT; 
else
NEXT_STATE <= HEATON;
end if; 

when FURNACE_NOW_HOT => 
if (not(Current_temp_reg < Desired_temp_reg  and HEAT_reg = '1' and COOL_reg = '0')) then 
NEXT_STATE <= FURNACE_COOL; 
else 
NEXT_STATE <= FURNACE_NOW_HOT; 
end if; 

when FURNACE_COOL => 
if (Furnace_hot_reg = '0') then 
NEXT_STATE <= IDLE; 
else 
NEXT_STATE <= FURNACE_COOL; 
end if;  


when COOLON => 
if(AC_ready_reg = '1') then 
NEXT_STATE <= AC_NOW_READY; 
else 
NEXT_STATE <= COOLON; 
end if; 

when AC_NOW_READY => 
if(not(Current_temp_reg> Desired_temp_reg and HEAT_reg ='0' and COOL_reg = '1')) then 
NEXT_STATE <= AC_DONE; 
else 
NEXT_STATE <= AC_NOW_READY; 
end if; 

when AC_DONE => 
if(AC_ready_reg = '0') then 
NEXT_STATE <= IDLE; 
else 
NEXT_STATE <= AC_DONE; 
end if;

when others => 
NEXT_STATE <= IDLE;  
end case;
end process;

-- Registering the output of the state machine with a clock 
process(CLK)
begin
if(CLK'event and CLK = '1') then 
    if NEXT_STATE = HEATON  or NEXT_STATE = FURNACE_NOW_HOT then 
    Furnace_on <= '1'; 
    else 
    Furnace_on <= '0';
    end if; 
    if NEXT_STATE = COOLON or NEXT_STATE = AC_NOW_READY then 
    AC_on <= '1'; 
    else 
    AC_on <= '0';
    end if; 
    if NEXT_STATE = FURNACE_NOW_HOT or NEXT_STATE = AC_NOW_READY or 
       NEXT_STATE = FURNACE_COOL or NEXT_STATE = AC_DONE then 
    FAN_on <= '1'; 
    else 
    FAN_on <= '0';
    end if; 
end if; 
end process;
end RTL;
