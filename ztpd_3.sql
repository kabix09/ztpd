--zadanie 1
CREATE TABLE MOVIES AS SELECT * FROM ZTPD.MOVIES;
--zadanie 2
SELECT * FROM MOVIES;

--zadanie 3
SELECT * FROM MOVIES WHERE MOVIES.COVER IS null;

--zadanie 4
SELECT ID, TITLE, dbms_lob.getlength(COVER) FROM MOVIES WHERE MOVIES.COVER IS NOT NULL;
--zadanie 5
SELECT ID, TITLE, dbms_lob.getlength(COVER) FROM MOVIES WHERE MOVIES.COVER IS NULL;

--zadanie 6
SELECT DIRECTORY_NAME, DIRECTORY_PATH
FROM ALL_DIRECTORIES
WHERE DIRECTORY_NAME = 'TPD_DIR';

--zadanie 7
UPDATE MOVIES
SET COVER = EMPTY_BLOB(),
    MIME_TYPE = 'image/jpeg'
WHERE ID = 66;
COMMIT;

--zadanie 8
 SELECT ID, TITLE, dbms_lob.getlength(COVER) FROM MOVIES WHERE MOVIES.ID BETWEEN 65 AND 66;

--zadanie 9
DECLARE
  bf BFILE;
  lb BLOB;
BEGIN
  -- Deklaracja zmiennej typu BFILE i zwi¹zanie jej z plikiem ok³adki
  bf := BFILENAME('TPD_DIR', 'escape.jpg');

  -- Odczyt pustego obiektu BLOB do zmiennej
  
  SELECT COVER INTO lb
  FROM MOVIES
  WHERE ID = 66
  FOR UPDATE;
  
  -- Otwarcie pliku BFILE
  DBMS_LOB.FILEOPEN(bf, DBMS_LOB.FILE_READONLY);

  -- Przekopiowanie zawartoœci binarnej z BFILE do BLOB
  DBMS_LOB.LOADFROMFILE(DEST_LOB => lb,
                          SRC_LOB  => bf,
                          AMOUNT   => DBMS_LOB.GETLENGTH(bf));

  -- Zamkniêcie pliku BFILE
  DBMS_LOB.FILECLOSE(bf);

  -- Zatwierdzenie transakcji
  COMMIT;
END;
/

--zadanie 10
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BLOB,
    mime_type VARCHAR2(50)
);

--zadanie 11
INSERT INTO temp_covers VALUES(65, BFILENAME('ZSBD_DIR', 'eagles.jpg'), 'image/jpeg');

--zadanie 12
INSERT INTO TEMP_COVERS (movie_id, image, mime_type)
  VALUES (65, EMPTY_BLOB(), 'image/jpeg');

--zadanie 13
DECLARE
  src_lob BFILE;
  dest_lob BLOB;
BEGIN
  -- Ustawienie identyfikatora filmu

  INSERT INTO TEMP_COVERS (movie_id, image, mime_type)
  VALUES (65, EMPTY_BLOB(), 'image/jpeg')
  RETURNING image INTO dest_lob;

    -- Deklaracja zmiennej typu BFILE i zwi¹zanie jej z plikiem ok³adki
  src_lob := BFILENAME('TPD_DIR', 'escape.jpg');
  
  -- Otwarcie pliku BFILE
  DBMS_LOB.FILEOPEN(src_lob, DBMS_LOB.FILE_READONLY);

  -- Przekopiowanie zawartoœci binarnej z BFILE do BLOB
  DBMS_LOB.LOADFROMFILE(DEST_LOB => dest_lob,
                          SRC_LOB  => src_lob,
                          AMOUNT   => DBMS_LOB.GETLENGTH(src_lob));

  -- Zamkniêcie pliku BFILE
  DBMS_LOB.FILECLOSE(src_lob);

  -- Zatwierdzenie transakcji
  COMMIT;
END;
/

--zadanie 14
SELECT id, title, length(cover)
AS filesize
FROM movies
WHERE id = 65 OR id = 66;

--zadanie15
DROP TABLE movies;
DROP TABLE temp_covers;