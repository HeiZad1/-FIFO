library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all;

entity test is
end entity;

architecture bench of test is
component oper is
   generic (
        WIDE : natural := 1;
        DEEP  : natural := 1);
  port(
        H,rst,enable,R_W :std_logic;
        datain           :std_logic_vector(WIDE-1 downto 0);
        dataout          : out std_logic_vector(WIDE-1 downto 0);
        full,empty       : out std_logic);
end component;

constant      DEEP                : natural := 8;
constant      WIDE                : natural := 8;
signal        full,empty          : std_logic; 
signal        datain,dataout      : std_logic_vector(N-1 downto 0);       
signal        H,rst,enable,R_W    : std_logic;


for UUT :oper use entity work.oper(RTL);
  
begin
  UUT:oper  generic map (DEEP=>DEEP,WIDE=>WIDE) 
            port map (H=>H,rst=>rst,enable=>enable,R_W=>R_W
                      datain=>datain,dataout=>dataout,
                      full=>full,empty=>empty);
  rst <= '0' ,'1' after 5 ns ,'0' after 10 ns;
  
  
  
  
end architecture; 
