import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Tag"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

tag_df = df.rename(
    columns={
        "id": "tag_id",
        "TypeTagClassId": "tag_class_id",
    }
)

tag_final_df = tag_df[["tag_id", "name", "tag_class_id"]]

tag_final_df.to_csv("tag.csv", sep="|", index=False)


base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\TagClass"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

tag_class_df = df.rename(
    columns={
        "id": "tag_class_id",
        "SubclassOfTagClassId": "subclass_of",
    }
)

tag_class_df = tag_class_df[["tag_class_id", "name", "subclass_of"]]

# Convert subclass_of to integer, preserving null values
tag_class_df["subclass_of"] = pd.to_numeric(
    tag_class_df["subclass_of"], errors="coerce"
).astype("Int64")

tag_class_df.to_csv("tag_class.csv", sep="|", index=False)
