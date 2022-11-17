from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine

enclosures = Table("enclosures", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    Column("electricity", Boolean))

meta.create_all(engine)
