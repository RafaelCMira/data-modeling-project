# How to delete all nodes and relationships in Neo4j

```cypher
CALL apoc.periodic.iterate(
'MATCH (n) RETURN n',
'DETACH DELETE n',
{batchSize: 100000, parallel: true}
)
YIELD batches, total
RETURN batches, total;
```

# How to delete all constraints in Neo4j

```cypher
CALL apoc.schema.assert({}, {})
```