import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Forum"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

forum_df = df.rename(
    columns={
        "id": "forum_id",
        "creationDate": "created_at",
        "ModeratorPersonId": "person_id",
    }
)

forum_df = forum_df[
    [
        "forum_id",
        "title",
        "created_at",
        "person_id",
    ]
]

forum_df.to_csv("forum.csv", sep="|", index=False)
