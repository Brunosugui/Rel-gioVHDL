library ieee;
library workREL;
use workREL.all;

entity conta_horas is
    port(
        clock           : in bit;
        modo            : in bit;
        ajuste          : in bit;
        hora            : out bit
    );
    end conta_horas;

    architecture hours of conta_horas is

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

        signal meio_segundos, segundos, minutos        : bit := '0';
        signal count60                                 : integer range 0 to 59;

        --s0 = estado de contagem normal
        --s1 = contador de horas = contador de segundos
        type state_type is (s0, s1);
        
        signal fsm_state : state_type;

        begin
            prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);
            c_minutos : conta_minutos port map(clock => clock, modo => modo, ajuste => ajuste, minuto => minutos);
            

        process(segundos, minutos)
        begin
        if fsm_state = s0 then
            if minutos'event and minutos = '1' then
                if count60 = 59 then
                    count60 <= 0;
                else
                    count60 <= count60 + 1;
                end if;

                if count60 < 29 then
                    hora <= '0';
                else
                    hora <= '1';
                end if;
            end if;
        elsif fsm_state = s1 then
            hora <= segundos;
        end if;
        end process;

        process(ajuste, modo, fsm_state)
        begin
            case fsm_state is
                when s0 =>
                    if ajuste = '1' and modo = '0' then
                        fsm_state <= s1;
                    else
                        fsm_state <= s0;
                    end if;
                when s1 =>
                    if ajuste = '0' or (ajuste = '1' and modo = '1') then
                        fsm_state <= s0;
                    else
                        fsm_state <= s1;
                    end if;
            end case;

        end process;

    end hours;