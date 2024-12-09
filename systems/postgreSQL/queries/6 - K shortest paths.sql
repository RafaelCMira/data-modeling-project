-- Multiple shortest paths between two users
WITH path AS (
    SELECT * FROM pgr_ksp(
        'SELECT id, source, target, cost FROM edges',
        17592186047566, -- Start node
        21990232558093, -- End node
        3 -- number of paths
    )
)
SELECT 
    path.path_id, 
    array_agg(p.person_id ORDER BY path.seq) AS path_nodes
FROM path
    JOIN person p ON p.person_id = path.node
GROUP BY path.path_id
ORDER BY path.path_id;