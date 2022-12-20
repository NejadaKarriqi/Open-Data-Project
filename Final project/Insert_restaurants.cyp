
//DELET PREVIOUS RESTAURANTS

MATCH (t:Restaurant)
DETACH DELETE t
RETURN count(t)


---------------------
// RESTAURANT  INSERTION
CREATE INDEX ON :Restaurant(name);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///Restaurants.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE NOT row.EQUIPAMENT IS NULL
MERGE (a:Restaurant {name:row.EQUIPAMENT})
WITH a, row.NUM_BARRI AS barri
MATCH (b:Neighbourhood {name:barri})
MERGE (a)-[:inNeighbourhood]->(b);

-----------------------

MATCH (n:Restaurant)-[:inNeighbourhood]->(r:Neighbourhood)<-[:inNeighbourhood]-(v:Address)<-[:hasAddress]-(a:Attraction)
WITH n,a
MERGE (n)-[:closeTo]->(a);
