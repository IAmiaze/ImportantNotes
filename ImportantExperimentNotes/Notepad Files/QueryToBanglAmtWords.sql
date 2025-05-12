SELECT emoib.dfn_amount_in_words (NVL (9999999999.99, 0), 'BDT', 'Paisa')
           english,
       emoib.eng_to_bangla_words (
           emoib.dfn_amount_in_words (NVL (42.99, 0), 'BDT', 'Paisa'))
           bangla
  FROM DUAL