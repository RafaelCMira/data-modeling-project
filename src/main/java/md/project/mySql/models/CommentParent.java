package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

public record CommentParent(int comment_id, int parent_id) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%d".formatted(comment_id, parent_id);
    }

    @Override
    public String csvHeader() {
        return "comment_id$parent_id";
    }
}
