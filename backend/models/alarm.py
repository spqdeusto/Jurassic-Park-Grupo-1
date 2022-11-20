from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine

alarms = Table("alarms", meta, 
    Column("id", Integer, primary_key=True), 
    Column("name", String(255)), 
    Column("active", Boolean))

meta.create_all(engine)