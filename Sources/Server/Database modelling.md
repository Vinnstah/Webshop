#  <#Title#>



 DB Model
 Tables:
 users - add Admin value - active session
 active sessions (link with jwt)  - products / UUID
 products - title / description / image URL / price / category / SKU (UUID)
 categories - title / products


 Create a bootstrap init to add tables if they dont exist



MVP of productTable
CREATE TABLE products (
    title VARCHAR ( 50 ) PRIMARY KEY UNIQUE NOT NULL,
    description VARCHAR ( 250 ) UNIQUE,
    image_url VARCHAR ( 100 ) NOT NULL,
    price integer UNIQUE NOT NULL,
    category VARCHAR ( 50 ) NOT NULL,
    sub_category VARCHAR ( 50 ) NOT NULL,
    sku VARCHAR ( 50 ) UNIQUE NOT NULL
);


INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Catan', 'Your adventurous settlers seek to tame the remote but rich isle of Catan. Start by revealing Catan’s many harbors and regions: pastures, fields, mountains, hills, forests, and desert.', 'https://www.dragonslair.se/images/35257/original', 539, 'Games', 'Board Games', 'CTN101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Ticket to Ride', '2004 vann Ticket To Ride det prestigefyllda ”Spiel des Jahres” och det är numera i mångas ögon det perfekta gateway-spelet. Spelets enkla regler, med hög interaktion passar i princip alla, från nybörjare till inbitna brädspelare.', 'https://www.dragonslair.se/images/5883/product', 479, 'Games', 'Board Games', 'TTR101');




