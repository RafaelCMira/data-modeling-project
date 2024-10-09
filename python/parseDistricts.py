import pandas as pd

df_countries = pd.read_csv("countries.csv", delimiter='$')
df_countries["country_name"] = df_countries["country_name"].apply(
    lambda x: x.strip()
)

country_dict = df_countries.set_index("country_name")["country_id"].to_dict()

df_districts = pd.read_csv("source_districts.csv")

df_districts["country_name"] = df_districts["country_name"].str.strip()

output = []

for _, row in df_districts.iterrows():
    country_name = row["country_name"]

    # Check if the country_name exists in the countries dictionary
    if country_name in country_dict:
        country_id = country_dict[country_name]
        district_name = row["name"].strip().replace("'", "").replace('"', "")

        # Append the valid entry (district_name, country_id) to the output list
        output.append([district_name, country_id])

# Create a dataframe from the output list
result_df = pd.DataFrame(output, columns=["district_name", "country_id"])

result_df.to_csv("districts.csv", index=False, sep='$')

print("File saved as districts.csv")
