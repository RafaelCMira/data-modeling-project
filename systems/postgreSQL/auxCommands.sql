-- How to get the tables size

SELECT 
    t.relname AS table_name,
    ROUND(pg_total_relation_size(t.relid) / 1024.0^2, 2) AS total_size_mb,
    ROUND(pg_relation_size(t.relid) / 1024.0^2, 2) AS table_size_mb,
    ROUND((pg_total_relation_size(t.relid) - pg_relation_size(t.relid)) / 1024.0^2, 2) AS index_size_mb,
    TO_CHAR(c.reltuples::BIGINT, 'FM999 999 999 999') AS row_count
FROM 
    pg_catalog.pg_statio_user_tables t
JOIN 
    pg_catalog.pg_class c ON t.relid = c.oid
ORDER BY 
    pg_total_relation_size(t.relid) DESC;

