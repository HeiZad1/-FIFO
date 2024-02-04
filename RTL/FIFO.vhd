library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all;

entity FIFO is
  generic (
        WIDE : natural := 1;
        DEEP  : natural := 1);
  port(
        H,rst,enable,R_W :std_logic;
        datain           :std_logic_vector(WIDE-1 downto 0);
        dataout          : out std_logic_vector(WIDE-1 downto 0);
        full,empty       : out std_logic);
end entity;


architecture Dflow of FIFO is
type memoire_fifo is array (0 to (2**DEEP)-1) of std_logic_vector (WIDE-1 downto 0);
signal shreg :memoire_fifo;
signal ld,u_d :std_logic;
signal cpt :std_logic_vector(DEEP downto 0);
signal mux :std_logic_vector(WIDE-1 downto 0);


begin
    
  u_d<= ( not R_W) and enable;
  cpt <= (others => '1') when rst = '1'
  else  cpt + '1'   when (u_d = '0' and H = '1' and H'event)
  else  cpt - '1'   when (u_d = '1' and H = '1' and H'event)
  else  cpt         when enable = '0';  
  
  ld <= R_W and enable;  
  shreg(0) <= (others => '0') when rst = '1'
  else datain when (ld = '1' and H = '1' and H'event );
  -- else shreg(0) when (ld = '0' );
  
  registres: for i in 1 to DEEP-1 generate
    shreg(i) <= (others => '0') when rst = '1'
    else shreg(i-1) when (ld = '1' and H = '1' and H'event );
    -- else shreg(i) when (ld = '0') ;
  end generate; 
  
  mux <= (shreg(conv_integer(cpt(DEEP - 1 downto 0))));
  dataout <= mux when R_W = '0'  else (others => 'Z') ;
  
  full <= '1' when cpt(DEEP) = '1' else '0'  ;
  empty<= '1' when conv_integer(cpt) = 0 else '0';
  
end architecture;
