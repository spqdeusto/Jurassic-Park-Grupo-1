from fastapi import APIRouter
from config.db import conn
from models.species import species
from schemas.species_schema import Species

species = APIRouter()

@species.get("/species", response_model= list[Species], tags= ["Species"], description= "Return all the species")
def get_species():
    return conn.execute(species.select()).fetchall()

@species.post("/species", response_model= Species, tags= ["Species"])
def create_species(species : Species):
    new_species = {"id": species.id, "name": species.name, "electricity": species.electricity}
    result = conn.execute(species.insert().values(new_species))
    return conn.execute(species.select().where(species.c.id == result.lastrowid)).first()

@species.get("/species/{id}", response_model= Species, tags= ["Species"])
def get_species(id: str):
    return conn.execute(species.select().where(species.c.id == id)).first()

@species.get("/species/delete/{id}", response_model= str, tags= ["Species"])
def delete_species(id: str):
    result = conn.execute(species.delete().where(species.c.id == id))
    return ("deleted species with id = " + id)

@species.put("/species/update/{id}", response_model= Species, tags= ["Species"])
def update_species(id: str, species : Species):
    result = conn.execute(species.update().values(name= species.name, 
    electricity= species.electricity).where(species.c.id == id))
    return conn.execute(species.select().where(species.c.id == id)).first()