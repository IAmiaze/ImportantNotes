CREATE OR REPLACE FUNCTION EMOIB.ENG_TO_BANGLA_WORDS (p_input IN VARCHAR2)
    RETURN VARCHAR2
IS
    v_output   VARCHAR2 (4000) := LOWER (p_input);
    
BEGIN
    -- Mapping from English words to Bangla
    v_output := REPLACE (v_output, 'tk.', '????.');
    v_output := REPLACE (v_output, 'one hundred', '?? ??');
    v_output := REPLACE (v_output, 'two hundred', '??? ??');
    v_output := REPLACE (v_output, 'three hundred', '??? ??');
    v_output := REPLACE (v_output, 'four hundred', '??? ??');
    v_output := REPLACE (v_output, 'five hundred', '???? ??');
    v_output := REPLACE (v_output, 'six hundred', '?? ??');
    v_output := REPLACE (v_output, 'seven hundred', '??? ??');
    v_output := REPLACE (v_output, 'eight hundred', '?? ??');
    v_output := REPLACE (v_output, 'nine hundred', '?? ??');

    -- Tens and units
    v_output :=
        REPLACE (v_output, 'ninety-nine', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-eight', '??????????');
    v_output :=
        REPLACE (v_output, 'ninety-seven', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-six', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-five', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-four', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-three', '?????????');
    v_output :=
        REPLACE (v_output, 'ninety-two', '?????????');
    v_output := REPLACE (v_output, 'ninety-one', '????????');
    v_output := REPLACE (v_output, 'ninety', '?????');

    v_output := REPLACE (v_output, 'eighty-nine', '???????');
    v_output := REPLACE (v_output, 'eighty-eight', '???????');
    v_output := REPLACE (v_output, 'eighty-seven', '??????');
    v_output := REPLACE (v_output, 'eighty-six', '??????');
    v_output := REPLACE (v_output, 'eighty-five', '??????');
    v_output := REPLACE (v_output, 'eighty-four', '??????');
    v_output := REPLACE (v_output, 'eighty-three', '??????');
    v_output := REPLACE (v_output, 'eighty-two', '??????');
    v_output := REPLACE (v_output, 'eighty-one', '?????');
    v_output := REPLACE (v_output, 'eighty', '???');

    v_output := REPLACE (v_output, 'seventy-nine', '?????');
    v_output := REPLACE (v_output, 'seventy-eight', '???????');
    v_output :=
        REPLACE (v_output, 'seventy-seven', '????????');
    v_output := REPLACE (v_output, 'seventy-six', '????????');
    v_output :=
        REPLACE (v_output, 'seventy-five', '????????');
    v_output :=
        REPLACE (v_output, 'seventy-four', '????????');
    v_output :=
        REPLACE (v_output, 'seventy-three', '????????');
    v_output := REPLACE (v_output, 'seventy-two', '????????');
    v_output := REPLACE (v_output, 'seventy-one', '???????');
    v_output := REPLACE (v_output, 'seventy', '?????');

    v_output := REPLACE (v_output, 'sixty-nine', '???????');
    v_output := REPLACE (v_output, 'sixty-eight', ' ??????? ');
    v_output := REPLACE (v_output, 'sixty-seven', '????????');
    v_output := REPLACE (v_output, 'sixty-six', ' ???????');
    v_output :=
        REPLACE (v_output, 'sixty-five', '?????????');
    v_output := REPLACE (v_output, 'sixty-four', ' ???????');
    v_output := REPLACE (v_output, 'sixty-three', ' ???????');
    v_output := REPLACE (v_output, 'sixty-two', '???????');
    v_output := REPLACE (v_output, 'sixty-one', '???????');
    v_output := REPLACE (v_output, 'sixty', '???');

    v_output := REPLACE (v_output, 'fifty-nine', '?????');
    v_output := REPLACE (v_output, 'fifty-eight', ' ?????? ');
    v_output := REPLACE (v_output, 'fifty-seven', '???????');
    v_output :=
        REPLACE (v_output, 'fifty-six', ' ?????????');
    v_output := REPLACE (v_output, 'fifty-five', '????????');
    v_output := REPLACE (v_output, 'fifty-four', ' ???????');
    v_output :=
        REPLACE (v_output, 'fifty-three', ' ?????????');
    v_output := REPLACE (v_output, 'fifty-two', '???????');
    v_output := REPLACE (v_output, 'fifty-one', '??????');
    v_output := REPLACE (v_output, 'fifty', '??????');

    v_output := REPLACE (v_output, 'forty-nine', '????????');
    v_output :=
        REPLACE (v_output, 'forty-eight', ' ???????? ');
    v_output :=
        REPLACE (v_output, 'forty-seven', '?????????');
    v_output := REPLACE (v_output, 'forty-six', ' ????????');
    v_output :=
        REPLACE (v_output, 'forty-five', '???????????');
    v_output :=
        REPLACE (v_output, 'forty-four', ' ?????????');
    v_output :=
        REPLACE (v_output, 'forty-three', ' ?????????');
    v_output :=
        REPLACE (v_output, 'forty-two', '??????????');
    v_output := REPLACE (v_output, 'forty-one', '????????');
    v_output := REPLACE (v_output, 'forty', '??????');

    -- Add numbers ?? to ??
    v_output := REPLACE (v_output, 'thirty-nine', '????????');
    v_output := REPLACE (v_output, 'thirty-eight', ' ??????? ');
    v_output :=
        REPLACE (v_output, 'thirty-seven', '????????');
    v_output := REPLACE (v_output, 'thirty-six', '??????');
    v_output :=
        REPLACE (v_output, 'thirty-five', '?????????');
    v_output := REPLACE (v_output, 'thirty-four', ' ???????');
    v_output := REPLACE (v_output, 'thirty-three', ' ???????');
    v_output := REPLACE (v_output, 'thirty-two', '??????');
    v_output := REPLACE (v_output, 'thirty-one', '???????');
    v_output := REPLACE (v_output, 'thirty', '?????');

    -- Add numbers 21 to 29
    v_output := REPLACE (v_output, 'twenty-nine', '???????');
    v_output := REPLACE (v_output, 'twenty-eight', ' ???? ');
    v_output := REPLACE (v_output, 'twenty-seven', '?????');
    v_output := REPLACE (v_output, 'twenty-six', '???????');
    v_output := REPLACE (v_output, 'twenty-five', '?????');
    v_output := REPLACE (v_output, 'twenty-four', ' ??????');
    v_output := REPLACE (v_output, 'twenty-three', ' ????');
    v_output := REPLACE (v_output, 'twenty-two', '????');
    v_output := REPLACE (v_output, 'twenty-one', '????');
    v_output := REPLACE (v_output, 'twenty', '???');

    v_output := REPLACE (v_output, 'nineteen', '????');
    v_output := REPLACE (v_output, 'eighteen', '?????');
    v_output := REPLACE (v_output, 'seventeen', '?????');
    v_output := REPLACE (v_output, 'sixteen', '???');
    v_output := REPLACE (v_output, 'fifteen', '?????');
    v_output := REPLACE (v_output, ' fourteen ', '?????');
    v_output := REPLACE (v_output, 'thirteen', '????');
    v_output := REPLACE (v_output, 'twelve', '????');
    v_output := REPLACE (v_output, 'eleven', '?????');

    -- Continue for other numbers
    v_output := REPLACE (v_output, 'ten', '??');
    v_output := REPLACE (v_output, 'nine', '??');
    v_output := REPLACE (v_output, 'eight', '??');
    v_output := REPLACE (v_output, 'seven', '???');
    v_output := REPLACE (v_output, 'six', '??');
    v_output := REPLACE (v_output, 'five', '????');
    v_output := REPLACE (v_output, 'four', '???');
    v_output := REPLACE (v_output, 'three', '???');
    v_output := REPLACE (v_output, 'two', '???');
    v_output := REPLACE (v_output, 'one', '??');
    v_output := REPLACE (v_output, 'zero', '?????');
    v_output := REPLACE (v_output, 'paisa', '????');
    v_output := REPLACE (v_output, ' and ', ' ???');
    v_output := REPLACE (v_output, 'only', ' ????? ?');

    -- Higher denominations
    v_output := REPLACE (v_output, 'crore', ' ???? ');
    v_output := REPLACE (v_output, 'lakh', '???');
    v_output := REPLACE (v_output, 'thousand', '?????');
    v_output := REPLACE (v_output, 'hundred', '?');


    -- Capitalize first letter if needed
    RETURN INITCAP (v_output);
END;
/