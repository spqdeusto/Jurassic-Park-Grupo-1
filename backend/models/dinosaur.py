from sqlalchemy import ForeignKey, Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float
from config.db import meta, engine

dinosaurs = Table("dinosaurs", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    #relationship("species", primaryjoin="dinosaur.species == species.id", cascade="all, delete-orphan"), 
    Column("species", Integer, ForeignKey("species.id")),
    Column("age", Integer), 
    Column("weight", Float), 
    #relationship("genders", primaryjoin="dinosaur.gender == genders.id", cascade="all, delete-orphan"),
    Column("gender", Integer, ForeignKey("genders.id")))

meta.create_all(engine)
