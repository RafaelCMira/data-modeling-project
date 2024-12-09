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
);

MATCH (p:Person {person_id: 1796})
WITH id(p) AS sourceNodeId

MATCH (p:Person {person_id: 135})
WITH sourceNodeId, id(p) AS targetNodeId

CALL gds.shortestPath.yens.stream('myGraph', {
    sourceNode: sourceNodeId,
    targetNode: targetNodeId,
    k: 3
})
YIELD index, totalCost, nodeIds, path
RETURN
    totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).person_id] AS person_ids
ORDER BY totalCost;


CALL gds.graph.drop('myGraph')