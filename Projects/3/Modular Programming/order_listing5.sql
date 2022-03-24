
-- Three-level control break

CREATE OR REPLACE PROCEDURE order_listing_5 IS
  PROCEDURE L1_break;   -- (Forward Declaration)
  PROCEDURE L2_break;
  PROCEDURE L3_break;

  CURSOR orders_cursor IS
         SELECT  *  FROM cbv1  
         ORDER BY cust_state, cust_city, customer_id, order_id;
  orders_rec  orders_cursor%ROWTYPE;

  hold_state        c6_orders.cust_state%TYPE;
  prt_state         c6_orders.cust_state%TYPE;
  hold_city         c6_orders.cust_city%TYPE;
  prt_city          c6_orders.cust_city%TYPE;
  hold_customer_id  c6_orders.customer_id%TYPE;
  prt_customer_id   VARCHAR(2);
  v_state_total     NUMBER(7) := 0;
  v_city_total      v_state_total%TYPE := 0;
  v_customer_total  v_state_total%TYPE := 0;
  v_company_total   v_state_total%TYPE := 0;
  SPACES CONSTANT   VARCHAR2(1) := ' ';
  ZEROS  CONSTANT   NUMBER   := 0;
  e_table_is_empty_exception  EXCEPTION;

  v_head1  VARCHAR2(80)  := LPAD('Order Totals by State, City and Customer', 40) || LPAD(TO_CHAR(SYSDATE, 'fmMonth DD, YYYY'), 25);
  v_head2  VARCHAR2(80)  := LPAD('-', LENGTH(v_head1), '-');
  v_head3  VARCHAR2(80)  := LPAD('State', 10) || LPAD('City', 10) || LPAD('ID', 10) || LPAD('Order', 10) || LPAD('Total', 10);
  v_head4  VARCHAR2(80)  := LPAD('-----', 10) || LPAD('----', 10) || LPAD('--', 10) || LPAD('-----', 10) || LPAD('-----', 10);
  v_head5  VARCHAR2(80)  := LPAD('-', 80, '-');
    
--------------------------------------------------- Initialization Sub-Procedure --------
  PROCEDURE initialization IS
  BEGIN
    OPEN  orders_cursor;
    FETCH orders_cursor  INTO orders_rec;
    IF orders_cursor%NOTFOUND THEN
      RAISE e_table_is_empty_exception;
    END IF;

    hold_state       := orders_rec.cust_state;
    prt_state        := orders_rec.cust_state;
    hold_city        := orders_rec.cust_city;
    prt_city         := orders_rec.cust_city;
    hold_customer_id := orders_rec.customer_id;  
    prt_customer_id  := orders_rec.customer_id; 
  
    DBMS_OUTPUT.PUT_LINE (v_head1);
    DBMS_OUTPUT.PUT_LINE (v_head2);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE (v_head3);
    DBMS_OUTPUT.PUT_LINE (v_head4);
  END Initialization;

PROCEDURE detail_processing IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(
      LPAD(prt_state, 10)           ||
      LPAD(RPAD(prt_city, 10), 16)  ||
      LPAD(prt_customer_id, 4)      ||
      LPAD(orders_rec.order_id, 10) ||
      LPAD(TO_CHAR(orders_rec.total, 'FM99,999'), 10) );
  
    v_customer_total := v_customer_total + orders_rec.total;
    prt_state       := SPACES;
    prt_city        := SPACES;
    prt_customer_id := SPACES;
  END detail_processing;

--------------------------------------------------- Check_Control_Breaks Sub-Procedure --
  PROCEDURE check_control_breaks IS
  BEGIN
    CASE
      WHEN orders_rec.cust_state <> hold_state THEN
           L1_break();              -- brackets optional when no arguments
           L2_break();
           L3_break();
      WHEN orders_rec.cust_city <> hold_city THEN
           L1_break;
           L2_break;
      WHEN orders_rec.customer_id <> hold_customer_id THEN
           L1_break;
      ELSE NULL;  -- No control break - Do Nothing
    END CASE;
  END check_control_breaks;

--------------------------------------------------- L1_Break Sub-Procedure --------------
PROCEDURE L1_break IS                            -- Customer id break
  BEGIN
    DBMS_OUTPUT.PUT_LINE(LPAD('Customer ' || hold_customer_id || ' total: ' || TO_CHAR(v_customer_total, 'FM9,999,999') || ' *', 52));
    DBMS_OUTPUT.NEW_LINE;
    v_city_total := v_city_total + v_customer_total; 
    v_customer_total := ZEROS;
    hold_customer_id := orders_rec.customer_id;
    prt_customer_id  := orders_rec.customer_id;
  END L1_break;

--------------------------------------------------- L2_Break Sub-Procedure --------------
  PROCEDURE L2_break IS                          -- City break
  BEGIN
    DBMS_OUTPUT.PUT_LINE(LPAD('City ' || hold_city || ' total: ' || TO_CHAR(v_city_total, '9,999,999') || ' **', 53));
    DBMS_OUTPUT.NEW_LINE;
    v_state_total := v_state_total + v_city_total; 
    v_city_total  := ZEROS;
    hold_city     := orders_rec.cust_city;
    prt_city      := orders_rec.cust_city;
  END L2_break;

--------------------------------------------------- L3_Break Sub-Procedure --------------
  PROCEDURE L3_break IS                          -- State Break
  BEGIN
    DBMS_OUTPUT.PUT_LINE(LPAD('State ' || hold_state || ' total: ' || TO_CHAR(v_state_total, 'FM9,999,999') || ' ***', 54));
    IF NOT orders_cursor%NOTFOUND THEN
      v_company_total := v_company_total + v_state_total;
      DBMS_OUTPUT.PUT_LINE (v_head5);
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE (v_head3);
      DBMS_OUTPUT.PUT_LINE (v_head4);
      v_state_total := ZEROS;
      hold_state := orders_rec.cust_state;
      prt_state := orders_rec.cust_state;
    END IF;
  END L3_break;

--------------------------------------------------- Termination Sub-Procedure -----------
PROCEDURE termination IS
  BEGIN
    L1_break;
    L2_break;
    L3_break;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(LPAD('Total company: ' || TO_CHAR(v_company_total, 'FM9,999,999') || ' ****', 55));
    CLOSE orders_cursor;
  END termination;

-----------------------------------------------------------------------------------------
--------------------------------------------------- Main Module (Execution Section) -----
-----------------------------------------------------------------------------------------
BEGIN
  initialization;
  LOOP
    check_control_breaks;
    detail_processing;
    FETCH orders_cursor INTO orders_rec;
    EXIT WHEN orders_cursor%NOTFOUND;
  END LOOP;
  termination;
  
EXCEPTION
  WHEN e_table_is_empty_exception THEN
    DBMS_OUTPUT.PUT_LINE('Table c6_orders is empty.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('An error occurred. Contact software support.');
END order_listing_5;


BEGIN
  order_listing;
END;