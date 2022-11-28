from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes.truck import truck
from routes.gender import gender
from routes.alarm import alarm
from routes.species import speciesAPI
from routes.dinosaur import dinosaur
from routes.enclosure import enclosure

from config.db import conn

from models.gender import genders
from models.species import species
from models.truck import trucks
from models.alarm import alarms
from models.enclosure import enclosures
from models.dinosaur import dinosaurs

app = FastAPI(
    title= "Jurassic Park API",
    description= "This is the group 1 API",
    openapi_tags=[
        {
        "name": "Dinosaurs",
        "description": "These are the routes of the dinosaurs"
        },
        {
            "name" : "Enclosures",
            "description": "These are the routes of the enclosures"
        },
        {
            "name" : "Trucks",
            "description": "These are the routes of the trucks"
        },
        {
            "name" : "Genders",
            "description": "These are the routes of the genders"
        },
         {
            "name" : "Alarms",
            "description": "These are the routes of the alarms"
        },
         {
            "name" : "Species",
            "description": "These are the routes of the species"
        }
    ]
)

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    
)
app.include_router(speciesAPI)
app.include_router(gender)

app.include_router(truck)
app.include_router(alarm)

app.include_router(enclosure)
app.include_router(dinosaur)

@app.on_event("startup")
def startup_seedData_db():
    conn.execute(alarms.delete())
    conn.execute(enclosures.delete())
    conn.execute(dinosaurs.delete())
    conn.execute(trucks.delete())
    conn.execute(genders.delete())
    conn.execute(species.delete())
    
    
    gender_Init = [
        {"id": "1", "name": "Male"},
        {"id": "2", 'name': 'Female'},
    ]
    species_Init = [
        {"id": "1", "name": "Dilophosaurus", "dangerousness": True},
        {"id": "2", "name": "T-Rex", "dangerousness": True},
        {"id": "3", "name": "Velociraptor", "dangerousness": True},
        {"id": "4", "name": "Brachiosaurus", "dangerousness": False},
        {"id": "5", "name": "Parasaulophus", "dangerousness": False},
        {"id": "6", "name": "Galliminus", "dangerousness": False},
        {"id": "7", "name": "Triceratops", "dangerousness": False},
    ]
    
    truck_Init = [
        {"id": "1", "onRute": True, "passengers": 4, "securitySystem": True},
        {"id": "2", "onRute": False, "passengers": 0, "securitySystem": True},
        {"id": "3", "onRute": True, "passengers": 2, "securitySystem": True},
        {"id": "4", "onRute": True, "passengers": 3, "securitySystem": True},
    ]

    alarm_Init = [
        {"id": "1", "name": "Maximun Alert", "active": True},
        {"id": "2", "name": "Medium Alert", "active": False},
        {"id": "3", "name": "Low Alert", "active": False},
        {"id": "4", "name": "Normality", "active": False},
    ]
   
    enclosure_Init = [ 
        {"id": "1", "name": "Dilophosaurus Enclosure", "species": 1, "electricity": False},
        {"id": "2", "name": "T-Rex Enclosure", "species": 2, "electricity": True},
        {"id": "3", "name": "Velociraptor Enclosure", "species": 3, "electricity": True},
        {"id": "4", "name": "Brachiosaurus and Parasaulophus Enclosure", "species": 4, "electricity": True},
        {"id": "5", "name": "Galliminus Enclosure", "species": 6, "electricity": True},
        {"id": "6", "name": "Triceratops Enclosure", "species": 7, "electricity": False},
    ]

    dinosaur_Init = [
        {"id": "1", "name": "Zion", "species": 1, "age": 11, "weight": 120, "gender": 1},
        {"id": "2", "name": "Glenda", "species": 1, "age": 8, "weight": 140, "gender": 2},
        {"id": "3", "name": "Sven", "species": 1, "age": 9, "weight": 160, "gender": 1},
        {"id": "4", "name": "Clarice", "species": 2, "age": 19, "weight": 100, "gender": 2},
        {"id": "5", "name": "Randy", "species": 2, "age": 18, "weight": 120, "gender": 1},
        {"id": "6", "name": "Ryan", "species": 3, "age": 12, "weight": 130, "gender": 1},
        {"id": "7", "name": "Eva", "species": 3, "age": 10, "weight": 100, "gender": 2},
        {"id": "8", "name": "Sair", "species": 4, "age": 14, "weight": 230, "gender": 2},
        {"id": "9", "name": "Nebur", "species": 4, "age": 12, "weight": 280, "gender": 1},
        {"id": "10", "name": "Andra", "species": 5, "age": 16, "weight": 240, "gender": 2},
        {"id": "11", "name": "Mia", "species": 6, "age": 7, "weight": 100, "gender": 2},
        {"id": "12", "name": "Aerol", "species": 6, "age": 20, "weight": 60, "gender": 1},
        {"id": "13", "name": "Akrog", "species": 7, "age": 11, "weight": 170, "gender": 2},
        {"id": "14", "name": "Carmen", "species": 7, "age": 13, "weight": 120, "gender": 2},
    ]

    conn.execute(genders.insert().values(gender_Init))
    conn.execute(species.insert().values(species_Init))
    conn.execute(trucks.insert().values(truck_Init))
    conn.execute(alarms.insert().values(alarm_Init))
    conn.execute(enclosures.insert().values(enclosure_Init))
    conn.execute(dinosaurs.insert().values(dinosaur_Init))



