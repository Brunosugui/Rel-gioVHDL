library ieee;

entity relogio is
    port(
        modo        : in bit;
        ajuste      : in bit;
        clock         : in bit;
        minuto      : out bit_vector(5 downto 0);
        hora        : out bit_vector(4 downto 0)
    );
end relogio;

architecture clock of relogio is

    component prsc_1_2_hz is
        port(
        clock       : in bit;
        modo        : in bit;
        ajuste      : in bit;
        out1hz      : out bit;
        out2hz      : out bit
    );
    end component;

    component minutos is
        port(
            clock           : in bit;
            segundos        : in bit;
            meio_segundos   : in bit;
            modo            : in bit;
            ajuste          : in bit;
            minuto          : out bit
    );
    end component;

    component horas is
        port(
            clock           : in bit;
            segundos        : in bit;
            minutos         : in bit;
            modo            : in bit;
            ajuste          : in bit;
            hora            : out bit
    );
    end component;

    signal meio_segundos, segundos            : bit;
    signal minutos, horas                     : bit;

    begin
        prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);
        conta_minutos : minutos port map(clock => clock, segundos => segundos, meio_segundos => meio_segundos, modo => modo, ajuste => ajuste, minuto => minutos);
        conta_horas   : horas port map(clock => clock, segundos => segundos, minutos => minutos, modo => modo, ajuste => ajuste, horas => horas);

    end clock;