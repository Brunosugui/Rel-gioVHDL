library ieee;

entity minutos is
    port(
        clock           : in bit;
        segundos        : in bit;
        meio_segundos   : in bit;
        modo            : in bit;
        ajuste          : in bit;
        minuto          : out bit
    );
end minutos;

architecture minutes of minutos is

    component prsc_1_2_hz is
        port(
        clock       : in bit;
        modo        : in bit;
        ajuste      : in bit;
        out1hz      : out bit;
        out2hz      : out bit
    );
    end component;

    signal count60        :integer range 0 to 59;

    begin
        prescaler_1_2 : prsc_1_2_hz port map(clock => clock, modo => modo, ajuste => ajuste, out1hz => segundos, out2hz => meio_segundos);

        process(segundos, meio_segundos)
        begin
            if ajuste = '1' then
                if modo = '1' then
                    if meio_segundos'event then
                        minuto <= meio_segundos;
                        count60 <= 0;
                    end if;
                else
                    if count60 = 59 then
                        count60 <= 0;
                    else
                        count60 <= count60 + 1;
                    end if;
                end if;
            else
                if count60 = 59 then
                    count60 <= 0;
                else
                    count60 <= count60 + 1;
                end if; 
            end if;
        end process;

        process(count60)
        begin
            if count60 < 29 then
                minuto <= 0;
            else
                minuto <= 1;
            end if;
        end process;

    
    end minutes;
