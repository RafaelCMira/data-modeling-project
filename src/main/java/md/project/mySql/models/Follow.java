package md.project.mySql.models;

import md.project.mySql.CsvConvertible;
import java.sql.Timestamp;

public record Follow(
        int person_id,
        int follower_id,
        Timestamp created_at
) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%d$%s".formatted(person_id, follower_id, created_at);
    }

    @Override
    public String csvHeader() {
        return "person_id$follower_id$created_at";
    }
}
