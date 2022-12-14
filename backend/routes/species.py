from fastapi import APIRouter
from config.db import conn
from models.species import species 
from schemas.species_schema import Species

speciesAPI = APIRouter()

@speciesAPI.get("/species", response_model= list[Species], tags= ["Species"], description= "**Return all** the species", response_description="All the species")
def get_species():
    return conn.execute(species.select()).fetchall()

@speciesAPI.post("/species", response_model= Species, tags= ["Species"], description="**Create** an species.", response_description="Created species")
def create_species(currentSpecies : Species):
    new_species = {"id": currentSpecies.id, "name": currentSpecies.name, "dangerousness": currentSpecies.dangerousness}
    result = conn.execute(species.insert().values(new_species))
    return conn.execute(species.select().where(species.c.id == result.lastrowid)).first()

@speciesAPI.get("/species/{id}", response_model= Species, tags= ["Species"], description="**Return one** species with Id.", response_description="Species with given Id")
def get_species(id: str):
    return conn.execute(species.select().where(species.c.id == id)).first()

@speciesAPI.get("/species/delete/{id}", response_model= str, tags= ["Species"], description="**Delete one** species with Id.", response_description="String with message: delated species and Id")
def delete_species(id: str):
    result = conn.execute(species.delete().where(species.c.id == id))
    return ("deleted species with id = " + id)

@speciesAPI.put("/species/update/{id}", response_model= Species, tags= ["Species"], description="**Update** species with Id.", response_description="Updated species")
def update_species(id: str, currentSpecies : Species):
    result = conn.execute(species.update().values(name= currentSpecies.name, 
    dangerousness= currentSpecies.dangerousness).where(species.c.id == id))
    
    return conn.execute(species.select().where(species.c.id == id)).first()