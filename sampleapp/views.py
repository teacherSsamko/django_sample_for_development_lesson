import os
from urllib.parse import quote_plus


from pymongo import MongoClient


host = "mongodb"
username = os.getenv("MONGO_INITDB_ROOT_USERNAME")
password = os.getenv("MONGO_INITDB_ROOT_PASSWORD")
uri = "mongodb://%s:%s@%s" % (quote_plus(username), quote_plus(password))
client = MongoClient(uri)
