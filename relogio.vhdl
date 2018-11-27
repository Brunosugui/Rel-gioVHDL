library ieee;

entity relogio is
    port(
        modo        : in bit;
        ajuste      : in bit;
        clk         : in bit;
        minuto      : out bit_vector(5 downto 0);
        hora        : out bit_vector(4 downto 0)
    )
end relogio;

architecture clock of relogio is
    begin

    end clock;