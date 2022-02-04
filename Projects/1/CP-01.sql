DECLARE
    v_loan_info GL_LOANS%ROWTYPE;
    v_loan_id NUMBER := :ENTER_LOAN_ID;
    v_h1 STRING(50) := 'Payment Schedule';
    v_h2 STRING(50) := LPAD('-', LENGTH(v_h1), '-');
    v_interest_discount NUMBER;
    v_new_interest_rate NUMBER;
    v_result_h STRING(100) := 'Month Interest Payment Balance';
    v_monthly_interest_rate NUMBER;
    v_interest_amount NUMBER;
    v_loan_amount NUMBER;
    v_monthly_payment NUMBER;
    v_month NUMBER := 0;

BEGIN
    SELECT *
    INTO v_loan_info
    FROM GL_LOANS
    WHERE v_loan_id = LOAN_ID;

    CASE 
    WHEN v_loan_info.credit_score <= 579 THEN 
        v_interest_discount := 0.00;
    WHEN v_loan_info.credit_score <= 669 THEN 
        v_interest_discount := 0.25;
    WHEN v_loan_info.credit_score <= 739 THEN 
        v_interest_discount := 0.50;
    WHEN v_loan_info.credit_score <= 799 THEN 
        v_interest_discount := 0.75;
    WHEN v_loan_info.credit_score <= 850 THEN 
        v_interest_discount := 1.00;
    END CASE;

    v_new_interest_rate := v_loan_info.annual_interest_rate - v_interest_discount;
    v_loan_amount := v_loan_info.loan_amount;
    v_monthly_payment := v_loan_info.monthly_payment;

    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_loan_info.first_name || ' ' || v_loan_info.last_name);
    DBMS_OUTPUT.PUT_LINE('Loan Amount: ' || TO_CHAR(v_loan_amount, 'FM$99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Annual Interest Rate: ' || TO_CHAR(v_loan_info.annual_interest_rate, 'FM90.90')  || '%');
    DBMS_OUTPUT.PUT_LINE('Credit Score: ' || v_loan_info.credit_score || ' ' || 'Interest Discount: ' || TO_CHAR(v_interest_discount, 'FM90.90') || '%');
    DBMS_OUTPUT.PUT_LINE('New Annual Interest Rate: ' || TO_CHAR(v_new_interest_rate, 'FM90.99')  || '%');
    DBMS_OUTPUT.PUT_LINE('Monthly Payment: ' || TO_CHAR(v_loan_info.monthly_payment, 'FM$999.90'));
    
    v_monthly_interest_rate := (v_new_interest_rate/12)/100;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(v_result_h);

    WHILE v_monthly_payment < v_loan_amount
    LOOP
        v_month := v_month + 1;
        v_interest_amount := v_monthly_interest_rate * v_loan_amount;
        v_loan_amount := v_loan_amount + v_interest_amount - v_monthly_payment;
        DBMS_OUTPUT.PUT_LINE(v_month || ' ' || TO_CHAR(v_interest_amount, 'FM999.90') || ' ' 
        || TO_CHAR(v_monthly_payment, 'FM999.90') || ' ' || TO_CHAR(v_loan_amount, 'FM$99,999.90'));
    END LOOP;
    v_month := v_month + 1;
    v_interest_amount := v_monthly_interest_rate * v_loan_amount;
    DBMS_OUTPUT.PUT_LINE(v_month || ' ' || TO_CHAR(v_interest_amount, 'FM999.90') || ' ' 
        || TO_CHAR(v_loan_amount, 'FM9990.90') || ' ' || TO_CHAR(0, 'FM$9990.90'));

    DBMS_OUTPUT.PUT_LINE('It takes ' || FLOOR(v_month/12) || ' years and ' || MOD(v_month,12)  || ' month(s) to pay this loan');
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;