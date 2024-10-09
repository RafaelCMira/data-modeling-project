package md.project.mySql.models;

public record District(
        String districtName,
        int countryId
) {
    @Override
    public String toString() {
        return "%s$%d".formatted(districtName, countryId);
    }
}
