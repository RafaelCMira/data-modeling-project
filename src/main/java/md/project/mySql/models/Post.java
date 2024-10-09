package md.project.mySql.models;


import md.project.mySql.CsvConvertible;
import java.sql.Timestamp;

public record Post(
        int post_id,
        String content,
        Timestamp created_at,
        int person_id
) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%s$%s$%d".formatted(post_id, content, created_at, person_id);
    }

    @Override
    public String csvHeader() {
        return "post_id$content$created_at$person_id";
    }
}
