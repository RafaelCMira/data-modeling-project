package md.project.mySql.models;

import md.project.mySql.CsvConvertible;

import java.sql.Date;
import java.sql.Timestamp;

public record Person(
        int person_id,
        String username,
        String first_name,
        String last_name,
        String email,
        String password,
        Date birthdate,
        Timestamp created_at,
        int born_country_id,
        String city_name,
        String district_name,
        int country_id
) implements CsvConvertible {
    @Override
    public String toString() {
        return "%d$%s$%s$%s$%s$%s$%s$%s$%d$%s$%s$%d".formatted(
                person_id, username, first_name, last_name, email, password, birthdate, created_at, born_country_id, city_name, district_name, country_id
        );
    }

    @Override
    public String csvHeader() {
        return "person_id$username$first_name$last_name$email$password$birthdate$created_at$born_country_id$city_name$district_name$country_id";
    }
}
