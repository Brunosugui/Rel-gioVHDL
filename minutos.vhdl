library ieee;
library workREL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conta_minutos is
    port(
        segundos        : in bit;
        meio_segundos   : in bit;
        modo            : in bit;
        ajuste          : in bit;
        minuto          : out bit
    );
end conta_minutos;

architecture minutes of conta_minutos is

    constant maxSegundos  :   Integer     :=  60;

    signal count60                  :integer range 0 to (maxSegundos - 1) := 0;

    type state_type is (s0, s1);
        
    signal fsm_state : state_type;

    begin

        process(fsm_state, segundos, meio_segundos)
            begin
            if fsm_state = s0 then
                if segundos'event and segundos = '1' then
                    if count60 = 59 then
                        count60 <= 0;
                    else
                        count60 <= count60 + 1;
                    end if;

                    if count60 < 29 then
                        minuto <= '0';
                    else
                        minuto <= '1';
                    end if;
                end if;
            elsif fsm_state = s1 then
                if meio_segundos'event then
                    count60 <= 0;
                    if meio_segundos = '1' then
                        minuto <= '1';
                    else 
                        minuto <= '0';
                    end if;
                end if;            
            end if;
            end process;

        process(ajuste, modo, fsm_state)
        begin
            case fsm_state is
                when s0 =>
                    if ajuste = '1' and modo = '1' then
                        fsm_state <= s1;
                    else
                        fsm_state <= s0;
                    end if;
                when s1 =>
                    if ajuste = '0' or (ajuste = '1' and modo = '0') then
                        fsm_state <= s0;
                    else
                        fsm_state <= s1;
                    end if;
                end case;
        end process;

    
    end minutes;
