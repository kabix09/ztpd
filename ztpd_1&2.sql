--zadanie 1
CREATE OR REPLACE TYPE samochod AS OBJECT (
 marka VARCHAR2(20),
 model VARCHAR2(20),
 kilometry NUMBER,
 data_produkcji DATE,
 cena NUMBER(10,2)) ;

desc samochod;

CREATE TABLE samochody OF samochod;
INSERT INTO samochody VALUES(NEW samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 250));
INSERT INTO samochody VALUES(NEW samochod('FORD', 'MONDEO', 80000, DATE '1997-05-10', 450));
INSERT INTO samochody VALUES(NEW samochod('MAZDA', '323', 12000, DATE '2000-09-22', 520));

SELECT * FROM samochody;

--zadanie 2
CREATE TABLE wlasciciele (imie VARCHAR(100), NAZWISKO VARCHAR(100), AUTO SAMOCHOD);
INSERT INTO wlasciciele VALUES('jan', 'kowalski', NEW samochod('FIAT', 'seicento', 30000, DATE '0010-12-02', 19500));
INSERT INTO wlasciciele VALUES('adam', 'nowak', NEW samochod('OPEL', 'ASTRA', 34000, DATE '0009-06-01', 33700));
SELECT * FROM wlasciciele;


--zadanie 3
ALTER TYPE samochod REPLACE AS OBJECT (
 marka VARCHAR(20),
 model VARCHAR(20),
 kilometry NUMBER,
 DATA_PRODUKCJI DATE,
 cena NUMBER(10,2),
 MEMBER FUNCTION wartosc RETURN NUMBER);

CREATE OR REPLACE TYPE BODY samochod 
IS 
  MEMBER FUNCTION wartosc
  RETURN NUMBER 
  IS 
  cena_po_latach NUMBER;
  BEGIN
      cena_po_latach := cena;
      FOR i IN 1 .. (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji)) LOOP
          cena_po_latach := cena_po_latach * 0.9;
      END LOOP;
      RETURN ROUND(cena_po_latach, 2);
  END wartosc;
END;


--zadanie 4
ALTER TYPE samochod ADD MAP MEMBER FUNCTION val
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
MAP MEMBER FUNCTION value RETURN NUMBER IS
BEGIN
    RETURN 0 - (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM DATA_PRODUKCJI)) - KILOMETRY;
END value;
END;

ALTER TYPE samochod ADD MAP MEMBER FUNCTION value
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s) desc;

--zadanie 5
CREATE TYPE wlasciciel AS OBJECT (imie VARCHAR(100), nazwisko VARCHAR(100));

-- LISTY
--zadanie 6
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
 
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;

    moje_przedmioty.TRIM(2);
 
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 
    moje_przedmioty.DELETE();
 
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--zadanie 7
DECLARE
 TYPE t_tytuly IS TABLE OF VARCHAR2(50);
 tytul t_tytuly := t_tytuly();
BEGIN
 tytul.EXTEND(3);

 tytul(1) := 'Tytul 1';
 tytul(2) := 'Tytul 2';
 tytul(3) := 'Tytul 3';
    
 FOR i IN tytul.FIRST .. tytul.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(tytul(i));
 END LOOP;
    
 DBMS_OUTPUT.NEW_LINE;
  
 tytul.TRIM(2);
    
 FOR i IN tytul.FIRST .. tytul.LAST LOOP
  DBMS_OUTPUT.PUT_LINE(tytul(i));
 END LOOP;
    
 tytul.EXTEND(2);
    
 tytul(1) := 'Tytul';
 tytul(4) := 'Tytul 4';
 tytul(5) := 'Tytul 5';
    
 DBMS_OUTPUT.NEW_LINE;
    
 FOR i IN tytul.FIRST .. tytul.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(tytul(i));
 END LOOP;
        
 tytul.DELETE;
END;

--zadanie 8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 
 FOR i IN 3..10 LOOP
    moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 
 moi_wykladowcy.TRIM(2);
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 
 moi_wykladowcy.DELETE(5,7);
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END IF;
 END LOOP;
 
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END IF;
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--zadanie 9
DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(15);
 miesiace t_miesiace := t_miesiace();
BEGIN
 miesiace.EXTEND(12);
    
 DBMS_OUTPUT.PUT_LINE('Lista miesiêcy:');
     FOR i IN 1 .. 12 LOOP
         miesiace(i) := TO_CHAR(TO_DATE('2017-' || LPAD(i, 2, '0') || '-01'), 'month');
     DBMS_OUTPUT.PUT_LINE(miesiace(i));
 END LOOP;
    
 DBMS_OUTPUT.NEW_LINE;
 DBMS_OUTPUT.PUT_LINE('Lista miesi¹ce z "r" w nazwie:');
    
 FOR i IN miesiace.FIRST .. miesiace.LAST LOOP
     IF INSTR(miesiace(i), 'r') > 0 THEN
         DBMS_OUTPUT.PUT_LINE( miesiace(i));
     END IF;
 END LOOP;
    
 DBMS_OUTPUT.NEW_LINE;
 DBMS_OUTPUT.PUT_LINE('Co drugi miesi¹c, od koñca:');
    
 FOR i IN REVERSE miesiace.FIRST .. miesiace.LAST LOOP
     IF MOD(i, 2) != 0 THEN
         DBMS_OUTPUT.PUT_LINE( miesiace(i));
     END IF;
 END LOOP;
    
 DBMS_OUTPUT.NEW_LINE;
 DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji: ' || miesiace.count);
    
 miesiace.DELETE(7,12);
    
 DBMS_OUTPUT.NEW_LINE;
 DBMS_OUTPUT.PUT_LINE('Elementów w kolekcji po usuniêciu: ' || miesiace.count);
    
 FOR i IN miesiace.FIRST .. miesiace.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(i || ': ' || miesiace(i));
 END LOOP;
END;

-- zad 12 - 21
-- 
--


--zadanie 22
CREATE TYPE pisarz AS OBJECT (
 ID_PISARZA NUMBER,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE,
 KSIAZKI KSIAZKI_T,
 MEMBER FUNCTION ile_ksiazek RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY pisarz AS
 MEMBER FUNCTION ile_ksiazek RETURN NUMBER IS
 BEGIN
     RETURN KSIAZKI.COUNT();
 END ile_ksiazek;
END;

CREATE TYPE ksiazka AS OBJECT (
 ID_KSIAZKI NUMBER,
 AUTOR ref PISARZ,
 TYTUL VARCHAR2(50),
 DATA_WYDANIA DATE,
 MEMBER FUNCTION wiek RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY ksiazka AS
 MEMBER FUNCTION wiek RETURN NUMBER IS
 BEGIN
     RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DATA_WYDANIA);
 END wiek;
END;

CREATE OR REPLACE VIEW KSIAZKI_VIEW OF ksiazka WITH OBJECT IDENTIFIER(ID_KSIAZKI) AS SELECT ID_KSIAZKI, MAKE_REF(PISARZE_VIEW, ID_PISARZA), TYTUL, DATA_WYDANIA FROM KSIAZKI;

CREATE OR REPLACE VIEW PISARZE_VIEW OF pisarz WITH OBJECT IDENTIFIER(ID_PISARZA) AS SELECT ID_PISARZA, NAZWISKO, DATA_UR, CAST(MULTISET(SELECT TYTUL FROM KSIAZKI WHERE ID_PISARZA=P.ID_PISARZA) AS KSIAZKI_T) FROM PISARZE P;

--zadanie 23
CREATE TYPE AUTO_OSOBOWE UNDER AUTO (
 LICZBA_MIEJSC NUMBER,
 CZY_KLIMATYZACJA VARCHAR2(3),
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO_OSOBOWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
     WARTOSC NUMBER;
 BEGIN
  WARTOSC := (SELF AS AUTO).WARTOSC();
  IF (CZY_KLIMATYZACJA = 'TAK') THEN
      WARTOSC := WARTOSC * 1.5;
  END IF;
  RETURN WARTOSC;
  END;
END;

CREATE TYPE AUTO_CIEZAROWE UNDER AUTO (
 MAKSYMALNA_LADOWNOSC NUMBER,
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO_CIEZAROWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
     WARTOSC NUMBER;
 BEGIN
     WARTOSC := (SELF AS AUTO).WARTOSC();
     IF (MAKSYMALNA_LADOWNOSC > 10000) THEN
         WARTOSC := WARTOSC * 2;
     END IF;
     RETURN WARTOSC;
 END;
END;

INSERT INTO AUTA VALUES (AUTO_OSOBOWE('Volkswagen', 'Passat', 20000, DATE '2010-05-05', 60000, 5, 'NIE'));
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('Wolkswagen', 'Golf', 40000, DATE '2015-10-30', 50000, 4, 'TAK'));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('Mercedes', 'Actros', 800000, DATE '2010-04-30', 50000, 8000));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('Volvo', 'FH12', 120000, DATE '2020-11-30', 50000, 12000));

SELECT A.MARKA, A.WARTOSC() FROM AUTA A;