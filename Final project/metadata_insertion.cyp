
//PUNTUATIONS INSERTION

CREATE INDEX ON :Puntuation(name,puntuation);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///TA_restaurants_curated.csv" AS row FIELDTERMINATOR ','
WITH row
WHERE row.City = "Barcelona"
WITH row
WHERE NOT row.Name IS  null
WITH row
WHERE NOT row.Rating IS null
MERGE (a:Puntuation {name:row.Name, puntuation:row.Rating})
WITH a
MATCH (r:Restaurant)
WITH toUpper(r.name) AS RESTAURANT, toUpper(a.name) AS PUNTUATION , a ,r
WITH replace(RESTAURANT, "RESTAURANT", "") AS parsedrestaurant, replace(PUNTUATION, "RESTAURANT", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "CLUB", "") AS parsedrestaurant, replace(parsedpuntuation, "CLUB", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "EXPERIENCE", "") AS parsedrestaurant, replace(parsedpuntuation, "EXPERIENCE", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "COOKING", "") AS parsedrestaurant, replace(parsedpuntuation, "COOKING", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "GRACIA", "") AS parsedrestaurant, replace(parsedpuntuation, "GRACIA", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "BAR", "") AS parsedrestaurant, replace(parsedpuntuation, "BAR", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "LA", "") AS parsedrestaurant, replace(parsedpuntuation, "LA", "") AS parsedpuntuation, a, r
WITH replace(parsedrestaurant, "EL", "") AS parsedrestaurant, replace(parsedpuntuation, "EL", "") AS parsedpuntuation, a, r
WITH trim(parsedrestaurant) AS parsedrestaurant, trim(parsedpuntuation) AS parsedpuntuation, a, r
WHERE right(parsedrestaurant,3)=right(parsedpuntuation,3) AND left(parsedrestaurant,3)=left(parsedpuntuation,3)
MERGE (r)-[:hasPuntuation]->(a);



------------------------------------

//USERS INSERTION CREATED RANDOMLY

CREATE INDEX ON :User(name, age, nationality);

//ONE PERSON FOREACH Restaurant

MATCH (r:Restaurant)
WITH COLLECT (r) AS restaurants
WITH ['OLIVIA','EVE','JULIA','AIME','HOLLIE','LYDIA','EVELYN','ALEXANDRA','MARIA','FRANCESCA','TILLY','FLORENCE','ALICIA','ABBIE','EMILIA','COURTNEY','MARYAM','ESME'] AS names,  ['Albania','Germany', 'Austria','Belgium','Belarus','Bulgaria','Croatia','Greece','Denmark','Scotland','Slovakia','Slovenia','Spain'] AS nationalities, ['10','11', '12','13','14','15','16','17','18','19','20','21', '22','23','24','25','26','27','28','29','30','31', '32','33','34','35','36','37','38','39','40','41', '42','43','44','45','46','47','48','49'] AS ages, restaurants
WITH names[toInteger(round(rand()*SIZE(names)-1))] AS name, nationalities[toInteger(round(rand()*SIZE(nationalities)-1))] AS nationality, ages[toInteger(round(rand()*SIZE(ages)-1))] AS age
CREATE (r)<-[:hasEatIn]-(:User {name:name, age:age, nationality:nationality});

//INIDIVIDUAL INSERTION

MATCH (r:Restaurant)
WITH COLLECT (r) AS restaurants
WITH ['OLIVIA','EVE','JULIA','AIME','HOLLIE','LYDIA','EVELYN','ALEXANDRA','MARIA','FRANCESCA','TILLY','FLORENCE','ALICIA','ABBIE','EMILIA','COURTNEY','MARYAM','ESME'] AS names,  ['Albania','Germany', 'Austria','Belgium','Belarus','Bulgaria','Croatia','Greece','Denmark','Scotland','Slovakia','Slovenia','Spain'] AS nationalities, ['10','11', '12','13','14','15','16','17','18','19','20','21', '22','23','24','25','26','27','28','29','30','31', '32','33','34','35','36','37','38','39','40','41', '42','43','44','45','46','47','48','49'] AS ages, restaurants
WITH names[toInteger(round(rand()*SIZE(names)-1))] AS name, nationalities[toInteger(round(rand()*SIZE(nationalities)-1))] AS nationality, ages[toInteger(round(rand()*SIZE(ages)-1))] AS age, restaurants[toInteger(rand()*(SIZE(restaurants)-1))] AS r
CREATE (r)<-[:hasEatIn]-(:User {name:name, age:age, nationality:nationality});
