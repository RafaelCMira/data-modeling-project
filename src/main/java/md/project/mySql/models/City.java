package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

public record City(String city_name, String district_name, int country_id) implements CsvConvertible {
    @Override
    public String toString() {
        return "%s$%s$%d".formatted(city_name, district_name, country_id);
    }

    @Override
    public String csvHeader() {
        return "city_name$district_name$country_id";
    }
}
