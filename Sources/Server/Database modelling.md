#  <#Title#>



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
VALUES('Catan', 'Your adventurous settlers seek to tame the remote but rich isle of Catan. Start by revealing Catan’s many harbors and regions: pastures, fields, mountains, hills, forests, and desert.', 'https://www.dragonslair.se/images/35257/original', 539, 'Board Games', 'Classics', 'CTN101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Ticket to Ride', '2004 vann Ticket To Ride det prestigefyllda ”Spiel des Jahres” och det är numera i mångas ögon det perfekta gateway-spelet. Spelets enkla regler, med hög interaktion passar i princip alla, från nybörjare till inbitna brädspelare.', 'https://www.dragonslair.se/images/5883/product', 479, 'Board Games', 'Classics', 'TTR101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Caylus 1303', 'A classic game is back! As one of the first worker placement games, Caylus stands among the true board game classics of the 2000s. The original designers team, together with the Space Cowboys, have now created a revamped version!', 'https://www.dragonslair.se/images/58046/product', 525, 'Board Games', 'Classics', 'CLU101');

INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Diamant', 'Diamant är ett snabbspelat och roligt bluffspel för hela familjen.  Spelare är äventyrare som tillsammans utforskar en grotta genom att vända upp ett kort åt gången som visar vad nästa sektion i grottgången har att erbjuda, skatter eller fällor eller ingenting. Men innan nästa kort vänds upp måste spelare var för sig bestämma om de vill stanna kvar och fortsätta utforska eller om de vill vända hemåt med de skatter de samlat in, om du går hemåt får du både de skatter du själv bär på samt de som ligger bakom dig i grottan, men kruxet är att du måste dela dem med alla som går hem samtidigt som du.', 'https://www.dragonslair.se/images/41410/product', 279, 'Board Games', 'Classics', 'DMT101');


INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('Railroad Ink', 'In the multiplayer puzzle game Railroad Ink, your goal is to connect as many exits on your board as possible. Each round, a set of dice are rolled in the middle of the table, determining which kind of road and railway routes are available to all players. You have to draw these routes on your erasable boards to create transport lines and connect your exits, trying to optimize the available symbols better than your opponents.

The more exits you connect, the more points you score at the end of the game, but you lose points for each incomplete route, so plan carefully! Will you press your luck and try to stretch your transportation network to the next exit, or will you play it safe and start a new, simpler to manage route?

Railroad Ink comes in two versions, each one including two expansions with additional dice sets that add special rules to your games. The Blazing Red Edition includes the Lava and Meteor expansions. Try to confine the lava coming from the erupting volcano before it destroys your routes, or deal with the havoc brought by the meteor strikes and mine the craters for precious ore. These special rules can spice up things and make each game play and feel different.

Each box allows you to play from 1 to 6 players, and if you combine more boxes, you can play with up to 12 players (or more). The only limit to the number of players is the number of boards you have!', 'https://www.dragonslair.se/images/53107/original', 225, 'Board Games', 'Classics', 'RRI101');


INSERT INTO products(title, description, image_url, price, category, sub_category, sku)
VALUES('The Brothers War Set Booster Display', '
• 30 The Brothers War Set Boosters—the best MTG boosters to open just for fun
• 12 Magic: The Gathering cards per booster
• 1–5 cards of rarity Rare or higher in every pack
• Traditional Foil card and Art Card in every pack
• Travel back in time to command powerful artifacts and giant robots

The Brothers War Set Booster Box contains 30 The Brothers War Set Boosters. Each Set Booster contains 12 Magic cards, 1 Art Card, and 1 token/ad card or card from The List (a special card from Magics history—found in 25% of packs).

Every pack includes a combination of 1–5 card(s) of rarity Rare or higher and 3–7 Uncommon, 3–6 Common, and 1 Land cards. Traditional Foil Land replaces basic land in 20% of Set Boosters. Foil-Stamped Signature Art Card replaces Art Card in 10% of Set Boosters. Traditional Foil Borderless Mythic Rare Planeswalker in 1% of boosters.', 'https://www.dragonslair.se/images/93745/original', 1695, 'Magic: The Gathering', 'Displays', 'TBW101');


NEW DB MODEL

CREATE type productAndQuant as (
product_id uuid,
quantity integer);

CREATE TABLE boardgames (boardgame_id uuid PRIMARY KEY, title VARCHAR, image_url VARCHAR, publisher VARCHAR, release_date DATE, duration integer, description VARCHAR, age integer, players_min integer, players_max integer, category VARCHAR );

CREATE TABLE warehouse (warehouse_id uuid PRIMARY KEY,prod_id uuid , quantity integer );

<!--CREATE TABLE cart (cart_id uuid, product_id uuid[], quantity integer[], jwt VARCHAR PRIMARY KEY);-->

CREATE TABLE cart (cart_id uuid, jwt VARCHAR PRIMARY KEY);
CREATE TABLE cart_items (cart_id uuid, product_id uuid, quantity integer, UNIQUE(cart_id, product_id));

CREATE TABLE products (boardgame_id uuid, product_id uuid PRIMARY KEY, price integer, currency VARCHAR );


INSERT INTO boardgames(boardgame_id, title, image_url, publisher, release_date, duration, description, age, players_min, players_max, category)
VALUES(gen_random_uuid (), 'Railroad Ink', 'https://www.dragonslair.se/images/53107/original', 'CoolMiniOrNot Inc', '2012-01-01', 2, 'In the multiplayer puzzle game Railroad Ink, your goal is to connect as many exits on your board as possible. Each round, a set of dice are rolled in the middle of the table, determining which kind of road and railway routes are available to all players. You have to draw these routes on your erasable boards to create transport lines and connect your exits, trying to optimize the available symbols better than your opponents.

The more exits you connect, the more points you score at the end of the game, but you lose points for each incomplete route, so plan carefully! Will you press your luck and try to stretch your transportation network to the next exit, or will you play it safe and start a new, simpler to manage route?

Railroad Ink comes in two versions, each one including two expansions with additional dice sets that add special rules to your games. The Blazing Red Edition includes the Lava and Meteor expansions. Try to confine the lava coming from the erupting volcano before it destroys your routes, or deal with the havoc brought by the meteor strikes and mine the craters for precious ore. These special rules can spice up things and make each game play and feel different.

Each box allows you to play from 1 to 6 players, and if you combine more boxes, you can play with up to 12 players (or more). The only limit to the number of players is the number of boards you have!', 8, 1, 6, 'Strategy');

                    INSERT INTO warehouse
                    VALUES(gen_random_uuid (), gen_random_uuid (), 2)
                    ON CONFLICT (warehouse_id)
                    DO UPDATE
                    SET quantity=3;

            INSERT INTO cart
            VALUES('65F3787E-F457-4AA8-9E4B-E6131788AC88'::UUID, ARRAY ['72987608-7EB5-40D8-8DEC-27944EA93C51'::UUID], ARRAY [4], 'TEST1234')
            ON CONFLICT (jwt)
            DO NOTHING;
            
            INSERT INTO cart_items
            VALUES('65F3787E-F457-4AA8-9E4B-E6131788AC88'::UUID, '25F3787E-F457-4AA8-9E4B-E6131788AC88'::UUID, 5)
                        ON CONFLICT (cart_id, product_id)
            DO 
            UPDATE SET quantity=2;
            
            INSERT INTO cart
            VALUES('65F3787E-F457-4AA8-9E4B-E6131788AC88'::UUID, 'TEST1234');
