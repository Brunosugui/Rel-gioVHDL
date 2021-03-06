library ieee;
library workREL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conta_horas is
    port(
        segundos        : in bit;
        minutos         : in bit;
        modo            : in bit;
        ajuste          : in bit;
        hora            : out bit
    );
    end conta_horas;

    architecture hours of conta_horas is

        constant maxMinutos  :   Integer     :=  60;
        
        signal count60                                 : integer range 0 to (maxMinutos - 1) := 0;

        --s0 = estado de contagem normal
        --s1 = contador de horas = contador de segundos
        type state_type is (s0, s1);
        
        signal fsm_state : state_type;

        begin            
        process(segundos, minutos)
        begin
        if fsm_state = s0 then
            if minutos'event and minutos = '1' then
                if count60 = (maxMinutos - 1) then
                    count60 <= 0;
                    hora <= '1';
                else
                    count60 <= count60 + 1;
                    hora <= '0';
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