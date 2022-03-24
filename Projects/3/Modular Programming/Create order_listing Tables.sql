DROP TABLE c6_orders;
CREATE TABLE c6_orders (
cust_state  VARCHAR(2),
cust_city   VARCHAR(20),
customer_id DECIMAL(3),
order_id    DECIMAL(3),
total       DECIMAL(5) );

INSERT ALL
INTO c6_orders VALUES('ON', 'Sarnia',  11, 101, 1500)
INTO c6_orders VALUES('MI', 'Detroit', 12, 102, 2100)
INTO c6_orders VALUES('FL', 'Orlando', 13, 103, 3300)
INTO c6_orders VALUES('ON', 'London',  14, 104, 250) 
INTO c6_orders VALUES('FL', 'Miami',   15, 105, 500)
INTO c6_orders VALUES('MI', 'Flint',   16, 106, 100)
INTO c6_orders VALUES('ON', 'Toronto', 17, 107, 300)

INTO c6_orders VALUES('ON', 'Sarnia',  11, 108, 500)
INTO c6_orders VALUES('MI', 'Detroit', 12, 109, 100)
INTO c6_orders VALUES('FL', 'Orlando', 13, 110, 300)
INTO c6_orders VALUES('ON', 'London',  14, 111, 250) 
INTO c6_orders VALUES('FL', 'Miami',   15, 112, 500)
INTO c6_orders VALUES('MI', 'Flint',   16, 113, 100)
INTO c6_orders VALUES('ON', 'Toronto', 17, 114, 300)

INTO c6_orders VALUES('ON', 'Sarnia',  18, 115, 500)
INTO c6_orders VALUES('MI', 'Detroit', 19, 116, 100)
INTO c6_orders VALUES('FL', 'Orlando', 20, 117, 300)
INTO c6_orders VALUES('ON', 'London',  21, 118, 250) 
INTO c6_orders VALUES('FL', 'Miami',   22, 119, 500)
INTO c6_orders VALUES('MI', 'Flint',   23, 120, 100)
INTO c6_orders VALUES('ON', 'Toronto', 24, 121, 300)

INTO c6_orders VALUES('ON', 'Sarnia',  18, 122, 500)
INTO c6_orders VALUES('MI', 'Detroit', 19, 123, 100)
INTO c6_orders VALUES('FL', 'Orlando', 20, 124, 300)
INTO c6_orders VALUES('ON', 'London',  21, 125, 250) 
INTO c6_orders VALUES('FL', 'Miami',   22, 126, 500)
INTO c6_orders VALUES('MI', 'Flint',   23, 127, 100)
INTO c6_orders VALUES('ON', 'Toronto', 24, 128, 300)

INTO c6_orders VALUES('FL', 'Miami',   15, 129, 500)
INTO c6_orders VALUES('FL', 'Miami',   22, 130, 100)
INTO c6_orders VALUES('FL', 'Miami',   15, 131, 300)
SELECT * FROM DUAL;

CREATE OR REPLACE VIEW cbv1 AS
SELECT * FROM c6_orders;
