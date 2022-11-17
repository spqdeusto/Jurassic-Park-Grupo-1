from sqlalchemy import Table, Column
from sqlalchemy.sql.sqltypes import Integer, String, Float, Boolean
from config.db import meta, engine

trucks = Table("trucks", meta, 
    Column("id", Integer, primary_key=True), 
    Column("onRute", Boolean), 
    Column("passengers", Integer), 
    Column("securitySystem", Boolean))

meta.create_all(engine)
