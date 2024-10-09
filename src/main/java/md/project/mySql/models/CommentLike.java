package md.project.mySql.models;

import md.project.mySql.CsvConvertible;
import java.sql.Timestamp;

public record CommentLike(
        int comment_id,
        int person_id,
        Timestamp created_at
) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%d$%s".formatted(comment_id, person_id, created_at);
    }

    @Override
    public String csvHeader() {
        return "comment_id$person_id$created_at";
    }
}
