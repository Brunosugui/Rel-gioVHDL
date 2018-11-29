library ieee;

entity horas is
    port(
        clock           : in bit;
        segundos        : in bit;
        minutos         : in bit;
        modo            : in bit;
        ajuste          : in bit;
        hora            : out bit
    );
    end horas;

    architecture hours of horas is

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

        signal meio_segundos        : bit;
        signal count60              : integer range 0 to 59;

        begin
            prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);
            conta_minutos : minutos port map(clock => clock, segundos => segundos, meio_segundos => meio_segundos, modo => modo, ajuste => ajuste, minuto => minutos);

        process(segundos, minutos)
        if segundos'event then
            if ajuste = '1' then
                if modo = '0' then
                    hora <= segundos;
                else
                    if minutos'event and minutos = '1' then
                        if count60 = 59 then
                            count60 <= 0;
                        else
                            count60 <= count60 + 1;
                        end if;
                    end if;
                end if;
            else
                if minutos'event and minutos = '1' then
                    if count60 = 59 then
                        count60 <= 0;
                    else
                        count60 <= count60 + 1;
                    end if;
                end if;
            end if;
        end if;
        end process;

        process(count60)
        begin
            if count60 < 29 then
                horas <= '0';
            else
                horas <= '1';
            end if;
        end process;

    end hours;