from fastapi import APIRouter
from config.db import conn
from models.dinosaur import dinosaurs
from schemas.dinosaur_schema import Dinosaur

dinosaur = APIRouter()

@dinosaur.get("/dinosaurs", response_model= list[Dinosaur], tags= ["Dinosaurs"], description= "**Return all** the dinosaurs", response_description="All the dinosaurs")
def get_dinosaurs():
    return conn.execute(dinosaurs.select()).fetchall()

@dinosaur.post("/dinosaurs", response_model= Dinosaur, tags= ["Dinosaurs"], description="**Create** a dinosaur.", response_description="Created dinosaur")
def create_dinosaur(dinosaur: Dinosaur):
    new_dinosaur = {"id": dinosaur.id, "name": dinosaur.name, "species": dinosaur.species, "age": dinosaur.age, "weight": dinosaur.weight, "gender": dinosaur.gender}
    result = conn.execute(dinosaurs.insert().values(new_dinosaur))
    return conn.execute(dinosaurs.select().where(dinosaurs.c.id == result.lastrowid)).first()

@dinosaur.get("/dinosaurs/{id}", response_model= Dinosaur, tags= ["Dinosaurs"], description="**Return one** dinosaur with Id.", response_description="Dinosaur with give Id")
def get_dinosaur(id: str):
    return conn.execute(dinosaurs.select().where(dinosaurs.c.id == id)).first()

@dinosaur.get("/dinosaurs/delete/{id}", response_model= str, tags= ["Dinosaurs"], description="**Delete one** dinosaur with Id.", response_description="String with message: delated dinosaur and Id")
def delete_dinosaur(id: str):
    result = conn.execute(dinosaurs.delete().where(dinosaurs.c.id == id))
    return ("deleted dinosaur with id = " + id)

@dinosaur.put("/dinosaurs/update/{id}", response_model= Dinosaur, tags= ["Dinosaurs"], description="**Update** dinosaur with Id.", response_description="Updated dinosaur")
def update_dinosaur(id: str, dinosaur: Dinosaur):
    result = conn.execute(dinosaurs.update().values(name= dinosaur.name, 
    species= dinosaur.species, 
    age= dinosaur.age, 
    weight= dinosaur.weight, 
    gender= dinosaur.gender).where(dinosaurs.c.id == id))
    return conn.execute(dinosaurs.select().where(dinosaurs.c.id == id)).first()