import pandas as pd

df = pd.read_csv('places.csv', sep='|')

# For city.csv: where type is 'City'
city_df = df[df['type'] == 'City'].rename(columns={'id': 'city_id', 'PartOfPlaceId': 'country_id'})
city_df = city_df[['city_id', 'name', 'country_id']]
city_df.to_csv('city.csv', sep='|', index=False)

# For country.csv: where type is 'Continent'
country_df = df[df['type'] == 'Continent'].rename(columns={'id': 'continent_id'})
country_df = country_df[['continent_id', 'name']]
country_df.to_csv('country.csv', sep='|', index=False)

# For continent.csv: where type is 'Country'
continent_df = df[df['type'] == 'Country'].rename(columns={'id': 'country_id', 'PartOfPlaceId': 'continent_id'})
continent_df = continent_df[['country_id', 'name', 'continent_id']]
continent_df.to_csv('continent.csv', sep='|', index=False)

