from fastapi import APIRouter
from config.db import conn
from models.gender import genders
from schemas.gender_schema import Gender

gender = APIRouter()

@gender.get("/genders", response_model= list[Gender], tags= ["Genders"], description= "**Return all** the genders", response_description="All the genders")
def get_genders():
    return conn.execute(genders.select()).fetchall()

@gender.post("/genders", response_model= Gender, tags= ["Genders"], description="**Create** a gender.", response_description="Created gender")
def create_gender(gender: Gender):
    new_gender = {"id": gender.id, "name": gender.name}
    result = conn.execute(genders.insert().values(new_gender))
    return conn.execute(genders.select().where(genders.c.id == result.lastrowid)).first()

@gender.get("/genders/{id}", response_model= Gender, tags= ["Genders"], description="**Return one** gender with Id.", response_description="Gender with given Id")
def get_gender(id: str):
    return conn.execute(genders.select().where(genders.c.id == id)).first()

@gender.get("/genders/delete/{id}", response_model= str, tags= ["Genders"], description="**Delete one** gender with Id.", response_description="String with message: delated gender and Id")
def delete_gender(id: str):
    result = conn.execute(genders.delete().where(genders.c.id == id))
    return ("deleted gender with id = " + id)

@gender.put("/genders/update/{id}", response_model= Gender, tags= ["Genders"], description="**Update** gender with Id.", response_description="Updated gender")
def update_gender(id: str, gender: Gender):
    result = conn.execute(genders.update().values(name= gender.name).where(genders.c.id == id))
    return conn.execute(genders.select().where(genders.c.id == id)).first()