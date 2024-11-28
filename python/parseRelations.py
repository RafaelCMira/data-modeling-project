import pandas as pd

# region knows
df = pd.read_csv("knows.csv", sep="|")

df = df.rename(
    columns={
        "Person1Id": "person_id1",
        "Person2Id": "person_id2",
        "creationDate": "created_at",
    }
)

df.to_csv("knows.csv", sep="|", index=False)
# endregion


# region studies
df = pd.read_csv("studies.csv", sep="|")

df = df.rename(
    columns={
        "PersonId": "person_id",
        "UniversityId": "university_id",
        "classYear": "class_year",
    }
)

df.to_csv("studies.csv", sep="|", index=False)
# endregion


# region works
df = pd.read_csv("works.csv", sep="|")

df = df.rename(
    columns={
        "PersonId": "person_id",
        "CompanyId": "company_id",
        "workFrom": "work_from",
    }
)

df.to_csv("works.csv", sep="|", index=False)
# endregion


# region message_tags
df = pd.read_csv("comment_tags.csv", sep="|")

comment_df = df.rename(
    columns={
        "CommentId": "message_id",
        "TagId": "tag_id",
    }
)

df = pd.read_csv("post_tags.csv", sep="|")

post_df = df.rename(
    columns={
        "PostId": "message_id",
        "TagId": "tag_id",
    }
)

df = pd.concat([comment_df, post_df])

df = df[
    [
        "message_id",
        "tag_id",
    ]
]

df.to_csv("message_tags.csv", sep="|", index=False)
# endregion

# region forum_tags
df = pd.read_csv("forum_tags.csv", sep="|")

df = df.rename(
    columns={
        "ForumId": "forum_id",
        "TagId": "tag_id",
    }
)

df.to_csv("forum_tags.csv", sep="|", index=False)
# endregion

# region forum_members
df = pd.read_csv("forum_members.csv", sep="|")

df = df.rename(
    columns={
        "ForumId": "forum_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)

df.to_csv("forum_members.csv", sep="|", index=False)
# endregion


# region has_interest
df = pd.read_csv("has_interest.csv", sep="|")

df = df.rename(
    columns={
        "PersonId": "person_id",
        "TagId": "tag_id",
    }
)

df = df[
    [
        "person_id",
        "tag_id",
    ]
]

df.to_csv("has_interest.csv", sep="|", index=False)
# endregion

# region likes
df = pd.read_csv("post_likes.csv", sep="|")

post_df = df.rename(
    columns={
        "PostId": "message_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)


df = pd.read_csv("comment_likes.csv", sep="|")

comment_df = df.rename(
    columns={
        "CommentId": "message_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)

df = pd.concat([post_df, comment_df])

df = df[
    [
        "person_id",
        "message_id",
        "created_at",
    ]
]

df.to_csv("likes.csv", sep="|", index=False)
# endregion
