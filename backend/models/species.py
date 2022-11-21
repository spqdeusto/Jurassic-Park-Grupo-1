from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine

species = Table("species", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)),
    Column("dangerousness", Boolean))

meta.create_all(engine)
