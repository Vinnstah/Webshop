#  Old DB Model

 DB Model
 Tables:
 users - add Admin value - active session
 active sessions (link with jwt)  - products / UUID
 products - title / description / image URL / price / category / SKU (UUID)
 categories - title / products

Test Queries:
INSERT INTO shopping_session
VALUES('Test123','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBQzM3MjFBMi03OTUwLTQ3MzUtQkMyNy1GQUVBMzdDMTgyQjkiLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5zZSIsImlhdCI6MTY2NTA4NTczMi41MDkzMX0.qfgtrBqDOCp2FRF6eh9jDKn114BweI6BL9yGd0R3QOk')
ON CONFLICT (session_id)
DO NOTHING;

SELECT * FROM products, shopping_cart_items
WHERE products.sku = shopping_cart_items.sku
AND shopping_cart_items.session_id = '0855FE7F-E53F-4BF7-83CC-1186312D2BD3';

INSERT INTO shopping_cart_items
VALUES('2', '249FDFE6-A5A7-4F60-B37B-D90F2EFCF7FC', '2', '479', 'tests1')
ON CONFLICT (session_id, prod_id)
DO
UPDATE SET quantity = 2
;

 Create a bootstrap init to add tables if they dont exist

CREATE TABLE shopping_cart_items (
session_prod_id VARCHAR PRIMARY KEY,
session_id VARCHAR, 
prod_id VARCHAR,
quantity integer,
price integer,
sku VARCHAR);

CREATE TABLE shopping_session (
session_id VARCHAR,
jwt VARCHAR PRIMARY KEY,
db_id SERIAL);

CREATE TABLE products (
    prod_id SERIAL PRIMARY KEY,
    title VARCHAR,
    description VARCHAR,
    image_url VARCHAR,
    price integer,
    category VARCHAR,
    sub_category VARCHAR,
    sku VARCHAR UNIQUE
);


INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Catan', 'Your adventurous settlers seek to tame the remote but rich isle of Catan. Start by revealing Catan’s many harbors and regions: pastures, fields, mountains, hills, forests, and desert.', 'https://www.dragonslair.se/images/35257/original', 539, 'Games', 'Board Games', 'CTN101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Ticket to Ride', '2004 vann Ticket To Ride det prestigefyllda ”Spiel des Jahres” och det är numera i mångas ögon det perfekta gateway-spelet. Spelets enkla regler, med hög interaktion passar i princip alla, från nybörjare till inbitna brädspelare.', 'https://www.dragonslair.se/images/5883/product', 479, 'Games', 'Board Games', 'TTR101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Caylus 1303', 'A classic game is back! As one of the first worker placement games, Caylus stands among the true board game classics of the 2000s. The original designers team, together with the Space Cowboys, have now created a revamped version!', 'https://www.dragonslair.se/images/58046/product', 525, 'Games', 'Board Games', 'CLU101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Diamant', 'Diamant är ett snabbspelat och roligt bluffspel för hela familjen.  Spelare är äventyrare som tillsammans utforskar en grotta genom att vända upp ett kort åt gången som visar vad nästa sektion i grottgången har att erbjuda, skatter eller fällor eller ingenting. Men innan nästa kort vänds upp måste spelare var för sig bestämma om de vill stanna kvar och fortsätta utforska eller om de vill vända hemåt med de skatter de samlat in, om du går hemåt får du både de skatter du själv bär på samt de som ligger bakom dig i grottan, men kruxet är att du måste dela dem med alla som går hem samtidigt som du.', 'https://www.dragonslair.se/images/41410/product', 279, 'Games', 'Board Games', 'DMT101');



#  New DB Model

CREATE TABLE boardgames (
    db_id SERIAL PRIMARY KEY,
    boardgame_id VARCHAR,
    title VARCHAR,
    image_url: VARCHAR,
    publisher VARCHAR,
    release_date DATE,
    duration integer,
    players_min VARCHAR,
    players_max VARCHAR,
    category VARCHAR
);

CREATE TABLE warehouse (
    db_id SERIAL PRIMARY KEY,
    prod_id VARCHAR,
    quantity integer
);

CREATE TABLE cart (
    db_id SERIAL PRIMARY KEY,
    cart_id VARCHAR,
    product_id VARCHAR,
    quantity integer,
    jwt VARCHAR
);

CREATE TABLE product (
    db_id SERIAL PRIMARY KEY,
    boardgame_id VARCHAR,
    product_id VARCHAR,
    price integer,
    currency VARCHAR
);

CREATE TABLE cart_session (

);
