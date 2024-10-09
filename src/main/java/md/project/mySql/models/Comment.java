package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

import java.sql.Timestamp;

public record Comment(
        int comment_id,
        String msg,
        Timestamp created_at,
        int person_id,
        int post_id
) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%s$%s$%d$%d".formatted(comment_id, msg, created_at, person_id, post_id);
    }

    @Override
    public String csvHeader() {
        return "comment_id$msg$created_at$person_id$post_id";
    }
}
