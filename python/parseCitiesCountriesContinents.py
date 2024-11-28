import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Place"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")


# For city.csv: where type is 'City'
city_df = df[df["type"] == "City"].rename(
    columns={"id": "city_id", "PartOfPlaceId": "country_id"}
)
city_df = city_df[["city_id", "name", "country_id"]]
city_df["country_id"] = city_df["country_id"].astype(int)
city_df.to_csv("city.csv", sep="|", index=False)

# For continent.csv: where type is 'Continent'
continent_df = df[df["type"] == "Continent"].rename(columns={"id": "continent_id"})
continent_df = continent_df[["continent_id", "name"]]
continent_df.to_csv("continent.csv", sep="|", index=False)

# For country.csv: where type is 'Country'
country_df = df[df["type"] == "Country"].rename(
    columns={"id": "country_id", "PartOfPlaceId": "continent_id"}
)
country_df = country_df[["country_id", "name", "continent_id"]]
country_df["continent_id"] = country_df["continent_id"].astype(int)
country_df.to_csv("country.csv", sep="|", index=False)
