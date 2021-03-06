library ieee;
library workREL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prsc_1_2_hz is
    port(
        clock       : in bit;
        out1hz      : out bit;
        out2hz      : out bit
    );
    end prsc_1_2_hz;

architecture arch of prsc_1_2_hz is
    --constant freq  :   Integer     :=  32768;
    constant freq  :   Integer     :=  4;
    signal count1hz          : integer range 0 to freq := 0;
    signal count2hz          : integer range 0 to freq/2 := 0;

    begin
        process(clock)
        begin
            if clock'event and clock = '1' then
                if count1hz = (freq - 1) then
                    count1hz <= 0;
                    out1hz <= '1';
                else
                    count1hz <= count1hz + 1;
                    out1hz <= '0';
                end if;

                if count2hz = (freq/2 - 1) then
                    count2hz <= 0;
                    out2hz <= '1';
                else
                    count2hz <= count2hz + 1;
                    out2hz <= '0';
                end if;
            end if;

        end process;
        


    end arch;