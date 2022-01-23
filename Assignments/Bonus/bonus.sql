DECLARE
    v_donor_info GL_DONORS%ROWTYPE;
    v_pledge_amount NUMBER;
BEGIN
    SELECT *
    INTO v_donor_info
    FROM GL_DONORS
    WHERE DONOR_ID = :ENTER_DONOR_ID;
    v_pledge_amount := v_donor_info.monthly_pledge_amount * v_donor_info.pledge_months;
    DBMS_OUTPUT.PUT_LINE('Donor pledge for ' || v_donor_info.donor_name);
    DBMS_OUTPUT.PUT_LINE('Amount pledged: ' || TO_CHAR(v_pledge_amount, '$999.99'));
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;