import pandas as pd
import os


# region knows

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_knows_Person"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

df = df.rename(
    columns={
        "Person1Id": "person_id1",
        "Person2Id": "person_id2",
        "creationDate": "created_at",
    }
)

df = df[
    [
        "person_id1",
        "person_id2",
        "created_at",
    ]
]

df.to_csv("knows.csv", sep="|", index=False)
# endregion


# region studies
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_studyAt_University"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

df = df.rename(
    columns={
        "PersonId": "person_id",
        "UniversityId": "university_id",
        "classYear": "class_year",
    }
)

df = df[
    [
        "person_id",
        "university_id",
        "class_year",
    ]
]

df.to_csv("studies.csv", sep="|", index=False)
# endregion


# region works

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_workAt_Company"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

df = df.rename(
    columns={
        "PersonId": "person_id",
        "CompanyId": "company_id",
        "workFrom": "work_from",
    }
)

df = df[
    [
        "person_id",
        "company_id",
        "work_from",
    ]
]

df.to_csv("works.csv", sep="|", index=False)
# endregion


# region message_tags
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Comment_hasTag_Tag"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

comment_df = df.rename(
    columns={
        "CommentId": "message_id",
        "TagId": "tag_id",
    }
)

comment_df = comment_df[
    [
        "message_id",
        "tag_id",
    ]
]

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Post_hasTag_Tag"

# Find the CSV file in the specified folder
csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

post_df = df.rename(
    columns={
        "PostId": "message_id",
        "TagId": "tag_id",
    }
)

post_df = post_df[
    [
        "message_id",
        "tag_id",
    ]
]

df = pd.concat([comment_df, post_df])

df.to_csv("message_tags.csv", sep="|", index=False)
# endregion


# region forum_tags
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Forum_hasTag_Tag"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

df = df.rename(
    columns={
        "ForumId": "forum_id",
        "TagId": "tag_id",
    }
)

df = df[
    [
        "forum_id",
        "tag_id",
    ]
]

df.to_csv("forum_tags.csv", sep="|", index=False)
# endregion


# region forum_members
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Forum_hasMember_Person"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

df = df.rename(
    columns={
        "ForumId": "forum_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)

df = df[
    [
        "forum_id",
        "person_id",
        "created_at",
    ]
]

df.to_csv("forum_members.csv", sep="|", index=False)
# endregion


# # region has_interest

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_hasInterest_Tag"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

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
# # endregion


# # region likes
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_likes_Post"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

post_df = df.rename(
    columns={
        "PostId": "message_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person_likes_Comment"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

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
# # endregion
