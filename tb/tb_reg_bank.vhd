library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_reg_bank is
end tb_reg_bank;

architecture sim of tb_reg_bank is
    signal clk              : std_logic := '0';
    signal rst              : std_logic := '0';
    signal wr_en            : std_logic := '0';
    signal wr_address       : std_logic_vector(3 downto 0) := (others => '0');
    signal wr_data          : std_logic_vector(7 downto 0) := (others => '0');   
    signal rd_en            : std_logic := '0';
    signal rd_address       : std_logic_vector(3 downto 0) := (others => '0'); 
    signal rd_data          : std_logic_vector(7 downto 0) := (others => '0');

    signal expected_data    : std_logic_vector(7 downto 0);

    constant clk_period : time := 20 ns; -- 50MHz

    -- 0   => x"32"        -- Read Only
    -- 1   => x"30"        -- Read Only
    -- 2   => x"31"        -- Read Only
    -- 3   => x"37"        -- Read Only    
    -- 4   => x"30"        -- Read Only
    -- 5   => x"39"        -- Read Only
    -- 6   => x"06"        -- Read / Write
    -- 7   => x"07"        -- Read / Write    
    -- 8   => x"08"        -- Read / Write
    -- 9   => x"09"        -- Read / Write
    -- 10  => x"0A"        -- Read / Write
    -- 11  => x"FF"        -- Read / Write
    -- 12  => x"FF"        -- Read / Write
    -- 13  => x"FF"        -- Read / Write
    -- 14  => x"FF"        -- Read / Write
    -- 15  => x"FF"        -- Read / Write

begin
    
    clk_process : process
    begin
    
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    
    end process;

    DUT : entity work.reg_bank
        port map (
            clk        => clk,
            rst        => rst,
            wr_en      => wr_en,
            wr_address => wr_address,
            wr_data    => wr_data,   
            rd_en      => rd_en,
            rd_address => rd_address,
            rd_data    => rd_data
        );

    stim_proc : process
    begin

        -- reset
        wait for 100 ns;
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- ler read only
        wait for 100 ns;
        rd_en <= '1';
        rd_address <= "0000"; -- Endereço 0
        wait for clk_period;
        expected_data <= x"32";
        wait for clk_period;
        assert (rd_data = expected_data)
        report "erro no endereço 0"
        severity error;
        rd_en <= '0';

        -- escrever read only
        wait for 100 ns;
        wr_en <= '1';
        wr_address <= "0001"; -- Endereço 1
        wr_data <= x"AA";
        wait for clk_period;
        wr_en <= '0';
        rd_en <= '1';
        rd_address <= "0001"; -- Endereço 1
        wait for clk_period;
        expected_data <= x"30";
        assert (rd_data = expected_data)
        report "erro no endereco 1, possivel sobrescricao"
        severity error;
        rd_en <= '0';

        -- escrita e leitura em read/write
        wait for 100 ns;
        wr_en <= '1';
        wr_address <= "0110"; -- Endereço 6
        wr_data <= x"55";
        wait for clk_period;
        wr_en <= '0';
        rd_en <= '1';
        rd_address <= "0110"; -- Endereço 6
        wait for clk_period;
        expected_data <= x"55";
        assert (rd_data = expected_data)
        report "erro no endereco 6"
        severity error;
        rd_en <= '0';

        wait for 100 ns;
        assert false report "fim" severity note;
        wait;
    end process;
end sim;
