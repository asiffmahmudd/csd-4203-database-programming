
-- Detail Processing

CREATE OR REPLACE PROCEDURE order_listing_1 IS

  CURSOR orders_cursor IS
         SELECT  *  FROM cbv1  
         ORDER BY cust_state, cust_city, customer_id, order_id;
  orders_rec  orders_cursor%ROWTYPE;
  e_table_is_empty_exception  EXCEPTION;

  v_head1  VARCHAR2(80)  := LPAD('Order Totals by State, City and Customer', 40) || LPAD(TO_CHAR(SYSDATE, 'fmMonth DD, YYYY'), 25);
  v_head2  VARCHAR2(80)  := LPAD('-', LENGTH(v_head1), '-');
  v_head3  VARCHAR2(80)  := LPAD('State', 10) || LPAD('City', 10) || LPAD('ID', 10) || LPAD('Order', 10) || LPAD('Total', 10);
  v_head4  VARCHAR2(80)  := LPAD('-----', 10) || LPAD('----', 10) || LPAD('--', 10) || LPAD('-----', 10) || LPAD('-----', 10);

-----------------------------------------------------------------------------------------
--------------------------------------------------- Main Module (Execution Section) -----
-----------------------------------------------------------------------------------------
BEGIN
  OPEN  orders_cursor;
  FETCH orders_cursor  INTO orders_rec;
  IF orders_cursor%NOTFOUND THEN
     RAISE e_table_is_empty_exception;
  END IF;
  DBMS_OUTPUT.PUT_LINE (v_head1);
  DBMS_OUTPUT.PUT_LINE (v_head2);
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE (v_head3);
  DBMS_OUTPUT.PUT_LINE (v_head4);

  LOOP
    DBMS_OUTPUT.PUT_LINE(
      LPAD(orders_rec.cust_state, 10)          ||
      LPAD(RPAD(orders_rec.cust_city, 10), 16) ||
      LPAD(orders_rec.customer_id, 4)          ||
      LPAD(orders_rec.order_id, 10)            ||
      LPAD(TO_CHAR(orders_rec.total, 'FM99,999'), 10) );
    FETCH orders_cursor INTO orders_rec;
    EXIT WHEN orders_cursor%NOTFOUND;
  END LOOP;
  CLOSE orders_cursor;
EXCEPTION
  WHEN e_table_is_empty_exception THEN
    DBMS_OUTPUT.PUT_LINE('Table c6_orders is empty.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('An error occurred. Contact software support.');
END order_listing_1;


BEGIN
  order_listing;
END;