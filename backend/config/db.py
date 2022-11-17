from sqlalchemy import create_engine, MetaData

engine = create_engine("mysql+pymysql://root:example@localhost:3306/mysql_jurasic")

meta = MetaData()

conn = engine.connect()