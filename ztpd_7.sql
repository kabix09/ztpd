-- PRZESTRZENNE BAZY DANYCH - CW III - SPATIAL
--zadanie 1
--A.
SELECT
 lpad('-',2*(level-1),'|-') ||
 t.owner || '.'|| t.type_name ||
 ' (FINAL:'||t.final||', INSTANTIABLE:' ||
 t.instantiable || ', ATTRIBUTES:' ||
 t.attributes || ', METHODS:' ||
 t.methods || ')'
FROM all_types at START WITH t.type_name = 'ST_GEOMETRY' CONNECT BY PRIOR t.type_name = at.supertype_name AND PRIOR at.owner = at.owner;

--B.
SELECT DISTINCT m.method_name FROM all_type_methods m WHERE m.type_name LIKE 'ST_POLYGON' AND m.owner = 'MDSYS' ORDER BY 1;
	
--C.
DROP TABLE MYST_MAJOR_CITIES;

CREATE TABLE MYST_MAJOR_CITIES (FIPS_CNTRY VARCHAR2(2), CITY_NAME VARCHAR2(40), STGEOM ST_POINT);

--D.
SELECT * FROM major_cities WHERE ROWNUM < 5;
INSERT INTO myst_major_cities
SELECT FIPS_CNTRY, CITY_NAME, ST_POINT(GEOM) STGEOM
FROM major_cities;

SELECT * FROM myst_major_cities WHERE ROWNUM < 5;

--zadanie 2
--A.
INSERT INTO myst_major_cities VALUES ('PL', SZCZYRK', TREAT(ST_POINT.FROM_WKT('POINT(19.036107 49.718655)', 8307) AS ST_POINT));

SELECT * FROM myst_major_cities WHERE city_name= 'SZCZYRK';

--B.
SELECT * FROM rivers WHERE ROWNUM < 5;

SELECT name, treat(ST_POINT.FROM_SDO_GEOM(GEOM) AS ST_GEOMETRY).GET_WKT() FROM rivers;

--C.
SELECT SDO_UTIL.TO_GMLGEOMETRY(ST_POINT.GET_SDO_GEOM(STGEOM)) GML FROM myst_major_cities WHERE city_name = 'SZCZYRK';

--zadanie 3
--A.
DROP TABLE myst_country_BOUNDARIES;
CREATE TABLE myst_country_boundaries (
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

--B.
SELECT * FROM country_boundaries WHERE ROWNUM < 5;

INSERT INTO myst_country_boundaries 
SELECT fips_cntry, cntry_name, st_multipolygon(geom)
FROM country_boundaries;

SELECT * FROM myst_country_boundaries WHERE ROWNUM < 5;

--C.
SELECT B.STGEOM.ST_GEOMETRYTYPE() AS TYP_OBIEKTU, COUNT(*) AS ILE
FROM myst_country_boundaries B GROUP BY B.STGEOM.ST_GEOMETRYTYPE();

--D.
SELECT B.STGEOM.ST_ISSIMPLE() FROM myst_country_boundaries B;

--zadanie 4
--A.
SELECT B.CNTRY_NAME, COUNT(*)
FROM myst_country_boundaries B, MYST_MAJOR_CITIES C
WHERE B.STGEOM.ST_CONTAINS(C.STGEOM) = 1 GROUP BY B.CNTRY_NAME;
--B.
SELECT A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
FROM myst_country_boundaries A, myst_country_boundaries B
WHERE  B.CNTRY_NAME = 'Czech Republic' AND A.STGEOM.ST_TOUCHES(B.STGEOM) = 1;

--C.
SELECT DISTINCT B.cntry_name, R.name FROM myst_country_boundaries B, rivers R WHERE B.CNTRY_NAME = 'Czech Republic' AND B.STGEOM.ST_CROSSES(ST_LINESTRING(R.GEOM)) = 1;

--D.
SELECT ROUND(SUM(B.STGEOM.ST_AREA()), -2) POWIERZCHNIA FROM MYST_COUNTRY_BOUNDARIES B WHERE  B.cntry_name ='Czech Republic' OR  B.cntry_name ='Slovakia';

--E.
SELECT B.STGEOM OBIEKT, B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() WEGRY_BEZ
FROM myst_country_boundaries B, WATER_BODIES W WHERE  B.CNTRY_NAME = 'Hungary' AND W.name = 'Balaton';

--zadanie 5
--A.
EXPLAIN PLAN FOR
SELECT B.cntry_name A_NAME, COUNT(*)
FROM myst_country_boundaries B, myst_major_cities C
WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE' AND B.cntry_name = 'Poland' GROUP BY B.cntry_name;

SELECT plan_table_output FROM table(dbms_xplan.display('plan_table', null, 'basic'));

--B.
SELECT * FROM ALL_SDO_GEOM_METADATA;
SELECT * FROM USER_SDO_GEOM_METADATA;

DELETE FROM USER_SDO_GEOM_METADATA
WHERE COLUMN_NAME = 'STGEOM';

INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
FROM   ALL_SDO_GEOM_METADATA T WHERE  T.TABLE_NAME = 'major_cities';

INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'MYST_COUNTRY_BOUNDARIES', 'STGEOM', T.DIMINFO, T.SRID
FROM   ALL_SDO_GEOM_METADATA T WHERE  T.TABLE_NAME = 'conuntry_boundaries';

--C.
DROP INDEX MYST_MAJOR_CITIES_IDX;
DROP INDEX MYST_COUNTRY_BOUNDARIES_IDX;

CREATE INDEX MYST_MAJOR_CITIES_IDX ON MYST_MAJOR_CITIES(STGEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

CREATE INDEX MYST_COUNTRY_BOUNDARIES_IDX ON myst_country_boundaries(STGEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

--D.
EXPLAIN PLAN FOR SELECT B.cntry_name A_NAME, COUNT(*)
FROM myst_country_boundaries B, myst_major_cities C
WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE' AND B.cntry_name = 'Poland' GROUP BY B.cntry_name;

SELECT plan_table_output FROM table(dbms_xplan.display('plan_table', null, 'basic'));
