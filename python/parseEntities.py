import pandas as pd
import os
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser()
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


def get_csv(base_path, target_file_name):
    csv_file = None

    # Construct the full directory path
    path = os.path.join(
        r"C:",
        "\\" + dataset_folder,
        r"graphs\csv\bi\composite-merged-fk\initial_snapshot",
        base_path.lstrip("\\"),
    )

    print(f"Searching in path: {path}")

    for file in os.listdir(path):
        if file == target_file_name:
            csv_file = os.path.join(path, file)
            break

    return csv_file


def read_and_combine_csvs(base_path, file_names):

    if file_names is None:
        df = pd.read_csv(get_file(base_path), sep="|")
    else:
        dataframes = []

        for file_name in file_names:
            file_path = get_csv(base_path, file_name)
            df = pd.read_csv(file_path, sep="|")
            dataframes.append(df)

        combined_df = pd.concat(dataframes, ignore_index=True)
        return combined_df


def write_file(df, file_name):
    output_file = os.path.join(output_directory, file_name)
    df.to_csv(output_file, sep="|", index=False)


# region Place
df = pd.read_csv(get_file(r"\static\Place"), sep="|")

# For city.csv: where type is 'City'
city_df = df[df["type"] == "City"].rename(
    columns={"id": "city_id", "PartOfPlaceId": "country_id"}
)
city_df = city_df[["city_id", "name", "country_id"]]
city_df["country_id"] = city_df["country_id"].astype(int)
write_file(city_df, "city.csv")

# For continent.csv: where type is 'Continent'
continent_df = df[df["type"] == "Continent"].rename(columns={"id": "continent_id"})
continent_df = continent_df[["continent_id", "name"]]
write_file(continent_df, "continent.csv")

# For country.csv: where type is 'Country'
country_df = df[df["type"] == "Country"].rename(
    columns={"id": "country_id", "PartOfPlaceId": "continent_id"}
)
country_df = country_df[["country_id", "name", "continent_id"]]
country_df["continent_id"] = country_df["continent_id"].astype(int)
write_file(country_df, "country.csv")
# endregion

# region Organisation
df = pd.read_csv(get_file(r"\static\Organisation"), sep="|")

# For company.csv: where type is 'Company'
company_df = df[df["type"] == "Company"].rename(
    columns={"id": "company_id", "LocationPlaceId": "country_id"}
)
company_df = company_df[["company_id", "name", "country_id"]]
write_file(company_df, "company.csv")

# For university.csv: where type is 'University'
university_df = df[df["type"] == "University"].rename(
    columns={"id": "university_id", "LocationPlaceId": "city_id"}
)
university_df = university_df[["university_id", "name", "city_id"]]
write_file(university_df, "university.csv")
# endregion

# region Forum
df = pd.read_csv(get_file(r"\dynamic\Forum"), sep="|")

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

write_file(forum_df, "forum.csv")
# endregion

# region Tags
df = pd.read_csv(get_file(r"\static\Tag"), sep="|")

tag_df = df.rename(
    columns={
        "id": "tag_id",
        "TypeTagClassId": "tag_class_id",
    }
)

tag_final_df = tag_df[["tag_id", "name", "tag_class_id"]]
write_file(tag_final_df, "tag.csv")


df = pd.read_csv(get_file(r"\static\TagClass"), sep="|")

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

write_file(tag_class_df, "tag_class.csv")
# endregion

# region Messages
post_df = pd.read_csv(get_file(r"\dynamic\Post"), sep="|")

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

neo4j_post_df = post_df[
    [
        "message_id",
        "browser_used",
        "location_ip",
        "content",
        "length",
        "language",
        "created_at",
        "country_id",
        "person_id",
        "forum_id",
    ]
]

write_file(neo4j_post_df, "neo4j_post.csv")

post_final_df = post_df[
    [
        "language",
        "message_id",
        "forum_id",
    ]
]

write_file(post_final_df, "post.csv")

comment_df = None

if dataset_folder == "ldbc_output_composite_merged-default_3":
    comment_files = [
        "part-00000-d2516fd1-8428-4cb6-b721-07290f94c9ed-c000.csv",
        "part-00001-d2516fd1-8428-4cb6-b721-07290f94c9ed-c000.csv",
        "part-00002-d2516fd1-8428-4cb6-b721-07290f94c9ed-c000.csv",
    ]

    comment_df = read_and_combine_csvs(r"\dynamic\Comment", comment_files)
else:
    comment_df = pd.read_csv(get_file(r"\dynamic\Comment"), sep="|")

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

neo4j_comment_df = comment_df[
    [
        "message_id",
        "browser_used",
        "location_ip",
        "content",
        "length",
        "created_at",
        "country_id",
        "person_id",
        "parent_id",
    ]
]

write_file(neo4j_comment_df, "neo4j_comment.csv")

comment_final_df = comment_df[
    [
        "message_id",
        "parent_id",
    ]
]

write_file(comment_final_df, "comment.csv")

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

write_file(messages_df, "message.csv")
# endregion

# region Persons

df = pd.read_csv(get_file(r"\dynamic\Person"), sep="|")

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

write_file(person_df, "person.csv")
# endregion
