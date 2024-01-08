-- PRZESTRZENNE BAZY DANYCH - CW V - ORACLE TEXT

-- zadanie 1
CREATE TABLE cytaty AS SELECT * FROM ZSBD_TOOLS.cytaty;

-- zadanie 2
SELECT autor, tekst FROM cytaty WHERE UPPER(tekst) LIKE '%PESYMISTA%' AND UPPER(tekst) LIKE '%OPTYMISTA%';

-- zadanie 3
CREATE INDEX CYTATY_TEKST_IDX ON cytaty(tekst) INDEXTYPE IS CTXSYS.CONTEXT;

-- zadanie 4
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'PESYMISTA AND OPTYMISTA', 1) > 0;

-- zadanie 5
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'PESYMISTA ~ OPTYMISTA', 1) > 0;

-- zadanie 6
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'NEAR((PESYMISTA, OPTYMISTA), 3)') > 0;

-- zadanie 7
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'NEAR((PESYMISTA, OPTYMISTA), 10)') > 0;

-- zadanie 8
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0;

-- zadanie 9
SELECT SCORE(1) AS dopasowanie, autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0;

-- zadanie 10 
SELECT autor, tekst, SCORE(1) AS dopasowanie FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0 AND ROWNUM <= 1 ORDER BY 3 DESC;

-- zadanie 11
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'FUZZY(PROBELM)', 1) > 0;

-- zadanie 12
INSERT INTO CYTATY VALUES(1000, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;

-- zadanie 13
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'GŁUPCY', 1) > 0;

-- zadanie 14
SELECT TOKEN_TEXT FROM DR$CYTATY_TEKST_IDX$I WHERE TOKEN_TEXT = 'GŁUPCY';

-- zadanie 15
DROP INDEX CYTATY_TEKST_IDX;
CREATE INDEX CYTATY_TEKST_IDX ON cytaty(tekst) INDEXTYPE IS CTXSYS.CONTEXT;

-- zadanie 16
SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'GŁUPCY', 1) > 0;

-- zadanie 17
DROP INDEX CYTATY_TEKST_IDX;
DROP TABLE cytaty;

-- zadanie 1
CREATE TABLE quotes AS SELECT * FROM ZSBD_TOOLS.QUOTES;

-- zadanie 2
CREATE INDEX QUOTES_TEXT_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT;

-- zadanie 3
SELECT author, text FROM quotes WHERE CONTAINS(text, 'WORK', 1) > 0;
SELECT author, text FROM quotes WHERE CONTAINS(text, '$WORK', 1) > 0;
SELECT author, text FROM quotes WHERE CONTAINS(text, 'WORKING', 1) > 0;
SELECT author, text FROM quotes WHERE CONTAINS(text, '$WORKING', 1) > 0;

-- zadanie 4
SELECT author, text FROM quotes WHERE CONTAINS(text, 'it', 1) > 0;

-- zadanie 5
SELECT * FROM CTX_STOPLISTS;

-- zadanie 6
SELECT * FROM CTX_STOPWORDS;

-- zadanie 7
DROP INDEX QUOTES_TEXT_IDX;
CREATE INDEX QUOTES_TEXT_IDX ON quotes(text) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- zadanie 8
Tak, system zwrócił wyniki

-- zadanie 9
SELECT author, text FROM quotes WHERE CONTAINS(text, 'fool or humans', 1) > 0;

-- zadanie 10
SELECT author, text FROM quotes WHERE CONTAINS(text, 'fool or computer', 1) > 0;

-- zadanie 11
SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool and computer) within sentence', 1) > 0;

-- zadanie 12
DROP INDEX QUOTES_TEXT_IDX;

-- zadanie 13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup',  'SENTENCE');
    ctx_ddl.add_special_section('nullgroup',  'PARAGRAPH');
END;

-- zadanie 14
CREATE INDEX QUOTES_TEXT_IDX ON quotes(text) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

-- zadanie 15
SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool and humans within sentence', 1) > 0;
SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool and computer) within sentence', 1) > 0;

-- zadanie 16
SELECT author, text FROM quotes WHERE CONTAINS(text, 'humans', 1) > 0;

-- zadanie 17
DROP INDEX QUOTES_TEXT_IDX;
BEGIN
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;
CREATE INDEX QUOTES_TEXT_IDX ON quotes(text) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup LEXER lex_z_m');

-- zadanie 18
SELECT * FROM quotes WHERE contains(text, 'humans') > 0;
    
Nie

-- zadanie 19
SELECT author, text FROM quotes WHERE CONTAINS(text, 'non\-humans', 1) > 0;

-- zadanie 20
DROP INDEX quotes_idx;

DROP TABLE quotes;