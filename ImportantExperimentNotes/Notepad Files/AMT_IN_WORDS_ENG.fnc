CREATE OR REPLACE FUNCTION AMT_IN_WORDS_ENG ( P_TOT_AMT FLOAT, P_TRANSACTION_CURR VARCHAR2) 
RETURN VARCHAR2 
IS
    InvalidNumberFormatModel EXCEPTION;
    PRAGMA EXCEPTION_INIT(InvalidNumberFormatModel,-1481);
    InvalidNumber EXCEPTION;
    PRAGMA EXCEPTION_INIT(InvalidNumber,-1722);

    TYPE GroupTableType IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

    ConversionType CHAR(6) := '';
    GroupTable GroupTableType;
    GroupIndex NUMBER;
    Words VARCHAR2(2000);
    WholePart NUMBER;
    FractionalPart NUMBER;
    FractionalDigits NUMBER;
    Remainder NUMBER;
    Remainder1 NUMBER;
    Remainder2 NUMBER;
    Suffix VARCHAR2(50);
    NumberIN FLOAT;

    v_curnc VARCHAR2(30);
BEGIN
    GroupTable(0) := '';
    GroupTable(1) := ' ten';
    GroupTable(2) := ' hundred';
    GroupTable(3) := ' thousand';
    GroupTable(4) := ' ten thousand';
    GroupTable(5) := ' lakh ';
    GroupTable(6) := ' ten lakh ';
    GroupTable(7) := ' crore ';
    GroupTable(8) := ' ten crore ';
    GroupTable(9) := ' hundred crore ';
    GroupTable(10) := ' thousand crore ';
    GroupTable(11) := ' ten thousand crore ';
    GroupTable(12) := ' lakh crore ';
    GroupTable(13) := ' ten lakh crore ';
    GroupTable(14) := ' hundred lakh crore ';
    GroupTable(15) := ' thousand lakh crore ';
    GroupTable(16) := ' ten thousand lakh crore ';
    GroupTable(17) := ' lakh lakh crore ';
    GroupTable(18) := ' ten lakh lakh crore ';
    GroupTable(19) := ' crore crore ';

    v_curnc := P_TRANSACTION_CURR;
    NumberIN := P_TOT_AMT;

    WholePart := ABS(TRUNC(NumberIN)); -- Calculate whole and fractional parts
    FractionalPart := ABS(NumberIN) - WholePart;

    IF v_curnc = 'BDT' THEN -- Change from INR to BDT
        IF FractionalPart = 0 THEN -- Check if fractional part is 0
            Words := null;--'zero poisha';
            Suffix := null;--' and ';
        ELSE
            IF ConversionType = 'N' THEN
                FractionalDigits := LENGTH(TO_CHAR(FractionalPart)) - 1;
                IF FractionalDigits > 15 THEN
                    RAISE InvalidNumber;
                END IF;
                Suffix := GroupTable(FractionalDigits) || 'th';
                FractionalPart := FractionalPart * POWER(10,FractionalDigits);
            ELSE
                IF LENGTH(TO_CHAR(FractionalPart)) > 3 THEN
                    RAISE InvalidNumber;
                END IF;
                FractionalPart := FractionalPart * 100;
                IF FractionalPart = 1 THEN
                    Suffix := ' Poisha';
                ELSE
                    Suffix := ' Poisha';
                END IF;
            END IF;

            IF FractionalPart <= 99999 THEN
                Words := TO_CHAR(TO_DATE(FractionalPart,'j'),'Jsp') || Suffix;
            ELSE
                GroupIndex := 0;
                WHILE FractionalPart != 0 LOOP
                    Remainder := MOD(FractionalPart,1000);
                    IF Remainder != 0 THEN
                        Words := TO_CHAR(TO_DATE(Remainder,'j'),'Jsp') || GroupTable(GroupIndex) || Words;
                    END IF;
                    GroupIndex := GroupIndex + 3;
                    FractionalPart := TRUNC(FractionalPart / 1000);
                END LOOP;
                Words := Words || Suffix;
            END IF;
            Suffix := ' & ';
        END IF;

        IF WholePart = 0 THEN
            IF ConversionType = '' THEN
                Words := 'zero ' || Suffix || Words;
            ELSE
                Words := 'zero' || Suffix || Words;
            END IF;
        ELSE
            IF WholePart = 1 THEN
                Suffix := ' Taka' || Suffix;
            ELSE
                Suffix := '' || Suffix;
            END IF;
            IF WholePart <= 99999 THEN
                Words := TO_CHAR(TO_DATE(WholePart,'J'),'Jsp') || Suffix || Words;
            ELSE
                IF LENGTH(TO_CHAR(WholePart)) > 15 THEN
                    RAISE InvalidNumber;
                END IF;
                GroupIndex := 0;
                Words := Suffix || Words;
                WHILE WholePart != 0 LOOP
                    IF WholePart < 10000000 THEN
                        Remainder := MOD(WholePart,100000);
                        IF Remainder != 0 THEN
                            Words := TO_CHAR(TO_DATE(Remainder,'j'),'Jsp') || GroupTable(GroupIndex) || Words;
                        END IF;
                        GroupIndex := GroupIndex + 5;
                        WholePart := TRUNC(WholePart / 100000);
                    ELSE
                        Remainder := MOD(WholePart,10000000);
                        IF Remainder != 0 THEN
                            IF Remainder >= 100000 THEN
                                Remainder2 := MOD(Remainder,100000);
                                Words := TO_CHAR(TO_DATE(Remainder2,'j'),'Jsp') || words;
                                Remainder1 := TRUNC(Remainder/100000);
                                Words := TO_CHAR(TO_DATE(Remainder1,'j'),'Jsp') || ' lakh ' || Words;
                            ELSE
                                Words := TO_CHAR(TO_DATE(Remainder,'j'),'Jsp') || GroupTable(GroupIndex) || Words;
                            END IF;
                        END IF;
                        GroupIndex := GroupIndex + 7;
                        WholePart := TRUNC(WholePart / 10000000);
                    END IF;
                END LOOP;
            END IF;
        END IF;
    END IF;

    IF Words IS NULL THEN
        Words := 'zero';
    END IF;
    IF SIGN(NumberIN) = -1 THEN
        Words := 'minus ' || Words;
    END IF;

    RETURN Words || ' ???? Only';
END;
