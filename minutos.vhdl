library ieee;
library workREL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conta_minutos is
    port(
        clock           : in bit;
        modo            : in bit;
        ajuste          : in bit;
        minuto          : out bit
    );
end conta_minutos;

architecture minutes of conta_minutos is

    constant maxSegundos  :   Integer     :=  60;

    component prsc_1_2_hz is
        port(
        clock       : in bit;
        modo        : in bit;
        ajuste      : in bit;
        out1hz      : out bit;
        out2hz      : out bit
    );
    end component;

    signal count60                  :integer range 0 to (maxSegundos - 1) := 0;
    signal seconds, half_seconds    : bit;

    type state_type is (s0, s1);
        
    signal fsm_state : state_type;

    begin
        prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => seconds, out2hz => half_seconds);

        process(fsm_state, seconds, half_seconds)
            begin
            if fsm_state = s0 then
                if seconds'event and seconds = '1' then
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
                minuto <= half_seconds;
                count60 <= 0;
            end if;
            end process;

        process(ajuste, modo, half_seconds)
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
