library ieee;

entity prsc_1_2_hz is
    port(
        clock       : in bit;
        modo        : in bit;
        ajuste      : in bit;
        out1hz      : out bit;
        out2hz      : out bit
    );
    end prsc_1_2_hz;

package frequency is
    constant f      : integer;
end frequency;

package body frequency is
    constant f      : integer := 32768;
end frequency;


architecture arch of prsc_1_2_hz is
    signal count1hz          : integer range 0 to f := 0;
    signal count2hz          : integer range 0 to f/2 := 0;

    begin
        process(clock, ajuste, modo)
        begin
            if clock'event and clock = '1' then
                if count1hz = f then
                    count1hz <= 0;
                else
                    count1hz <= count1hz + 1
                end if;

                if count2hz = f/2 then
                    count2hz <= 0;
                else
                    count2hz <= count2hz + 1;
                end if;
            end if;
            if ajuste = '1' and modo = '1' then
                count1hz <= 0;
                count2hz <= 0;
            end if;
        end process;
        

        process(count1hz)
        begin
            if count1hz < f/2 then
                out1hz <= '0';
            else
                out1hz <= '1';
            end if;
        end process;


        process(count2hz)
        begin
            if count2hz < f/4 then
                out2hz <= '0';
            else
                out2hz <= '1';
            end if;
        end process;

    end arch;
