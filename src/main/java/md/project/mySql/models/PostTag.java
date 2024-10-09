package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

public record PostTag(int post_Id, int tag_Id) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%d".formatted(post_Id, tag_Id);
    }

    @Override
    public String csvHeader() {
        return "post_id$tag_id";
    }
}
