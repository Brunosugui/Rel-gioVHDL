library ieee;
library workREL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relogio is
    port(
        modo        : in bit;
        ajuste      : in bit;
        clock       : in bit;
        minuto      : out std_logic_vector(5 downto 0);
        hora        : out std_logic_vector(4 downto 0)
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
        segundos        : in bit;
        meio_segundos   : in bit;
        modo            : in bit;
        ajuste          : in bit;
        minuto          : out bit
    );
    end component;

    component conta_horas is
        port(
        segundos        : in bit;
        minutos         : in bit;
        modo            : in bit;
        ajuste          : in bit;
        hora            : out bit
    );
    end component;

    signal meio_segundos, segundos            : bit;
    signal minutos, horas                     : bit;
    signal minutos_aux                      : integer range 0 to 59;
    signal horas_aux                        : integer range 0 to 23;


    begin
        prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);
            c_minutos : conta_minutos port map(segundos => segundos, meio_segundos => meio_segundos, modo => modo, ajuste => ajuste, minuto => minutos);
            c_horas   : conta_horas port map(segundos => segundos, minutos => minutos, modo => modo, ajuste => ajuste, hora => horas);

            hora <= std_logic_vector(to_unsigned(horas_aux, hora'length));
            minuto <= std_logic_vector(to_unsigned(minutos_aux, minuto'length));
            
        
        process(horas, minutos)
        begin
            if horas'event and horas = '1' then
                if horas_aux = 23 then
                    horas_aux <= 0;
                else
                horas_aux <= horas_aux + 1;
                end if;
            end if;

            if minutos'event and minutos = '1' then
                if minutos_aux = 59 then
                    minutos_aux <= 0;
                else
                minutos_aux <= minutos_aux + 1;
                end if;
            end if;
        end process;

    end clock;