package md.project.mySql.models;

public record Country(int country_id, String name) {
    @Override
    public String toString() {
        return "%d$%s".formatted(country_id, name);
    }
}
