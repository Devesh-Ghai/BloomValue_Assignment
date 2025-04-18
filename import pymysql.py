import pymysql
from sqlalchemy import create_engine
import pandas as pd 

# Establish a connection to the MySQL database using pymysql
db_connector = pymysql.connect(
    host="127.0.0.1",          # MySQL server host (localhost in this case)
    user="root",               # MySQL username (root in this case)
    password="GH1998devesh",   # MySQL password
    database="bloom_assignment"   # The name of the database you want to connect to
)

# Create an engine for connecting to MySQL using pymysql driver
engine = create_engine("mysql+pymysql://root:GH1998devesh@127.0.0.1/bloom_assignment")
# Create a connection to the database using the engine
try:
    # Try connecting to the database
    with engine.connect() as connection:
        print("The connection to the MySQL Engine is now functional.")
except Exception as e:
    print(f"Error occurred: {e}")

df = pd.read_csv('bv_details.csv')
df.columns = df.columns.str.replace(' ', '_')

df.to_sql('bv_details',con=engine,if_exists='append',index=False)

df1 = pd.read_csv('Total_bill.csv')
df1.to_sql('Total_bill',con=engine,if_exists='append',index=False)

df2 = pd.read_csv('Total_Bill_forecast.csv')
df2.to_sql('Total_Bill_forecast',con=engine,if_exists='append',index=False)

df3 = pd.read_csv('Bill_details.csv')
df3.columns = df3.columns.str.replace(' ', '_')
df3.to_sql('Bill_details',con=engine,if_exists='append',index=False)

df4 = pd.read_csv('Payment_mode_Bill_forecast.csv')
df4.to_sql('Payment_mode_Bill_forecast',con=engine,if_exists='append',index=False)

df5 = pd.read_csv('Anonymized_df.csv')
df5.to_sql('Anonymized_df',con=engine,if_exists='append',index=False)