#  <#Title#>



 DB Model
 Tables:
 users - add Admin value - active session
 active sessions (link with jwt)  - products / UUID
 products - title / description / image URL / price / category / SKU (UUID)
 categories - title / products


 Create a bootstrap init to add tables if they dont exist

CREATE TABLE shopping_cart_items (
id VARCHAR PRIMARY KEY,
quantity integer,
price integer,
sku VARCHAR,
CONSTRAINT fk_cart
   FOREIGN KEY(id)
    REFERENCES shopping_session(session_id)
    );

CREATE TABLE shopping_session (
session_id VARCHAR PRIMARY KEY,
jwt VARCHAR,
CONSTRAINT fk_session
   FOREIGN KEY(jwt) 
      REFERENCES users(jwt)
) ;

MVP of productTable
CREATE TABLE products (
    title VARCHAR ( 50 ) PRIMARY KEY UNIQUE NOT NULL,
    description VARCHAR ( 1000 ),
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

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Caylus 1303', 'A classic game is back! As one of the first worker placement games, Caylus stands among the true board game classics of the 2000s. The original designers team, together with the Space Cowboys, have now created a revamped version!', 'https://www.dragonslair.se/images/58046/product', 525, 'Games', 'Board Games', 'CLU101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Diamant', 'iamant är ett snabbspelat och roligt bluffspel för hela familjen.  Spelare är äventyrare som tillsammans utforskar en grotta genom att vända upp ett kort åt gången som visar vad nästa sektion i grottgången har att erbjuda, skatter eller fällor eller ingenting. Men innan nästa kort vänds upp måste spelare var för sig bestämma om de vill stanna kvar och fortsätta utforska eller om de vill vända hemåt med de skatter de samlat in, om du går hemåt får du både de skatter du själv bär på samt de som ligger bakom dig i grottan, men kruxet är att du måste dela dem med alla som går hem samtidigt som du.', 'https://www.dragonslair.se/images/41410/product', 279, 'Games', 'Board Games', 'DMT101');





