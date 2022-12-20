//ORDINARY QUERY
//Return the restaurants closer to a attractions that is placed the user and order them by the ratings of the restaurants

MATCH (u:User)-[:hasEatIn]->(r:Restaurant)-[:closeTo]->(a:Attraction)
WITH collect(u.name) AS client, r.name AS restaurant, a.name AS attraction
MATCH (r:restaurant)-[:hasPuntuation]->(p:Puntuation)
WITH client, restaurant, attraction, p.puntuation AS rating
RETURN client, restaurant, rating,  attraction
ORDER BY rating DESC
LIMIT 100

//------------------------------------------------

//JACCARD ALGORITHM
//recommend attractions in function of attractions visited by the similarity of it's tags
//for instace here we are recommending attractions in function a user that has just been in Parc Central de Nou Barris


MATCH (a1:Attraction{name:'Parc Central de Nou Barris'})-[:ofType]->(Type1)
WITH a1, collect(id(Type1)) AS a1Type
MATCH (a2:Attraction)-[:ofType]->(Type2) WHERE a1 <> a2
WITH a1, a1Type, a2, collect(id(Type2)) AS a2Type
RETURN a1.name AS from,
       a2.name AS to,
       algo.similarity.jaccard(a1Type, a2Type) AS similarity
ORDER BY similarity DESC

//recommend restaurants in function of restuarnts that had had similiar clients

MATCH (r1:Restaurant)<-[:hasEatIn]-(User1)
WITH r1, collect(id(User1)) AS r1User
MATCH (r2:Restaurant)<-[:hasEatIn]-(User2) WHERE r1 <> r2
WITH r1, r1User, r2, collect(id(User2)) AS r2User
RETURN r1.name AS from,
       r2.name AS to,
       algo.similarity.jaccard(r1User, r2User) AS similarity
ORDER BY similarity DESC
LIMIT 5


//-----------------------------------------------

//  STRONGLY CONNECTED COMPONENTS ALGORITHM
//find as the name of the algorithm says the restaurants that are more connected to a resturants by
//their relatinships between them and the attractions and join them in differnet segments to ease the recommendation.

CALL algo.scc.stream(
'MATCH (r:Restaurant) RETURN id(r) as id',
'MATCH (r1:Restaurant)-[:closeTo]->(a1:Attraction)<-[:closeTo]-(r2:Restaurant) RETURN id(r1) as source, id(r2) as target',
{write:true,graph:'cypher'})
YIELD nodeId, partition
WITH partition, COLLECT(nodeId) AS restaurants
RETURN partition, SIZE(restaurants) AS n_restaurants, restaurants
ORDER BY n_restaurants DESC;
