/* SECOND TASK ASSIGNMENT FROM NETCRACKER

1)Написать функцию, которая вернет вложенную таблицу из имен сотрудников заданного подразделения.+
То есть, на вход этой функции передается ID подразделения. +
Учесть в коде, что такого подразделения может не быть и обработать исключительную ситуацию.+
Реализовать выборку через обычный CURSOR и через неявный (for I in (select …)). 
Написать PL/SQL блок, который вызовет вашу функцию и выведет результат на экран. Так же показать, как вызвать эту функцию из Select предложения. 
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE TYPE t_namesArray IS
    TABLE OF VARCHAR2(100);

/
CREATE OR REPLACE FUNCTION get_name (
    p_emp_dep_id IN NUMBER
) RETURN t_namesArray IS
    namesArray   t_namesArray;
BEGIN
    SELECT
        first_name
    BULK COLLECT
    INTO namesArray
    FROM
        employees
    WHERE
        department_id = p_emp_dep_id;
    RETURN namesArray;
END get_name;

/
ACCEPT var_dep_id NUMBER PROMPT 'What is the department id you are looking for?'
DECLARE
    dep_id NUMBER := &var_dep_id;
    namesArr   t_namesArray := get_name(dep_id);
BEGIN
    IF (dep_id > 110 and (dep_id mod 10 = 0)) THEN
        RAISE_APPLICATION_ERROR(-20008, 'This department doesn''t contain employyees or exist.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('OK, department with number '||dep_id||' has following employees:');
    
    FOR i IN namesArr.first..namesArr.last
    LOOP
        DBMS_OUTPUT.PUT_LINE(namesArr(i));
    END LOOP;
    
    EXCEPTION 
        WHEN others THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
/*
2)Создать пакет PKG_OPERATIONS. Описать спецификацию:
1. Создать процедуру make которая принимает на вход имя таблицы и название колонокю
2. создать процедуру add_row(table_name VARCHAR2, values VARCHAR2, cols VARCHAR2 := null);
3. Создать еще две процедуры на подобие первой, только для обновления и удаления строк.
4. Создать функцию remove, которая принимает на вход имя таблицы.
5. Создать тело пакета, в котором описать логику работы перечисленных процедур. 
Процедуры должны динамически создавать таблицы, делать все манипуляции с данными и удалять таблицу. Использовать Native Dynamic SQL.
6. Написать блок PL/SQL который вызовет процедуры вашего пакета и создаст таблицы, например: 

make(‘my_contacts’, ‘id number(4), name varchar2(40)');
add_row(‘my_contacts’,’1,’’Andrey Gavrilov’’’, ’id, name’);
upd_row(‘my_contacts’,’name=’’Andrey A. Gavrilov’’’, ‘id=2’);
remove(‘my_contacts’);

Все процедуры должны быть обработаны на возможные исключения. 
При вызове удаления таблицы – вывести количество строк, которые были удалены (использовать неявные курсоры SQL%...)
*/
/
CREATE OR REPLACE PACKAGE PKG_OPERATIONS IS
    PROCEDURE make (
        table_name IN VARCHAR2,
        column_name IN VARCHAR2
    );

    PROCEDURE add_row (
        table_name IN VARCHAR2,
        values_row IN VARCHAR2,
        cols IN VARCHAR2
    );

    PROCEDURE upd_row (
        table_name IN VARCHAR2,
        column_val IN VARCHAR2,
        val IN VARCHAR2
    );

    PROCEDURE remove_table (
        table_name IN VARCHAR2
    );

END PKG_OPERATIONS;
/
CREATE OR REPLACE PACKAGE BODY PKG_OPERATIONS AS

    PROCEDURE make (
        table_name VARCHAR2,
        column_name VARCHAR2
    ) IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE '
                          || table_name
                          || '('
                          || column_name
                          || ')';
        DBMS_OUTPUT.PUT_LINE('Table was created successfully');
    EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Creating table error');
                DBMS_OUTPUT.PUT_LINE('Exception: sqlcode='||SQLCODE||', sqlerrm='''||sqlerrm||'''');
    END make;
    
    PROCEDURE add_row (
        table_name IN  VARCHAR2,
        values_row IN VARCHAR2,
        cols IN VARCHAR2
    ) IS
    BEGIN
        EXECUTE IMMEDIATE 'INSERT INTO '
                        || table_name
                        || '(' 
                        || cols
                        || ')' 
                        || 'VALUES(' 
                        || values_row 
                        || ')';
        DBMS_OUTPUT.PUT_LINE('Rows were added successfully');
    EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Inserting data error');
                DBMS_OUTPUT.PUT_LINE('Exception: sqlcode='||SQLCODE||', sqlerrm='''||sqlerrm||'''');
    END add_row;
    
    PROCEDURE upd_row (
        table_name VARCHAR2,
        column_val VARCHAR2,
        val VARCHAR2
    ) AS
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE '
                          || table_name
                          || ' SET '
                          || column_val
                          || ' WHERE '
                          || val;
    DBMS_OUTPUT.PUT_LINE('Rows were updated successfully');
    EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Updating data error');
                DBMS_OUTPUT.PUT_LINE('Exception: sqlcode='||SQLCODE||', sqlerrm='''||sqlerrm||'''');          
    END upd_row;

    PROCEDURE remove_table (
        table_name IN VARCHAR2
    ) AS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE ' || table_name;
        DBMS_OUTPUT.PUT_LINE('Table was removed successfully');
        DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows deleted.');
    EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Removing table error');
                DBMS_OUTPUT.PUT_LINE('Exception: sqlcode='||SQLCODE||', sqlerrm='''||sqlerrm||'''');
    END remove_table;
    
END PKG_OPERATIONS;
/

BEGIN
    PKG_OPERATIONS.make('my_contacts', 'id number(4), name varchar2(40)');
    PKG_OPERATIONS.add_row('my_contacts', '1,''Vladislav Chernykh''', 'id, name');
    PKG_OPERATIONS.upd_row('my_contacts', q'[name='Vladislav Ya. Chernykh']', 'id=2');
    PKG_OPERATIONS.remove_table('my_contacts');  
END;
/
/*
Для тех, у кого не получится сделать задание номер 3, сделайте одно из следующих заданий:
2) Написать PL/SQL блок или SQL запрос, который посчитает количество всех счастливых билетов.
Мы знаем, что максимальное число, из которого может получиться счастливый билет – 999999.
*/
/
SET SERVEROUTPUT ON;

DECLARE
    total NUMBER := 1; -- 000000 case
    sum_first NUMBER := 0;
    sum_second NUMBER := 0;
    ch_iterNum VARCHAR2(50);
    d1 NUMBER := 0;
    d2 NUMBER := 0;
    d3 NUMBER := 0;
    d4 NUMBER := 0;
    d5 NUMBER := 0;
    d6 NUMBER := 0;
BEGIN
    FOR i IN 1..999999 LOOP
        ch_iterNum := TO_CHAR(i);
        -- Lucky tickets starts from 001001 (first ticket - 000001)
        -- first 2 digits have to be considered as zeros, if not specified in ch_iterNum
        IF (to_number(substr(ch_iterNum, 6, 1)) >= 0) THEN
            d1 := to_number(substr(ch_iterNum, 6, 1));
        END IF;
        IF (to_number(substr(ch_iterNum, 5, 1)) >= 0) THEN
            d2 := to_number(substr(ch_iterNum, 5, 1));
        END IF;
        d3 := to_number(substr(ch_iterNum, 4, 1));
        d4 := to_number(substr(ch_iterNum, 3, 1));
        d5 := to_number(substr(ch_iterNum, 2, 1));
        d6 := to_number(substr(ch_iterNum, 1, 1));
        sum_first := d1 + d2 + d3;
        sum_second := d4 + d5 + d6;
        IF ( sum_first = sum_second ) THEN
            total := total + 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total amount of lucky tickiets is ' || TO_CHAR(total));
END;


/
/*
4)Создать триггер и последовательность (sequence) на вставку данных в таблицу 
(создать свою таблицу, с любым набором полей, но чтобы там был PK_ID который не может быть пустым или null). 
Триггер должен реагировать, когда происходит вставка в вашу таблицу и записывать в поле PK_ID очередное уникальное значение из последовательности (nextval).
Написать PL/SQL блок или обычный вызов Insert предложения в вашу таблицу для демонстрации, как работает триггер. 
На вход НЕ должно быть подано значение PK_ID, оно должно генерится автоматически.
*/
/
CREATE TABLE books (
    id NUMBER(10)
        CONSTRAINT book_id_pk PRIMARY KEY NOT NULL,
    bookTitle VARCHAR2(50)
        CONSTRAINT bookTitle_nn NOT NULL,
    author VARCHAR2(50),
    year NUMBER(4)
);
/

CREATE SEQUENCE newBook_id 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;
/

CREATE OR REPLACE TRIGGER id_trigger BEFORE
    INSERT ON books
    FOR EACH ROW
BEGIN
    :new.id := newBook_id.nextval;
END;
/

    INSERT INTO books (
        bookTitle,
        author,
        year
    ) VALUES (
        'Take Me With You',
        'Catherine R.H',
        2014
    );

    INSERT INTO books (
        bookTitle,
        author,
        year
    ) VALUES (
        'Behind Closed Doors',
        'Paris B.A.',
        2016
    );
    
    INSERT INTO books (
        bookTitle,
        author,
        year
    ) VALUES (
        'Brave New World',
        'Huxley A.',
        1932
    );
/
SELECT * FROM books;
/