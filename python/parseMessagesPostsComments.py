import pandas as pd
import os

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Post"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


post_df = pd.read_csv(csv_file, sep="|")

post_df = post_df.rename(
    columns={
        "id": "message_id",
        "browserUsed": "browser_used",
        "locationIP": "location_ip",
        "creationDate": "created_at",
        "LocationCountryId": "country_id",
        "CreatorPersonId": "person_id",
        "ContainerForumId": "forum_id",
    }
)

post_final_df = post_df[
    [
        "language",
        "message_id",
        "forum_id",
    ]
]

post_final_df.to_csv("post.csv", sep="|", index=False)


base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Comment"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

comment_df = pd.read_csv(csv_file, sep="|")

comment_df = comment_df.rename(
    columns={
        "id": "message_id",
        "browserUsed": "browser_used",
        "locationIP": "location_ip",
        "creationDate": "created_at",
        "LocationCountryId": "country_id",
        "CreatorPersonId": "person_id",
    }
)

comment_df["parent_id"] = comment_df["ParentPostId"].fillna(
    comment_df["ParentCommentId"]
)

comment_df["parent_id"] = comment_df["parent_id"].astype("Int64")

comment_final_df = comment_df[
    [
        "message_id",
        "parent_id",
    ]
]

comment_final_df.to_csv("comment.csv", sep="|", index=False)


post_df = post_df[
    [
        "message_id",
        "browser_used",
        "location_ip",
        "content",
        "length",
        "created_at",
        "country_id",
        "person_id",
    ]
]

comment_df = comment_df[
    [
        "message_id",
        "browser_used",
        "location_ip",
        "content",
        "length",
        "created_at",
        "country_id",
        "person_id",
    ]
]


messages_df = pd.concat([post_df, comment_df], ignore_index=True)

messages_df = messages_df[
    [
        "message_id",
        "browser_used",
        "location_ip",
        "content",
        "length",
        "created_at",
        "country_id",
        "person_id",
    ]
]

messages_df.to_csv("messages.csv", sep="|", index=False)
