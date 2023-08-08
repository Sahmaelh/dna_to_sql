import requests
import pyodbc

# DNA API URL and authentication (if required)
API_URL = 'https://api.example.com/dna'
HEADERS = {'Authorization': 'Bearer YOUR_API_TOKEN'}  # Replace with the actual authorization method

# SQL Server database connection configuration
DB_SERVER = 'your_server'
DB_DATABASE = 'your_database'
DB_USERNAME = 'your_username'
DB_PASSWORD = 'your_password'

def fetch_data_from_dna_api():
    try:
        response = requests.get(API_URL, headers=HEADERS)

        if response.status_code == 200:
            return response.json()
        else:
            print(f"API request failed with status code: {response.status_code}")
            return None

    except requests.exceptions.RequestException as e:
        print(f"API request failed with error: {e}")
        return None

def save_data_to_sql_server(data):
    try:
        # Establish SQL Server connection
        conn_str = f'DRIVER={{SQL Server}};SERVER={DB_SERVER};DATABASE={DB_DATABASE};UID={DB_USERNAME};PWD={DB_PASSWORD}'
        conn = pyodbc.connect(conn_str)

        cursor = conn.cursor()

        # Replace 'your_table' with the actual table where you want to store the data
        sql = "INSERT INTO your_table (column1, column2, ...) VALUES (?, ?)"

        for item in data:
            # Extract the relevant data from the API response and store it in the SQL Server database
            # Example: col1_value = item['key1'], col2_value = item['key2']
            col1_value = item['key1']
            col2_value = item['key2']

            cursor.execute(sql, col1_value, col2_value)
            conn.commit()

        cursor.close()
        conn.close()

        print("Data saved to SQL Server successfully.")
    except pyodbc.Error as e:
        print(f"Error while saving data to SQL Server: {e}")

if __name__ == "__main__":
    api_data = fetch_data_from_dna_api()

    if api_data:
        save_data_to_sql_server(api_data)