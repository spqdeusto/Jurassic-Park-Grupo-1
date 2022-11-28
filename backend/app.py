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
    
    conn.execute(genders.insert().values(gender_Init))

    species_Init = [
        {"id": "1", "name": "Dilophosaurus", "dangerousness": False},
        {"id": "2", "name": "T-Rex", "dangerousness": False},
        {"id": "3", "name": "Velociraptores", "dangerousness": False},
        {"id": "4", "name": "Brachiosaurus", "dangerousness": False},
        {"id": "5", "name": "Parasaulophus", "dangerousness": False},
        {"id": "6", "name": "Galliminus", "dangerousness": False},
        {"id": "7", "name": "Triceraptops", "dangerousness": False},
    ]

 
    conn.execute(species.insert().values(species_Init))

    
    truck_Init = [
        {"id": "1", "onRute": False, "passengers": "4", "securitySystem": False},
        {"id": "2", "onRute": False, "passengers": "4", "securitySystem": False},
    ]
 
    conn.execute(trucks.insert().values(truck_Init))

    alarm_Init = [
        {"id": "1", "name": "alerta maxima", "active": False},
        {"id": "2", "name": "alerta media", "active": False},
        {"id": "3", "name": "alerta baja", "active": False},
        {"id": "4", "name": "normalidad", "active": False},
    ]

    conn.execute(alarms.insert().values(alarm_Init))

    
    enclosure_Init = [ 
        {"id": "1", "name": "Recinto del Dilophosaurus", "species": "1", "electricity": False},
    ]


    conn.execute(enclosures.insert().values(enclosure_Init))

    dinosaur_Init = [
        {"id": "1", "name": "Jose", "species": "1", "age": "20", "weight": "1000", "gender": "1"},
        {"id": "2", "name": "Jose", "species": "2", "age": "20", "weight": "1000", "gender": "2"},
        {"id": "3", "name": "Jose", "species": "3", "age": "20", "weight": "1000", "gender": "1"},
        {"id": "4", "name": "Jose", "species": "4", "age": "20", "weight": "1000", "gender": "2"},
        {"id": "5", "name": "AAAAAA", "species": "5", "age": "20", "weight": "1000", "gender": "1"},
    ]
    
    conn.execute(dinosaurs.insert().values(dinosaur_Init))



