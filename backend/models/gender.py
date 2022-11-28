from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String
from config.db import meta, engine

genders = Table("genders", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)))

meta.create_all(engine)