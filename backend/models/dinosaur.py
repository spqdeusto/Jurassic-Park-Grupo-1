from sqlalchemy import ForeignKey, Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float
from config.db import meta, engine

dinosaurs = Table("dinosaurs", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)),  
    Column("species", Integer, ForeignKey("species.id")),
    Column("age", Integer), 
    Column("weight", Float), 
    Column("gender", Integer, ForeignKey("genders.id")))

meta.create_all(engine)
