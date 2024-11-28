import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Organisation"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

# For company.csv: where type is 'Company'
company_df = df[df["type"] == "Company"].rename(
    columns={"id": "company_id", "LocationPlaceId": "country_id"}
)
company_df = company_df[["company_id", "name", "country_id"]]
company_df.to_csv("company.csv", sep="|", index=False)

# For university.csv: where type is 'University'
university_df = df[df["type"] == "University"].rename(
    columns={"id": "university_id", "LocationPlaceId": "city_id"}
)
university_df = university_df[["university_id", "name", "city_id"]]
university_df.to_csv("university.csv", sep="|", index=False)
