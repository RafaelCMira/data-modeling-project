// How to delete all nodes and relationships 
```cypher
CALL apoc.periodic.iterate(
'MATCH (n) RETURN n',
'DETACH DELETE n',
{batchSize: 100000, parallel: true}
)
YIELD batches, total
RETURN batches, total;
```


// How to delete all constraints 
```cypher
CALL apoc.schema.assert({}, {})
```

// How to get all labels and their counts 
MATCH (n)
RETURN labels(n) AS label, count(n) AS node_count
ORDER BY node_count DESC;

// How to get all relationship types and their counts 
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS relationship_count
ORDER BY relationship_count DESC;

// How to get database size
:sysinfo





// How to delete a relationship
MATCH (comment:Comment)-[r:REPLY_OF]->(message:Message)
DELETE r;