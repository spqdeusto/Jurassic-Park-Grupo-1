from fastapi import APIRouter
from config.db import conn
from models.species import speciess
from schemas.species_schema import Species

species = APIRouter()

@species.get("/speciess", response_model= list[Species], tags= ["Speciess"], description= "Return all the speciess")
def get_speciess():
    return conn.execute(speciess.select()).fetchall()

@species.post("/speciess", response_model= Species, tags= ["Speciess"])
def create_species(species : Species):
    new_species = {"id": species.id, "name": species.name, "electricity": species.electricity}
    result = conn.execute(speciess.insert().values(new_species))
    return conn.execute(speciess.select().where(speciess.c.id == result.lastrowid)).first()

@species.get("/speciess/{id}", response_model= Species, tags= ["Speciess"])
def get_species(id: str):
    return conn.execute(speciess.select().where(speciess.c.id == id)).first()

@species.get("/speciess/delete/{id}", response_model= str, tags= ["Speciess"])
def delete_species(id: str):
    result = conn.execute(speciess.delete().where(speciess.c.id == id))
    return ("deleted species with id = " + id)

@species.put("/speciess/update/{id}", response_model= Species, tags= ["Speciess"])
def update_species(id: str, species : Species):
    result = conn.execute(speciess.update().values(name= species.name, 
    electricity= species.electricity).where(speciess.c.id == id))
    return conn.execute(speciess.select().where(speciess.c.id == id)).first()