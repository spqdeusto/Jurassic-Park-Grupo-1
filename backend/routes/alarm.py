from fastapi import APIRouter
from config.db import conn
from models.alarm import alarms
from schemas.alarm_schema import Alarm

alarm = APIRouter()

@alarm.get("/alarms", response_model= list[Alarm], tags= ["Alarms"], description= "Return all the alarms")
def get_alarms():
    return conn.execute(alarms.select()).fetchall()

@alarm.post("/alarms", response_model= Alarm, tags= ["Alarms"])
def create_alarm(alarm: Alarm):
    new_alarm = {"id": alarm.id, "name": alarm.name, "active": alarm.active}
    result = conn.execute(alarms.insert().values(new_alarm))
    return conn.execute(alarms.select().where(alarms.c.id == result.lastrowid)).first()

@alarm.get("/alarms/{id}", response_model= Alarm, tags= ["Alarms"])
def get_alarm(id: str):
    return conn.execute(alarms.select().where(alarms.c.id == id)).first()

@alarm.get("/alarms/delete/{id}", response_model= str, tags= ["Alarms"])
def delete_alarm(id: str):
    result = conn.execute(alarms.delete().where(alarms.c.id == id))
    return ("deleted alarm with id = " + id)

@alarm.put("/alarms/upate/{id}", response_model= Alarm, tags= ["Alarms"])
def upate_alarm(id: str, alarm: Alarm):
    result = conn.execute(alarms.update().values(name= alarm.name,
    active= alarm.active).where(alarms.c.id == id))
    return conn.execute(alarms.select().where(alarms.c.id == id)).first()