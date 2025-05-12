CREATE OR REPLACE FUNCTION EMOIB.dfn_amount_in_words (i_number    IN NUMBER,
                                                i_maincur   IN VARCHAR2,
                                                i_subcur    IN VARCHAR2)
   RETURN VARCHAR2
AS
   TYPE myarray IS TABLE OF VARCHAR2 (255);

   l_str       myarray
                  := myarray ('',
                              ' Thousand ',
                              ' Lakh ',
                              ' Crore ',
                              ' Hundred Crore ',
                              ' Thousand Crore ');
   l_num       VARCHAR2 (50) DEFAULT TRUNC (i_number);
   l_num1      VARCHAR2 (50)
      DEFAULT SUBSTR (ROUND (i_number, 2),
                      INSTR (ROUND (i_number, 2), '.', 1) + 1,
                      2);
   l_return    VARCHAR2 (4000);
   l_return1   VARCHAR2 (4000);
   l_return2   VARCHAR2 (4000);
   l_words     VARCHAR2 (4000);
   l_flg       VARCHAR2 (1) := 'Y';
BEGIN
   FOR i IN 1 .. l_str.COUNT
   LOOP
      EXIT WHEN l_num IS NULL;

      IF l_flg = 'Y'
      THEN
         IF (SUBSTR (l_num, LENGTH (l_num) - 2, 3) <> 0)
         THEN
            l_return := TO_CHAR (
                           TO_DATE (SUBSTR (l_num, LENGTH (l_num) - 2, 3),
                                    'J'),
                           'Jsp')
                        || l_str (i)
                        || l_return;
         END IF;

         l_num := SUBSTR (l_num, 1, LENGTH (l_num) - 3);
         l_flg := 'N';
      ELSE
         IF (SUBSTR (l_num, LENGTH (l_num) - 1, 2) <> 0)
         THEN
            l_return1 := TO_CHAR (
                            TO_DATE (SUBSTR (l_num, LENGTH (l_num) - 1, 2),
                                     'J'),
                            'Jsp')
                         || l_str (i)
                         || l_return1;
         END IF;

         l_num := SUBSTR (l_num, 1, LENGTH (l_num) - 2);
      END IF;
   END LOOP;

   l_return1 := l_return1 || ' ' || l_return;

   IF INSTR (ROUND (i_number, 2), '.', 1) != 0
   THEN
      IF SUBSTR (l_num1, 2, 1) IS NULL
      THEN
         l_num1 := l_num1 || '0';
      END IF;

      l_return2 := TO_CHAR (TO_DATE (SUBSTR (l_num1, 1), 'J'), 'Jsp');
      --l_return2 :=  ' and '||l_return2||' '||i_Subcur||' Only';
      l_return2 := ' and ' || l_return2 || ' ' || i_subcur;
   END IF;

   --l_words := i_maincur || ' ' || l_return1 || l_return2;
             l_words :='TK. '||l_return1 || l_return2||' Only';
   RETURN l_words;
END;
 
/
