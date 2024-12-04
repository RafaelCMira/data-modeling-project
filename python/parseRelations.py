import pandas as pd
import os
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Process some integers.")
parser.add_argument(
    "--dataset_folder", type=str, required=True, help="Path to the dataset folder"
)
args = parser.parse_args()

output_directory = r"C:\temp"

dataset_folder = args.dataset_folder


def get_file(base_path):
    csv_file = None

    path = os.path.join(
        r"C:",
        "\\" + dataset_folder,
        r"graphs\csv\bi\composite-merged-fk\initial_snapshot",
        base_path.lstrip("\\"),
    )

    print(path)

    for file in os.listdir(path):
        if file.endswith(".csv"):
            csv_file = os.path.join(path, file)
            break
    return csv_file


def write_file(df, file_name):
    output_file = os.path.join(output_directory, file_name)
    df.to_csv(output_file, sep="|", index=False)


# region knows
df = pd.read_csv(get_file(r"\dynamic\Person_knows_Person"), sep="|")

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

write_file(df, "knows.csv")
# endregion


# region studies
df = pd.read_csv(get_file(r"\dynamic\Person_studyAt_University"), sep="|")

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

write_file(df, "studies.csv")
# endregion


# region works
df = pd.read_csv(get_file(r"\dynamic\Person_workAt_Company"), sep="|")

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

write_file(df, "works.csv")
# endregion


# region message_tags
df = pd.read_csv(get_file(r"\dynamic\Comment_hasTag_Tag"), sep="|")

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

df = pd.read_csv(get_file(r"\dynamic\Post_hasTag_Tag"), sep="|")

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

write_file(df, "message_tags.csv")
# endregion


# region forum_tags
df = pd.read_csv(get_file(r"\dynamic\Forum_hasTag_Tag"), sep="|")

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

write_file(df, "forum_tags.csv")
# endregion


# region forum_members
df = pd.read_csv(get_file(r"\dynamic\Forum_hasMember_Person"), sep="|")

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

write_file(df, "forum_members.csv")
# endregion


# # region has_interest
df = pd.read_csv(get_file(r"\dynamic\Person_hasInterest_Tag"), sep="|")

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

write_file(df, "has_interest.csv")
# # endregion


# # region likes
df = pd.read_csv(get_file(r"\dynamic\Person_likes_Post"), sep="|")

post_df = df.rename(
    columns={
        "PostId": "message_id",
        "PersonId": "person_id",
        "creationDate": "created_at",
    }
)

df = pd.read_csv(get_file(r"\dynamic\Person_likes_Comment"), sep="|")

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

write_file(df, "likes.csv")
# # endregion
