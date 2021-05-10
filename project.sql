--Functions & Procedures (at least 4)/4 3 
--Collections (Arrays, Records) (at least 4) 3
--Cursors (at least 4)/4 3
--Packages (at least 4)/4 2
--Triggers (at least 3)/2 3
--Transactions  3
--Usage of Dynamic SQL (at least 2) 4

create or replace PROCEDURE get_all_books (output OUT SYS_REFCURSOR) AS
BEGIN
open output for
SELECT * FROM books
order by rating desc;
END;

create or replace PROCEDURE get_books_by_genre (p_text in VARCHAR2, output OUT SYS_REFCURSOR) AS
BEGIN
open output for
SELECT * FROM books 
where genre LIKE '%'||p_text||'%'
order by rating desc;
END;

create or replace PROCEDURE get_books_by_id (p_loc in NUMBER, output OUT SYS_REFCURSOR) AS
BEGIN
open output for
SELECT * FROM books 
where book_id = p_loc;
END;

CREATE OR REPLACE PROCEDURE apply_discount (p_loc NUMBER, p_percent NUMBER) IS
cursor c_bookprice_cursor is 
    select *
    from books
    where genre = p_loc
    for update of price;
  r_book   c_bookprice_cursor%rowtype;
begin
open c_bookprice_cursor;
loop
    fetch c_bookprice_cursor into r_book;
    exit when c_bookprice_cursor%notfound;
    update books
    set    price = (1 - p_percent / 100) * price
    where current of c_bookprice_cursor;
  end loop;
end; 

create or replace PROCEDURE search_by_name (p_text in varchar2, output OUT SYS_REFCURSOR) AS
BEGIN
open output for
SELECT * FROM books 
where title LIKE '%'||p_text||'%';
END;

create or replace PROCEDURE search_by_author (p_text in varchar2, output OUT SYS_REFCURSOR) AS
BEGIN
open output for
SELECT * FROM books 
where author LIKE '%'||p_text||'%';
END;

cursor c_all_books is
    select *
    from books
    order by books.rating desc;

cursor c_30_books is
    select *
    from books
    where genre = '???????????? ??????????' and ROWNUM <= 30
    order by books.rating desc;

CREATE SEQUENCE sq_genre_table
START WITH 26 
INCREMENT BY 1 
NOMAXVALUE;

CREATE OR REPLACE TRIGGER tr_genre_table before INSERT ON genres FOR each row
BEGIN
  SELECT sq_genre_table.NEXTVAL
  INTO :new.genre_id
  FROM dual;
END;

CREATE OR REPLACE TRIGGER tr_insert_genre after INSERT ON books FOR each row
BEGIN
    INSERT INTO genres (genre_name) VALUES (:new.genre);
END;

declare 
    plsql_block VARCHAR2(500);
    genre_id VARCHAR2(200) := '???????????? ??????????';
    percent_amount number := 70;
begin
    plsql_block := 'begin apply_discount(:a, :b); end;';
    execute immediate plsql_block
        using in out genre_id, percent_amount;
end;

CREATE OR REPLACE PROCEDURE add_book (
  id IN OUT NUMBER,
  title  IN     VARCHAR2,
  author  IN     VARCHAR2,
  genre  IN     VARCHAR2
) AS
BEGIN
  INSERT INTO books (
    book_id,
    title,
    author,
    genre
  )
  VALUES (id, title, author, genre);
END;

DECLARE
  plsql_block VARCHAR2(500);
  new_id  NUMBER := 1452368;
  new_title   VARCHAR2(200) := 'My new book';
  new_author  VARCHAR2(200) := 'Dana K';
  new_genre   VARCHAR2(200) := 'fiction';
BEGIN
  plsql_block := 'BEGIN add_book(:a, :b, :c, :d); END;';
  EXECUTE IMMEDIATE plsql_block
    USING IN OUT new_id, new_title, new_author, new_genre;
END;

CREATE OR REPLACE PROCEDURE add_book (
  id IN OUT NUMBER,
  title  IN     VARCHAR2,
  author  IN     VARCHAR2,
  genre  IN     VARCHAR2
) AS
BEGIN
  INSERT INTO books (
    book_id,
    title,
    author,
    genre
  )
  VALUES (id, title, author, genre);
END;
DECLARE
  plsql_block VARCHAR2(500);
  new_id  NUMBER := 1452368;
  new_title   VARCHAR2(200) := 'My new book';
  new_author  VARCHAR2(200) := 'Dana K';
  new_genre   VARCHAR2(200) := 'fiction';
BEGIN
  plsql_block := 'BEGIN add_book(:a, :b, :c, :d); END;';
  EXECUTE IMMEDIATE plsql_block
    USING IN OUT new_id, new_title, new_author, new_genre;
END;
