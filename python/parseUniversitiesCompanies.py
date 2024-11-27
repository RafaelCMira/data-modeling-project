import pandas as pd

df = pd.read_csv("organizations.csv", sep="|")

# For company.csv: where type is 'Company'
company_df = df[df["type"] == "Company"].rename(
    columns={"id": "company_id", "LocationPlaceId": "country_id"}
)
company_df = company_df[["city_id", "name", "country_id"]]
company_df.to_csv("company.csv", sep="|", index=False)

# For university.csv: where type is 'University'
university_df = df[df["type"] == "University"].rename(
    columns={"id": "university_id", "LocationPlaceId": "city_id"}
)
university_df = university_df[["continent_id", "name", "city_id"]]
university_df.to_csv("university.csv", sep="|", index=False)
