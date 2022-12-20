// ATTRACTION INSERTION
CREATE INDEX ON :Attraction(name);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row, split(row.title, "|") AS titles
UNWIND titles AS title
MERGE (a:Attraction {name:title});

-----------------------

// ABSTRACT INSERTION
CREATE INDEX ON :Abstract(description);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.description IS NULL
MERGE (a:Abstract {description:row.description})
WITH a, row.title AS title
MATCH (b:Attraction {name:title})
MERGE (b)-[:hasDescription]->(a);

---------------------

// WEB INSERTION
CREATE INDEX ON :Web(URL);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.url IS NULL
MERGE (w:Web{URL:row.url})
WITH w, row.title AS title
MATCH (b:Attraction {name:title})
MERGE (b)-[:hasWeb]->(w);

---------------------

// GEOCOORDENADES INSERTION
CREATE INDEX ON :GeoCoordenades(gmpax, gmapy);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.url IS NULL
MERGE (g:GeoCoordenades{gmapx:row.gmapx,gmapy:row.gmapy})
WITH g, row.title AS title
MATCH (a:Attraction {name:title})
MERGE (a)-[:hasCoordenades]->(g);

---------------------


// ADDRESS INSERTION
CREATE INDEX ON :Address(address);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.address IS NULL
MERGE (b:Address{address:row.address})
WITH b, row.title AS title
MATCH (a:Attraction {name:title})
MERGE (a)-[:hasAddress]->(b);


-----------------------

// NEIGHBOURHOOD INSERTION

CREATE INDEX ON :Neighbourhood(name);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.barri IS NULL
MERGE (b:Neighbourhood{name:row.barri})
WITH b, row.address AS address
MATCH (a:Address{address:address})
MERGE (a)-[:inNeighbourhood]->(b);


-----------------------

// DISTRICT INSERTION

CREATE INDEX ON :District(name);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.district IS NULL
MERGE (b:District{name:row.district})
WITH b, row.barri AS barri
MATCH (a:Neighbourhood{name:barri})
MERGE (a)-[:inDistrict]->(b);


-----------------------

// CITY INSERTION

CREATE INDEX ON :City(name);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.city IS NULL
MERGE (b:City{name:row.city})
WITH b, row.district AS district
MATCH (a:District{name:district})
MERGE (a)-[:inCity]->(b);


-----------------------

// TYPE INSERTION

CREATE INDEX ON :Type(type);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.type1 IS NULL
MERGE (b:Type{type:row.type1})
WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:ofType]->(b);


//MATCH ALSO WITH THE TYPES 2, 3 AND 4

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.type2 IS NULL
MATCH (b:Type)
WHERE b.type=row.type2
WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:ofType]->(b);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.type3 IS NULL
MATCH (b:Type)
WHERE b.type=row.type3
WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:ofType]->(b);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.type4 IS NULL
MATCH (b:Type)
WHERE b.type=row.type4
WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:ofType]->(b);


WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:ofType]->(b)
RETURN COUNT(*);

//delete the Level 1/2/3... AS A TYPE

MATCH (t:Type)
WHERE t.type CONTAINS 'Level'
SET t.type1=null
DETACH DELETE t
RETURN count(t)

//CONTACT INSERTION

CREATE INDEX ON :Contact(emailWeb, phone);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Barcelona_tourist_information.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.info  IS NULL
WITH row
WHERE NOT row.phone IS NULL
MERGE (b:Contact{emailWeb:row.info, phone:row.phone})
WITH b, row.title AS title
MATCH (a:Attraction{name:title})
MERGE (a)-[:hasContact]->(b);


//the phone numbers with a 10 treat it like null values

MATCH (t:Contact)
WHERE t.phone="10"
SET t.phone=null
RETURN count(t)
