/* 5 */
DECLARE
    v_loan_amount NUMBER;
    v_loan_payment NUMBER;
    v_equal_payment NUMBER;
    v_month NUMBER := 0;

    v_h1 STRING(50) := 'Payment#   Balance';
    v_h2 STRING(50) := '--------   -------';
BEGIN
    v_loan_amount := :ENTER_LOAN_AMOUNT;
    v_loan_payment := :ENTER_LOAN_PAYMENT;
    v_equal_payment := v_loan_amount/v_loan_payment;
    
    DBMS_OUTPUT.PUT_LINE('Loan Amount: ' || TO_CHAR(v_loan_amount,'FM$9,999.99'));
    DBMS_OUTPUT.PUT_LINE('Loan Payment: ' || TO_CHAR(v_loan_payment,'FM$9,999.99'));
    DBMS_OUTPUT.PUT_LINE('Equal Payments: ' || TO_CHAR(v_equal_payment,'FM99999'));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2); 
    
    LOOP
        v_loan_amount := v_loan_amount - v_loan_payment;
        v_month := v_month+1;
        DBMS_OUTPUT.PUT_LINE(v_month || '         ' || TO_CHAR(v_loan_amount, '9,999.99')); 
    EXIT WHEN v_loan_amount < v_loan_payment;
    END LOOP; 
        DBMS_OUTPUT.PUT_LINE('Outstanding balance: ' || TO_CHAR(v_loan_amount, 'FM$9,999.00')); 

EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


/* 6 */
DECLARE
    v_donor_id NUMBER := :ENTER_DONOR_ID;
    v_donor_info GL_DONORS%ROWTYPE;
    v_pledge_amount NUMBER;
    v_match_amount NUMBER;
    v_matching NUMBER;
    v_zero NUMBER := 0;
    v_five NUMBER := 5;
    v_ten NUMBER := 10;
    v_twenty NUMBER := 20;
    v_thirty NUMBER := 30;
    v_fifty NUMBER := 50;
    v_donor_type STRING(50);
    v_i STRING(20) := 'Individual';
    v_b STRING(50) := 'Business organization';
    v_g STRING(20) := 'Grant funds';
    v_individual STRING(5) := 'I';
    v_business STRING(5) := 'B';
    v_grants STRING(5) := 'G';

BEGIN
    SELECT *
    INTO v_donor_info
    FROM GL_DONORS
    WHERE v_donor_id = DONOR_ID;

    v_pledge_amount := v_donor_info.pledge_months * v_donor_info.monthly_pledge_amount;
 
    CASE v_donor_info.DONOR_TYPE
        WHEN v_individual THEN 
            v_donor_type := v_i;
            CASE 
                WHEN v_pledge_amount  >= 500 THEN v_matching := v_twenty;
                WHEN v_pledge_amount  >= 250 THEN v_matching := v_thirty;
                WHEN v_pledge_amount  >= 100 THEN v_matching := v_fifty;
                WHEN v_pledge_amount  < 100 THEN v_matching := v_zero;
            END CASE;
        WHEN v_business THEN 
            v_donor_type := v_b;
            CASE 
                WHEN v_pledge_amount  >= 1000 THEN v_matching := v_five;
                WHEN v_pledge_amount  >= 500 THEN v_matching := v_ten;
                WHEN v_pledge_amount  >= 100 THEN v_matching := v_twenty;
                WHEN v_pledge_amount  < 100 THEN v_matching := v_zero;
            END CASE;
        WHEN v_grants THEN 
            v_donor_type := v_g;
            CASE 
                WHEN v_pledge_amount  >= 100 THEN v_matching := v_five;
                WHEN v_pledge_amount  < 100 THEN v_matching := v_zero;
            END CASE;
    END CASE;
    
    v_match_amount := CEIL(v_pledge_amount * (v_matching/100));
    DBMS_OUTPUT.PUT_LINE('Donor pledge for ' || v_donor_info.donor_name);
    DBMS_OUTPUT.PUT_LINE('Donor type: ' || v_donor_type);
    DBMS_OUTPUT.PUT_LINE('Amount pledged: ' || TO_CHAR(v_pledge_amount, 'FM$9999.99'));
    DBMS_OUTPUT.PUT_LINE('Match amount: ' || TO_CHAR(v_match_amount, 'FM$9999.99'));
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;



/* 7 */
DECLARE
    v_donor_id NUMBER := :ENTER_DONOR_ID;
    v_donor_info GL_DONORS%ROWTYPE;
    v_pledge_amount NUMBER;
    v_total_months NUMBER;
    v_date DATE;
    v_day NUMBER;

    v_h1 STRING(100) := 'Pledge# Due Date Amount Balance';
    v_h2 STRING(100) := '------- -------- ------ -------';
    
    v_counter NUMBER;

BEGIN
    SELECT *
    INTO v_donor_info
    FROM GL_DONORS
    WHERE v_donor_id = DONOR_ID;

    v_pledge_amount := v_donor_info.pledge_months * v_donor_info.monthly_pledge_amount;
    v_total_months := Floor(v_pledge_amount/v_donor_info.monthly_pledge_amount);
    v_date := v_donor_info.registration_date;
    v_day := TO_NUMBER(TO_CHAR(v_date, 'dd'), '99');

    DBMS_OUTPUT.PUT_LINE('Donor pledge: ' || v_donor_info.donor_name);
    DBMS_OUTPUT.PUT_LINE('Registration date: ' || TO_CHAR(v_donor_info.REGISTRATION_DATE, 'FMMonth dd, yyyy'));
    DBMS_OUTPUT.PUT_LINE('Amount pledged: ' || TO_CHAR(v_pledge_amount, 'FM$9999.99'));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);

    FOR i IN 1 .. v_total_months LOOP
    IF v_day > 15 THEN 
        v_date := trunc(v_date,'mm') + 14;
    ELSIF v_day <= 15 
        THEN v_date := trunc(v_date,'mm');  
    END IF;
    v_date := TO_CHAR(ADD_MONTHS(v_date, 1));

    IF TO_CHAR(v_date, 'd') = '7' THEN
        v_date := v_date + 2;
    ELSIF TO_CHAR(v_date, 'd') = '1' THEN
        v_date := v_date + 1;
    END IF;
    v_pledge_amount := v_pledge_amount - v_donor_info.monthly_pledge_amount;
    DBMS_OUTPUT.PUT_LINE(i || '  ' || TO_CHAR(v_date, 'FMMon dd, yyyy') || ' ' 
    || TO_CHAR(v_donor_info.monthly_pledge_amount, '$999.99') || ' ' || TO_CHAR(v_pledge_amount, '$9990.99'));
    END LOOP;

EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
