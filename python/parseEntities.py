import pandas as pd
import os

# region Place
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Place"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")


# For city.csv: where type is 'City'
city_df = df[df["type"] == "City"].rename(
    columns={"id": "city_id", "PartOfPlaceId": "country_id"}
)
city_df = city_df[["city_id", "name", "country_id"]]
city_df["country_id"] = city_df["country_id"].astype(int)
city_df.to_csv("city.csv", sep="|", index=False)

# For continent.csv: where type is 'Continent'
continent_df = df[df["type"] == "Continent"].rename(columns={"id": "continent_id"})
continent_df = continent_df[["continent_id", "name"]]
continent_df.to_csv("continent.csv", sep="|", index=False)

# For country.csv: where type is 'Country'
country_df = df[df["type"] == "Country"].rename(
    columns={"id": "country_id", "PartOfPlaceId": "continent_id"}
)
country_df = country_df[["country_id", "name", "continent_id"]]
country_df["continent_id"] = country_df["continent_id"].astype(int)
country_df.to_csv("country.csv", sep="|", index=False)
# endregion

# region Organisation
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Organisation"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break


df = pd.read_csv(csv_file, sep="|")

# For company.csv: where type is 'Company'
company_df = df[df["type"] == "Company"].rename(
    columns={"id": "company_id", "LocationPlaceId": "country_id"}
)
company_df = company_df[["company_id", "name", "country_id"]]
company_df.to_csv("company.csv", sep="|", index=False)

# For university.csv: where type is 'University'
university_df = df[df["type"] == "University"].rename(
    columns={"id": "university_id", "LocationPlaceId": "city_id"}
)
university_df = university_df[["university_id", "name", "city_id"]]
university_df.to_csv("university.csv", sep="|", index=False)
# endregion

# region Forum
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Forum"

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
# endregion

# region Tags
base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\static\Tag"

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
# endregion

# region Messages
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
# endregion

# region Persons

base_path = r"C:\ldbc_output_composite_merged-default\graphs\csv\bi\composite-merged-fk\initial_snapshot\dynamic\Person"

csv_file = None
for file in os.listdir(base_path):
    if file.endswith(".csv"):
        csv_file = os.path.join(base_path, file)
        break

df = pd.read_csv(csv_file, sep="|")

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

person_df.to_csv("person.csv", sep="|", index=False)
# endregion
