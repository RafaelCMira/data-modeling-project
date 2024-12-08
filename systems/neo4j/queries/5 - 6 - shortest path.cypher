// Find the shortest path between two people
MATCH p = shortestPath(
    (p1:Person {person_id: 1796})-[:KNOWS*]-(p2:Person {person_id: 135})
)
RETURN [n IN nodes(p) | n.person_id] AS person_ids





// Find the K shortest paths between two people
CALL gds.graph.project(
    'myGraph',
    ['Person'], // Node labels to include
    {
        KNOWS: {
            type: 'KNOWS',
            orientation: 'UNDIRECTED' // Use 'NATURAL' for directed relationships
        }
    }
)


MATCH (p:Person {person_id: 1796})
RETURN id(p) AS sourceNodeId;

MATCH (p:Person {person_id: 135})
RETURN id(p) AS targetNodeId;


CALL gds.shortestPath.yens.stream('myGraph', {
    sourceNode: 25660, // use the sourceNodeId from the first query
    targetNode: 25581, // use the targetNodeId from the second query
    k: 3 // Number of shortest paths to retrieve
})
YIELD index, totalCost, nodeIds, path
RETURN
    totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).person_id] AS person_ids
ORDER BY totalCost;



CALL gds.graph.drop('myGraph')