import pandas as pd

df = pd.read_csv('persons.csv', sep='|')

person_df = df.rename(columns={
    'id': 'person_id',
    'firstName': 'first_name',
    'lastName': 'last_name',
    'browserUsed': 'browser_used',
    'creationDate': 'created_at',
    'locationIP': 'location_ip',
    'LocationCityId': 'city_id'
})

person_df = person_df[['person_id', 'first_name', 'last_name', 'gender', 'birthday', 'browser_used', 'location_ip', 'created_at',  'city_id']]

person_df.to_csv('person.csv', sep='|', index=False)
