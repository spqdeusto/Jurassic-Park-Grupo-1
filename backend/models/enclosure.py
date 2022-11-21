from sqlalchemy import ForeignKey, Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine
from models.species import species

enclosures = Table("enclosures", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    Column("species", Integer, ForeignKey("species.id")), 
    Column("electricity", Boolean))

meta.create_all(engine)
