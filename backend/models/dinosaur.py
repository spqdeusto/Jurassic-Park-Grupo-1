from sqlalchemy import ForeignKey, Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine
from models.gender import genders
from models.species import species

dinosaurs = Table("dinosaurs", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    Column("species", Integer, ForeignKey("species.id")), 
    Column("age", Integer), 
    Column("weight", Float), 
    Column("gender", Integer, ForeignKey("genders.id")))

meta.create_all(engine)
