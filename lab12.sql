--1
CREATE TABLE personnel
    (id NUMBER(6) constraint personnel_id_pk PRIMARY KEY,
    last_name VARCHAR2(35),
    review CLOB,
    picture BLOB);
--2
INSERT INTO personnel
VALUES(2034, 'Allen', EMPTY_CLOB(), NULL);

INSERT INTO personnel
VALUES(2035, 'Bond', EMPTY_CLOB(), NULL);
--3
CREATE TABLE review_table
(employee_id number,
ann_review VARCHAR2(2000));

INSERT INTO review_table
VALUES(2034,'Very good performance this year. Recommended to 
	increase salary by $500');

INSERT INTO review_table
VALUES(2035,'Excellent performance this year. Recommended to 
    increase salary by $1000');
COMMIT;
--4
--a
UPDATE personnel
SET review = (SELECT ann_review
	FROM review_table
	WHERE employee_id = 2034)
WHERE last_name = 'Allen';
--b
DECLARE 
	lobloc CLOB; 
	text VARCHAR2(2000);
	amount NUMBER ;
	offset INTEGER;
BEGIN
	SELECT ann_review INTO text
	FROM review_table
	WHERE employee_id =2035;
	SELECT review INTO lobloc 
	FROM personnel 
	WHERE last_name = 'Bond' FOR UPDATE;
	offset := 1;
	amount := length(text);
	DBMS_LOB.WRITE ( lobloc, amount, offset, text );
END;
--5
--a
ALTER TABLE countries ADD (picture bfile);
--b
CREATE OR REPLACE PROCEDURE load_country_image (dir IN VARCHAR2) IS
 file BFILE;
 filename VARCHAR2(40);
 rec_number NUMBER;
 file_exists BOOLEAN;
 CURSOR country_csr IS
     SELECT country_id
     FROM countries
     WHERE region_id = 1
     FOR UPDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('LOADING LOCATORS TO IMAGES...');
    FOR rec IN country_csr
    LOOP
        filename := rec.country_id || '.gif';
        file := BFILENAME(dir, filename);
        file_exists := (DBMS_LOB.FILEEXISTS(file) = 1);
        IF file_exists THEN
            DBMS_LOB.FILEOPEN(file);
            UPDATE countries
                SET picture = file
                WHERE CURRENT OF country_csr;
            DBMS_OUTPUT.PUT_LINE('Set Locator to file: '|| filename ||
                ' Size: ' || DBMS_LOB.GETLENGTH(file));
            DBMS_LOB.FILECLOSE(file);
            rec_number := country_csr%ROWCOUNT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('File ' || filename ||' does not exist');
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTAL FILES UPDATED: ' || rec_number);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_LOB.FILECLOSE(file);
            DBMS_OUTPUT.PUT_LINE('Error: '|| to_char(SQLCODE) || SQLERRM);
END load_country_image; 
--c
SET SERVEROUTPUT ON
EXECUTE load_country_image('COUNTRY_PIC');
