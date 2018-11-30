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

    component conta_minutos is
        port(
            clock           : in bit;
            modo            : in bit;
            ajuste          : in bit;
            minuto          : out bit
    );
    end component;

    component conta_horas is
        port(
            clock           : in bit;
            modo            : in bit;
            ajuste          : in bit;
            hora            : out bit
    );
    end component;

    signal meio_segundos, segundos            : bit;
    signal minutos, horas                     : bit;
    variable minutos_aux, horas_aux           : integer;


    begin
        prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);
            c_minutos : conta_minutos port map(clock => clock, modo => modo, ajuste => ajuste, minuto => minutos);
            c_horas   : conta_horas port map(clock => clock, modo => modo, ajuste => ajuste, horas => horas);

            hora <= to_unsigned(hora_aux);
            minuto <= to_unsigned(minutos_aux);
        
        process(horas, minutos)
        begin
            if horas'event and horas = '1' then
                if horas_aux = 32 then
                    horas_aux := 0;
                else
                    horas_aux := horas_aux + 1;
                end if;
            end if;

            if minutos'event and minutos = '1' then
                if minutos_aux = 64 then
                    minutos_aux := 0;
                else
                    minutos_aux := minutos_aux + 1;
                end if;
            end if;
        end process;

    end clock;