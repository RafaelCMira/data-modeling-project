import pandas as pd
import random

df_countries = pd.read_csv("countries.csv", delimiter="$")
df_countries["country_name"] = df_countries["country_name"].apply(
    lambda x: x.strip().replace("'", "").replace('"', "")
)

# Create a set of valid country names for quick lookup
valid_countries = set(df_countries["country_name"].values)

# Load the cities.csv file (the new file)
df_cities = pd.read_csv("source_cities.csv")

# Ensure the 'country' column in the cities file is cleaned from extra whitespace
df_cities["country"] = df_cities["country"].str.strip()

# Merge to get the country_id
merged_df = df_cities.merge(
    df_countries, left_on="country", right_on="country_name", how="inner"
)

# Select the columns "city", "country_id"
result_df = merged_df[["city", "country_id"]]

# Sort the result by country_id
filtered_cities_df = result_df.sort_values(by="country_id")

df_districts = pd.read_csv("districts.csv", delimiter="$")

# Initialize an empty list to store the results
output = []

# Loop through each city
for _, city_row in filtered_cities_df.iterrows():
    city_name = city_row["city"].strip().replace("'", "").replace('"', "")
    country_id = city_row["country_id"]

    # Filter districts by country_id
    possible_districts = df_districts[df_districts["country_id"] == country_id]

    # Choose a random district from the filtered districts
    if not possible_districts.empty:
        random_district = random.choice(possible_districts["district_name"].values)
        # Append the city, district, and country_id to the output list
        output.append([city_name, random_district, country_id])

# Create a dataframe from the output list
result_df = pd.DataFrame(output, columns=["city_name", "district_name", "country_id"])

# Save the result as a new CSV file
result_df.to_csv("cities.csv", index=False, sep="$")

print("File saved as cities.csv")
