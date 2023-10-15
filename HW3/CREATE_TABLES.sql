CREATE TABLE merchants(
	mid  INT,
	name VARCHAR(30),
	city VARCHAR(30),
	state CHAR(20),

	PRIMARY KEY(mid)
);

CREATE TABLE products(
	pid INT,
    name VARCHAR(20),
    category VARCHAR(20),
    description VARCHAR(500),
    
    PRIMARY KEY(pid),
    CHECK(name IN ('Printer', 'Ethernet Adapter', 'Desktop', 'Hard Drive', 
		'Laptop', 'Router', 'Network Card', 'Super Drive', 'Monitor')),
	CHECK(category IN ('Peripheral', 'Networking', 'Computer'))
);


CREATE TABLE sell(
	mid INT,
    pid INT,
    price DECIMAL(10,2),
    quantity_available INT,
    
    PRIMARY KEY(mid, pid),
    FOREIGN KEY(mid) REFERENCES merchants(mid),
    FOREIGN KEY(pid) REFERENCES products(pid),
    CHECK(quantity_available >= 0 AND quantity_available <= 1000)
);


CREATE TABLE orders(
	oid INT,
    shipping_method VARCHAR(10),
    shipping_cost DECIMAL(10,2),
    
    PRIMARY KEY(oid),
    CHECK(shipping_method IN ('UPS', 'FedEx', 'USPS')),
    CHECK(shipping_cost >= 0 AND shipping_cost <= 500)
);


CREATE TABLE contain(
	oid INT,
    pid INT,
    
    PRIMARY KEY(oid, pid),
    FOREIGN KEY(oid) REFERENCES orders(oid),
    FOREIGN KEY(pid) REFERENCES products(pid)
);

CREATE TABLE customers(
	cid INT,
    fullname VARCHAR(60),
    city VARCHAR(30),
    state CHAR(20),
    
    PRIMARY KEY(cid)
);

CREATE TABLE place(
	cid INT,
    oid INT,
    order_date DATE,
    
    PRIMARY KEY(cid, oid),
    FOREIGN KEY(cid) REFERENCES customers(cid),
    FOREIGN KEY(oid) REFERENCES orders(oid)
);