--zadanie 1
CREATE TABLE DOKUMENTY
(
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

--zadanie 2
DECLARE
    beg_text VARCHAR(12) := 'Oto tekst. ';
    final_text CLOB;
BEGIN
    FOR i IN 1..10000 LOOP
        final_text := final_text || TO_CLOB(beg_text);
    END LOOP;
    
    INSERT INTO DOKUMENTY(ID, DOKUMENT)
    VALUES (1, final_text);
    
    COMMIT;
END;
/

--zadanie 3a
SELECT * FROM DOKUMENTY;

--zadanie 3b
SELECT UPPER(DOKUMENT) AS UPPER_CASE_DOCUMENT
FROM DOKUMENTY;

--zadanie 3c
SELECT LENGTH(DOKUMENT) AS DOCUMENT_LENGTH
FROM DOKUMENTY;

--zadanie 3d
SET SERVEROUTPUT ON;

DECLARE
    v_document_size INTEGER;
    v_document CLOB;
BEGIN
    -- Przypisanie dokumentu do zmiennej
    SELECT DOKUMENT INTO v_document FROM DOKUMENTY WHERE ROWNUM = 1;  // dla 2 & 3 - nie znaleziono danych

    -- U¿ycie funkcji GETLENGTH do odczytania rozmiaru dokumentu
    v_document_size := DBMS_LOB.GETLENGTH(v_document);

    -- Wyœwietlenie rozmiaru dokumentu
    DBMS_OUTPUT.PUT_LINE('Rozmiar dokumentu: ' || v_document_size);
END;
/

--zadanie 3e
DECLARE
    v_document CLOB;
    v_substr_result VARCHAR2(1000);
BEGIN
    -- Przypisanie dokumentu do zmiennej
    SELECT DOKUMENT INTO v_document FROM DOKUMENTY WHERE ROWNUM = 1;  // dla 2 & 3 - nie znaleziono danych

    -- U¿ycie funkcji SUBSTR do odczytania 1000 znaków pocz¹wszy od 5 pozycji
    v_substr_result := SUBSTR(v_document, 5, 1000);

    -- Wyœwietlenie rezultatu
    DBMS_OUTPUT.PUT_LINE('Wynik funkcji SUBSTR: ' || v_substr_result);
END;
/

--zadanie 3f
DECLARE
    v_document CLOB;
    v_substr_result VARCHAR2(1000);
BEGIN
    -- Przypisanie dokumentu do zmiennej
    SELECT DOKUMENT INTO v_document FROM DOKUMENTY WHERE ROWNUM = 1; // dla 2 & 3 - nie znaleziono danych

    -- U¿ycie funkcji DBMS_LOB.SUBSTR do odczytania 1000 znaków pocz¹wszy od 5 pozycji
    v_substr_result := DBMS_LOB.SUBSTR(v_document, 1000, 5);

    -- Wyœwietlenie rezultatu
    DBMS_OUTPUT.PUT_LINE('Wynik funkcji DBMS_LOB.SUBSTR: ' || v_substr_result);
END;
/

--zadanie 4
INSERT INTO DOKUMENTY (ID, DOKUMENT)
VALUES (2, EMPTY_CLOB());

--zadanie 5
INSERT INTO DOKUMENTY (ID, DOKUMENT) VALUES (3, NULL);
COMMIT;

--zadanie 6 - komentarze przy id zapytan 


--zadanie 7
DECLARE
    v_bfile BFILE;
    v_clob CLOB;
BEGIN
    -- Zwi¹¿ zmienn¹ BFILE z plikiem tekstowym
    v_bfile := BFILENAME('TPD_DIR', 'dokument.txt');

    -- Odczytaj pusty obiekt CLOB do zmiennej
    SELECT DOKUMENT INTO v_clob FROM DOKUMENTY WHERE ID = 2 FOR UPDATE;

    -- Otwórz plik BFILE
    DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);

    -- Przekopiuj zawartoœæ z BFILE do CLOB
    DBMS_LOB.LOADCLOBFROMFILE(
        DEST_LOB => v_clob,
        SRC_BFILE => v_bfile,
        AMOUNT => DBMS_LOB.GETLENGTH(v_bfile),
        DEST_OFFSET => DBMS_LOB.GETLENGTH(v_bfile) + 1,
        SRC_OFFSET => 1,
        BFILE_CSID => 0,
        DEST_CSID => 0
    );

    -- Zamknij plik BFILE
    DBMS_LOB.FILECLOSE(v_bfile);

    -- ZatwierdŸ transakcjê
    COMMIT;
END;
/

--zadanie 8
UPDATE DOKUMENTY
SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
WHERE ID = 3;

--zadanie 9
SELECT * FROM DOKUMENTY;

--zadanie 10
SELECT ID, DBMS_LOB.GETLENGTH(DOKUMENT) AS DOCUMENT_LENGTH
FROM DOKUMENTY;

--zadanie 11
DROP TABLE DOKUMENTY;

--zadanie 12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    p_clob IN OUT CLOB,
    p_text_to_censor IN VARCHAR2
) IS
    v_clob_len INTEGER;
    v_text_len INTEGER;
    v_position INTEGER := 1;
BEGIN
    v_clob_len := DBMS_LOB.GETLENGTH(p_clob);
    v_text_len := LENGTH(p_text_to_censor);

    WHILE (v_position > 0) LOOP
        v_position := DBMS_LOB.INSTR(p_clob, p_text_to_censor, v_position);
        IF (v_position > 0) THEN
            DBMS_LOB.WRITE(p_clob, v_text_len, v_position, LPAD('.', v_text_len, '.'));
            v_position := v_position + v_text_len;
        END IF;
    END LOOP;
END;
/

--zadanie 13
 CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;
SELECT * FROM v_clob_data ;

--zadanie 14
SET SERVEROUTPUT ON;

DECLARE
    v_clob_data CLOB;
BEGIN
    -- Przyk³adowe dane do przetestowania procedury
    SELECT BIO INTO v_clob_data FROM BIOGRAPHIES WHERE ID = 1 FOR UPDATE;

    -- Wywo³anie procedury
    CLOB_CENSOR(v_clob_data, 'Cimrman');

    -- Wyœwietlenie zcenzurowanego CLOB
    DBMS_OUTPUT.PUT_LINE(v_clob_data);
END;
/

--zadanie 15
DROP TABLE BIOGRAPHES;
