import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

person_df = df.rename(
    columns={
        "id": "person_id",
        "firstName": "first_name",
        "lastName": "last_name",
        "browserUsed": "browser_used",
        "creationDate": "created_at",
        "locationIP": "location_ip",
        "LocationCityId": "city_id",
    }
)

person_df = person_df[
    [
        "person_id",
        "first_name",
        "last_name",
        "gender",
        "birthday",
        "browser_used",
        "location_ip",
        "created_at",
        "city_id",
    ]
]

person_df.to_csv("person.csv", sep="|", index=False)
