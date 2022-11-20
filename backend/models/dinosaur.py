from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine

dinosaurs = Table("dinosaurs", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    Column("species", String(255)), 
    Column("age", Integer), 
    Column("weight", Float), 
    Column("gender", String(255)))

meta.create_all(engine)
