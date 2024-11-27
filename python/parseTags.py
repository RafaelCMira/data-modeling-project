import pandas as pd

df = pd.read_csv("tags.csv", sep="|")

tag_df = df.rename(
    columns={
        "id": "tag_id",
        "TypeTagClassId": "tag_class_id",
    }
)

tag_df = tag_df[["tag_id", "name", "tag_class_id"]]

tag_df.to_csv("company.csv", sep="|", index=False)


df = pd.read_csv("tag_class.csv", sep="|")

tag_class_df = df.rename(
    columns={
        "id": "tag_class_id",
    }
)

tag_class_df = tag_class_df[["tag_class_id", "name"]]

tag_class_df.to_csv("tag_class.csv", sep="|", index=False)
