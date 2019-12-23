library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           r0_load : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           sel : in STD_LOGIC;
           o_end : out STD_LOGIC);
end datapath;

architecture Behavioral of datapath is
signal o_reg0 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg1 : STD_LOGIC_VECTOR (2 downto 0);
signal sum : STD_LOGIC_VECTOR(2 downto 0);
signal dec : STD_LOGIC_VECTOR(3 downto 0);
signal sub : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg0 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r0_load = '1') then
                o_reg0 <= i_data;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg1 <= "000";
        elsif i_clk'event and i_clk = '1' then
            if(r1_load = '1') then
                o_reg1 <= sum;
            end if;
        end if;
    end process;
    
    sum <= o_reg1 + "001";
    
    with sel select
        o_data <= o_reg0 when '0',
                  '1' & (o_reg1 - "001") & dec when '1',
                  "XXXXXXXX" when others;
    
    with sub(1 downto 0) select
        dec <= "0001" when "00",
               "0010" when "01",
               "0100" when "10",
               "1000" when "11",
               "XXXX" when others;
    
    sub <= o_reg0 - i_data;
    
    o_end <= '1' when ((sub(7) or sub(6) or sub(5) or sub(4) or sub(3) or sub(2)) = '0') else '0';

end Behavioral;
