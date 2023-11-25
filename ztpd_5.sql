-- PRZESTRZENNE BAZY DANYCH - CW I
--zadanie 1
--A.

DROP TABLE FIGURY;

CREATE TABLE FIGURY
(
    ID NUMBER(12) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
);

--B.
-- 1 kolo
INSERT INTO figury VALUES
(1,MDSYS.SDO_GEOMETRY(
            2003,
            null,
            null,
            SDO_ELEM_INFO_ARRAY(1,1003,4),
            SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)));
			
-- 2 kwadrat
INSERT INTO figury VALUES
(2,MDSYS.SDO_GEOMETRY(
			2003, 
			NULL, 
			NULL, 
			MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
			MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)));
			
-- 3 nieregularny
INSERT INTO figury VALUES
(3,MDSYS.SDO_GEOMETRY(
            2002,
            null,
            null,
            SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
            SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)));

--C.
SELECT * FROM FIGURY;


--D.
SELECT ID, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT,0.01) FROM FIGURY;

--E.
DELETE FROM FIGURY WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT,0.01) <> 'TRUE';

--F.
COMMIT;