---------- 1 ----------

CREATE TABLE product (
	prodCode VARCHAR(6) PRIMARY KEY NOT NULL,
	description VARCHAR(20),
	unit VARCHAR(3)
);

CALL SYSPROC.ADMIN_CMD('DESCRIBE TABLE product');

---------- 2 ----------

SELECT *
FROM product;

---------- 3 ----------

ALTER TABLE product
ADD CONSTRAINT unit_ck CHECK(
	unit IN ('pc','ea','pkg','mtr','ltr')
);

---------- 4 ----------

INSERT INTO product (prodCode, description, unit)
VALUES
	('PS0003','Cisco Virt Hardware','pcs'),
	('PC0002','Dell 745 Opti Desk','pg'),
	('PA0001','MS Ofc Business 2013','pk'),
	('AM0001','MS Wireless Mouse','pcs'),
	('AD0001','Toshiba Canvio 1 TB','eac');

---------- 5 ----------

CREATE TABLE priceHist (
	effDate DATE NOT NULL,
	prodCode VARCHAR(6) NOT NULL,
	unitPrice DECIMAL(10,2),
	PRIMARY KEY (effDate, prodCode),
	FOREIGN KEY (prodCode) REFERENCES product(prodCode)
);

ALTER TABLE priceHist
ADD CONSTRAINT unitp_ck CHECK(
	unitPrice > 0
);

CALL SYSPROC.ADMIN_CMD('DESCRIBE TABLE priceHist');

DROP TABLE priceHist;

---------- 6 ----------

INSERT INTO priceHist (effDate, prodCode, unitPrice)
VALUES
	('2010-05-15','NB0003',199),
	('2010-05-15','NB0004',279),
	('2010-05-15','NB0005',350);

---------- 7 ----------

INSERT INTO priceHist
VALUES ( '2011-02-01','PS0003',123.55 );

---------- 8 ----------

INSERT INTO priceHist
VALUES ( '2011-02-01','NB0005',-1.85 );





















