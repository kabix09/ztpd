-- PRZESTRZENNE BAZY DANYCH - CW II
--zadanie 1
--A.
INSERT INTO USER_SDO_GEOM_METADATA VALUES ('FIGURY', 'KSZTALT',
 MDSYS.SDO_DIM_ARRAY(
     MDSYS.SDO_DIM_ELEMENT('X', 0, 100, 0.01),
     MDSYS.SDO_DIM_ELEMENT('Y', 0, 100, 0.01)),NULL);

--B.
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0) FROM figury WHERE ROWNUM <= 1;

--C.
CREATE INDEX ksztalt_spatial_idx ON figury(KSZTALT) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

--D.
SELECT id FROM figury
WHERE SDO_FILTER(KSZTALT, SDO_GEOMETRY(2001, NULL, SDO_POINT_TYPE(3,3, NULL), NULL, NULL)) = 'TRUE';

--E.
SELECT id FROM figury
WHERE SDO_RELATE(KSZTALT, SDO_GEOMETRY(2001, NULL, SDO_POINT_TYPE(3,3, NULL), NULL, NULL), 'mask=ANYINTERACT') = 'TRUE';

--zadanie 2
--A. 
SELECT
 A.city_name MIASTO,
 ROUND(SDO_NN_DISTANCE(1), 7) odl
FROM major_cities A, major_cities B
WHERE
 SDO_NN(
     A.GEOM,
     MDSYS.SDO_GEOMETRY(
         2001,
         8307,
         B.GEOM.SDO_POINT,
         B.GEOM.SDO_ELEM_INFO,
         B.GEOM.SDO_ORDINATES),'sdo_num_res=10 unit=km', 1) = 'TRUE'
 AND B.city_name = 'Warsaw'
 AND A.city_name <> 'Warsaw';

--B.
SELECT
 A.city_name MIASTO
FROM major_cities A, major_cities B
WHERE
 SDO_WITHIN_DISTANCE(
      A.GEOM,
      MDSYS.SDO_GEOMETRY(
         2001,
         8307,
         B.GEOM.SDO_POINT,
         B.GEOM.SDO_ELEM_INFO,
         B.GEOM.SDO_ORDINATES),
        'distance=100 unit=km') = 'TRUE'
 AND B.city_name = 'Warsaw'
 AND A.city_name <> 'Warsaw';

--C. 
SELECT B.cntry_name KRAJ, C.city_name MIASTO
FROM country_boundaries B, major_cities C
WHERE SDO_RELATE(C.GEOM, B.GEOM, 'mask=INSIDE') = 'TRUE' AND B.cntry_name = 'Slovakia';

--D.
SELECT
 A.cntry_name PANSTWO,
 ROUND(SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km'), 7) ODL
FROM country_boundaries A, country_boundaries B
WHERE
 SDO_RELATE(
     A.GEOM,
     SDO_GEOMETRY(
         2001,
         8307,
         B.GEOM.SDO_POINT,
         B.GEOM.SDO_ELEM_INFO,
         B.GEOM.SDO_ORDINATES),
        'mask=ANYINTERACT') != 'TRUE' AND B.cntry_name = 'Poland';

--zadanie 3
--A.
SELECT A.cntry_name, ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km'), 8) ODLEGLOSC
FROM country_boundaries A, country_boundaries B
WHERE SDO_FILTER(A.GEOM, B.GEOM) = 'TRUE' AND B.cntry_name = 'Poland';

--B.
SELECT cntry_name
FROM country_boundaries 
WHERE SDO_GEOM.SDO_AREA(GEOM) = (SELECT MAX(SDO_GEOM.SDO_AREA(GEOM)) FROM country_boundaries);

--C.
SELECT ROUND(SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(
                    				A.GEOM,
                    				B.GEOM,
                    				0.01)), 1, 'unit=SQ_KM'), 5) SQ_KM
FROM major_cities A,
    major_cities B
WHERE A.city_name = 'Warsaw'
    AND B.city_name = 'Lodz';

--D.
SELECT
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_DIMS() ||
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_LRS_DIM() ||
    LPAD(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_GTYPE(), 2, '0') GTYPE
FROM country_boundaries A,
major_cities B
WHERE A.cntry_name = 'Poland'
AND B.city_name = 'Prague';

--E.
SELECT B.city_name, A.cntry_name 
FROM country_boundaries A, major_cities B
WHERE
 A.cntry_name = B.cntry_name 
 AND SDO_GEOM.SDO_DISTANCE(
     SDO_GEOM.SDO_CENTROID(A.GEOM, 1),
     B.GEOM, 1) = (SELECT MIN(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(A.GEOM, 1), B.GEOM, 1))
			FROM country_boundaries A, major_cities B 
			WHERE A.cntry_name = B.cntry_name);

--F.
SELECT name, ROUND(SUM(dlugosc), 7) dlugosc
FROM (SELECT B.name, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=KM') dlugosc
    	FROM country_boundaries A, rivers B
    	WHERE
            SDO_RELATE(
                A.GEOM,
                SDO_GEOMETRY(
                    2001,
                    8307,
                    B.GEOM.SDO_POINT,
                    B.GEOM.SDO_ELEM_INFO,
                    B.GEOM.SDO_ORDINATES), 'mask=ANYINTERACT') = 'TRUE' AND A.cntry_name = 'Poland') GROUP BY name;