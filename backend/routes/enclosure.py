from fastapi import APIRouter
from config.db import conn
from models.enclosure import enclosures
from schemas.enclosure_schema import Enclosure

enclosure = APIRouter()

@enclosure.get("/enclosures", response_model= list[Enclosure], tags= ["Enclosures"], description= "Return all the enclosures")
def get_enclosures():
    return conn.execute(enclosures.select()).fetchall()

@enclosure.post("/enclosures", response_model= Enclosure, tags= ["Enclosures"])
def create_enclosure(enclosure : Enclosure):
    new_enclosure = {"id": enclosure.id, "name": enclosure.name, "electricity": enclosure.electricity}
    result = conn.execute(enclosures.insert().values(new_enclosure))
    return conn.execute(enclosures.select().where(enclosures.c.id == result.lastrowid)).first()

@enclosure.get("/enclosures/{id}", response_model= Enclosure, tags= ["Enclosures"])
def get_enclosure(id: str):
    return conn.execute(enclosures.select().where(enclosures.c.id == id)).first()

@enclosure.get("/enclosures/delete/{id}", response_model= str, tags= ["Enclosures"])
def delete_enclosure(id: str):
    result = conn.execute(enclosures.delete().where(enclosures.c.id == id))
    return ("deleted enclosure with id = " + id)

@enclosure.put("/enclosures/update/{id}", response_model= Enclosure, tags= ["Enclosures"])
def update_enclosure(id: str, enclosure : Enclosure):
    result = conn.execute(enclosures.update().values(name= enclosure.name, 
    electricity= enclosure.electricity).where(enclosures.c.id == id))
    return conn.execute(enclosures.select().where(enclosures.c.id == id)).first()