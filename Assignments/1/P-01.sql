/* 1 */

/*
Asif Mahmud
C0837117
*/
DECLARE 
    curr_date DATE;
BEGIN
    --Executable section begins
    curr_date := SYSDATE;
    DBMS_OUTPUT.PUT_LINE(curr_date);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
--End of block


/* 2 */
Declare 
    v_counter Number(5);
Begin
    v_counter := v_counter+1;
    DBMS_OUTPUT.PUT_LINE(v_counter);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
-- Nothing happens. There's no output.

/* 3 */
Declare 
    v_counter Number(5) := 300;
Begin
    v_counter := v_counter+1;
    DBMS_OUTPUT.PUT_LINE(v_counter);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
-- output: 301

/* 4 */
Declare 
    v_counter Number(5) NOT NULL; 
Begin
    v_counter := v_counter+1;
    DBMS_OUTPUT.PUT_LINE(v_counter);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
-- output: error

/* 5 */
Declare 
    v_counter Number(5) NOT NULL := 500;
Begin
    v_counter := v_counter+1;
    DBMS_OUTPUT.PUT_LINE(v_counter);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
-- ouput: 501

/* 6 */
Declare 
    v_book_type VARCHAR(20) := 'fiction';
Begin
    DBMS_OUTPUT.PUT_LINE('The book type is' || ' ' || v_book_type);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 7 */
Declare 
    v_text VARCHAR(15);
Begin
    v_text := 'PL/SQL is easy'; 
    DBMS_OUTPUT.PUT_LINE(v_text);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 8 */
Declare 
    v_date Date := '2025-01-31';
Begin
    DBMS_OUTPUT.PUT_LINE('The test date is' || ' ' || v_date);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 9 */
Declare 
    v_today Date := SYSDATE;
Begin
    DBMS_OUTPUT.PUT_LINE('Today is' || ' ' || v_today);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 10 */
Declare 
    v_default_date Date DEFAULT SYSDATE;
Begin
    DBMS_OUTPUT.PUT_LINE('The default date is' || ' ' || v_default_date);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 11 */
Declare 
    TAX_RATE CONSTANT Number(5,2) := 0.13;
Begin
    DBMS_OUTPUT.PUT_LINE('The tax rate is' || ' ' || TAX_RATE*100 || ' percent');
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 12 */
-- It was declared as constant but not initialized.
DECLARE
    CONSTANT1 CONSTANT NUMBER := 5;
BEGIN
    DBMS_OUTPUT.PUT_LINE('The value is ' || CONSTANT1);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 13 */
DECLARE
    v_myname VARCHAR(20) := 'Asif';
BEGIN
    v_myname := 'Mahmud';
    DBMS_OUTPUT.PUT_LINE('My name is ' || v_myname);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 14 */
DECLARE
    TAX_RATE CONSTANT NUMBER(2,2) := .13;
    v_total_amount NUMBER(9,2) := 1025.00;
    v_tax_amount NUMBER(5,2); -- Not initialized
BEGIN
    v_tax_amount := v_total_amount * TAX_RATE;
    DBMS_OUTPUT.PUT_LINE(v_tax_amount);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;