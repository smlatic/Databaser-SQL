from sqlalchemy import create_engine, text
import pandas as pd
import getpass

# Ask for login credentials, database name, and book title
username = input("Please enter your username (leave blank): ")
password = getpass.getpass("Please enter your password (leave blank): ")
server_name = input("Please enter your server name(localhost): ")
database_name = input("Please enter your database name (my is 'bokhandel'): ")
book_title = input("Please enter the book title you want to search for (example:Book Title 1): ")

# Create a connection string
connection_string = f'mssql+pyodbc://{username}:{password}@{server_name}/{database_name}?driver=ODBC+Driver+17+for+SQL+Server'

# Create a database engine
engine = create_engine(connection_string)

# Connect to the database
conn = engine.connect()

# Define a function that performs a full-text search for a book title
def search_book_title(title):
    query = text("SELECT * FROM Böcker WHERE Titel LIKE :title")
    result = conn.execute(query, title=f'%{title}%')
    return pd.DataFrame(result.fetchall(), columns=result.keys())

# Define a function that gets the number of copies of each book in each store
def get_book_copies_in_stores():
    query = text("SELECT ButikID, ISBN13, Antal FROM LagerSaldo")
    result = conn.execute(query)
    return pd.DataFrame(result.fetchall(), columns=result.keys())

# Run the functions and print the results
print(search_book_title(book_title))
print(get_book_copies_in_stores())

# Close the connection
conn.close()
