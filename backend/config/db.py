from sqlalchemy import create_engine, MetaData
from sqlalchemy_utils import database_exists, create_database

engine = create_engine("mysql+pymysql://root:example@mysql-fastapi:3306/mysql_jurasic")

if not database_exists(engine.url):
    create_database(engine.url)

meta = MetaData()

conn = engine.connect()