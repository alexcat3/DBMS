
CREATE TABLE actor(
	actor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE country(
	country_id INT PRIMARY KEY,
    country VARCHAR(64)
);

CREATE TABLE city(
	city_id INT PRIMARY KEY,
    city VARCHAR(64),
    country_id INT,
    
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE address(
	address_id INT PRIMARY KEY,
    address VARCHAR(50),
    address2 VARCHAR(50),
    district VARCHAR(50),
    city_id INT,
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    
    FOREIGN KEY(city_id) REFERENCES city(city_id)
);

CREATE TABLE language(
	language_id INT PRIMARY KEY,
    name VARCHAR(64)
);


CREATE TABLE film(
	film_id INT PRIMARY KEY,
    title VARCHAR(128),
    description TEXT(2048),
    release_year YEAR,
    language_id INT,
    
    rental_duration INT,
    rental_rate DECIMAL(9.2),
    length INT,
    replacement_cost DECIMAL(3.2),
    rating VARCHAR(5),
    special_features VARCHAR(20),
    
	CONSTRAINT RentalDays CHECK(rental_duration >=2 AND rental_duration <= 8),
	CONSTRAINT RentalRates CHECK(rental_rate >= .99 AND rental_rate <= 6.99),
    CONSTRAINT FilmLength CHECK(length >= 30 AND length <= 200),
    CONSTRAINT Ratings CHECK(rating IN ("PG", "G", "NC-17", "PG-13", "R")),
    CONSTRAINT ReplacementCostRange CHECK(replacement_cost >= 5 AND replacement_cost <= 100),
    
    FOREIGN KEY(language_id) REFERENCES language(language_id)
);

CREATE TABLE film_actor(
	actor_id INT,
    film_id INT,
    
    PRIMARY KEY(actor_id, film_id),
    FOREIGN KEY(actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY(film_id) REFERENCES film(film_id)
);

CREATE TABLE store(
	store_id INT PRIMARY KEY,
    address_id INT,
    
    FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE customer(
	customer_id INT PRIMARY KEY,
    store_id INT,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    email VARCHAR(128),
    address_id INT,
    active BOOL,
    
    FOREIGN KEY(store_id) REFERENCES store(store_id),
    FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE staff(
	staff_id INT PRIMARY KEY,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    address_id INT,
    
    email VARCHAR(128),
    store_id INT,
    active BOOL,
    username VARCHAR(64),
    password VARCHAR(64),
    
    FOREIGN KEY(address_id) REFERENCES address(address_id),
    FOREIGN KEY(store_id) REFERENCES store(store_id)
);

CREATE TABLE category(
	category_id INT PRIMARY KEY,
    name VARCHAR(16)
    
    CONSTRAINT ValidCategory CHECK(name IN ("Animation", "Comedy",
		"Family", "Foreign", "Sci-Fi", "Travel", "Children", "Drama", "Horror",
        "Action", "Classics", "Games", "New", "Documentary", "Sports", "Music"))
);

CREATE TABLE film_category(
	film_id INT,
    category_id INT,
    
    PRIMARY KEY(film_id, category_id),
    FOREIGN KEY(category_id) REFERENCES category(CATEGORY_ID),
    FOREIGN KEY(film_id) REFERENCES film(FILM_ID)
);

CREATE TABLE inventory(
	inventory_id INT PRIMARY KEY,
    film_id INT,
    store_id INT,
    
    FOREIGN KEY(film_id) REFERENCES film(film_id),
    FOREIGN KEY(store_id) REFERENCES store(store_id)
);

/* The schematic said that the rental dates, customer ids and inventory ids were supposed to be unique,
 but this conflicted with the CSV file, so I ommitted the unique constraint*/
CREATE TABLE rental(
	rental_id INT PRIMARY KEY,
    rental_date DATE,
    inventory_id INT,
    customer_id INT,
    return_date DATE,
    staff_id INT,
    
    FOREIGN KEY(inventory_id) REFERENCES inventory(inventory_id),
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE payment(
	payment_id INT PRIMARY KEY,
    customer_id INT,
    staff_id INT,
    rental_id INT,
    amount DECIMAL(9.2),
    payment_date DATE,
    
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY(rental_id) REFERENCES rental(rental_id)
);
    
    

    

