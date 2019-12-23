library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR (7 downto 0));
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           r0_load : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           d_sel : in STD_LOGIC;
           o_end : out STD_LOGIC);
end component;
signal r0_load : STD_LOGIC;
signal r1_load : STD_LOGIC;
signal d_sel : STD_LOGIC;
signal o_end : STD_LOGIC;
type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13);
signal cur_state, next_state : S;
begin
    DATAPATH0: datapath port map(
        i_clk,
        i_rst,
        i_data,
        o_data,
        r0_load,
        r1_load,
        d_sel,
        o_end
    );
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start, o_end)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S3;
                end if;
            when S3 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S4;
                end if;
            when S4 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S5;
                end if;
            when S5 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S6;
                end if;
            when S6 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S7;
                end if;
            when S7 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S8;
                end if;
            when S8 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S9;
                end if;
            when S9 =>
                if o_end = '1' then
                    next_state <= S11;
                else
                    next_state <= S10;
                end if;
            when S10 =>
                next_state <= S12;
            when S11 =>
                next_state <= S12;
            when S12 =>
                if i_start = '0' then
                    next_state <= S0;
                end if;
        end case;
    end process;
    
    process(cur_state)
    begin
        r0_load <= '0';
        r1_load <= '0';
        d_sel <= '0';
        o_address <= "0000000000000000";
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        case cur_state is
            when S0 =>
                o_address <= "0000000000001000";
                o_en <= '1';
            when S1 =>
                o_address <= "0000000000000000";
                o_en <= '1';
                r0_load <= '1';
            when S2 =>
                o_address <= "0000000000000001";
                o_en <= '1';
                r1_load <= '1';
            when S3 =>
                o_address <= "0000000000000010";
                o_en <= '1';
                r1_load <= '1';
            when S4 =>
                o_address <= "0000000000000011";
                o_en <= '1';
                r1_load <= '1';
            when S5 =>
                o_address <= "0000000000000100";
                o_en <= '1';
                r1_load <= '1';
            when S6 =>
                o_address <= "0000000000000101";
                o_en <= '1';
                r1_load <= '1';
            when S7 =>
                o_address <= "0000000000000110";
                o_en <= '1';
                r1_load <= '1';
            when S8 =>
                o_address <= "0000000000000111";
                o_en <= '1';
                r1_load <= '1';
            when S9 =>
            when S10 =>
                o_address <= "0000000000001001";
                o_en <= '1';
                o_we <= '1';
                d_sel <= '0';
            when S11 =>
                o_address <= "0000000000001001";
                o_en <= '1';
                o_we <= '1';
                d_sel <= '1';
            when S12 =>
                o_done <= '1';
        end case;
    end process;
    
end Behavioral;
