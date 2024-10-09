package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

public record Tag(int tag_id, String name) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%s".formatted(tag_id, name);
    }

    @Override
    public String csvHeader() {
        return "tag_id$name";
    }
}
