import pandas as pd

post_df = pd.read_csv("posts.csv", sep="|")
comment_df = pd.read_csv("comments.csv", sep="|")

post_df = post_df.rename(
    columns={
        "id": "message_id",
        "browserUsed": "browser_used",
        "locationIP": "location_ip",
        "creationDate": "created_date",
        "locationCountryId": "country_id",
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

comment_df = comment_df.rename(
    columns={
        "id": "message_id",
        "browserUsed": "browser_used",
        "locationIP": "location_ip",
        "creationDate": "created_date",
        "locationCountryId": "country_id",
        "CreatorPersonId": "person_id",
    }
)

comment_df["parent_id"] = comment_df["ParentPostId"].fillna(
    comment_df["ParentCommentId"]
)

comment_final_df = comment_df[
    [
        "message_id",
        "parent_id",
    ]
]

post_final_df.to_csv("post.csv", sep="|", index=False)

comment_final_df.to_csv("comment.csv", sep="|", index=False)

messages_df = pd.concat([post_df, comment_df], ignore_index=True)

messages_df.to_csv("messages.csv", sep="|", index=False)
