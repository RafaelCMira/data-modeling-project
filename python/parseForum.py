import pandas as pd

df = pd.read_csv("forums.csv", sep="|")

forum_df = df.rename(
    columns={
        "id": "forum_id",
        "creationDate": "created_at",
        "ModeratorPersonId": "person_id",
    }
)

forum_final_df = forum_df[
    [
        "forum_id",
        "title",
        "created_at",
    ]
]

forum_final_df.to_csv("forum.csv", sep="|", index=False)

forum_moderator_final_df = forum_df[
    [
        "forum_id",
        "person_id",
    ]
]

forum_moderator_final_df.to_csv("forum_moderator.csv", sep="|", index=False)
