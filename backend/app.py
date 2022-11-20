from fastapi import FastAPI
from routes.dinosaur import dinosaur
from routes.enclosure import enclosure
from routes.truck import truck
from routes.gender import gender
from routes.alarm import alarm
from routes.species import species

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
            "name" : "Speciess",
            "description": "These are the routes of the speciess"
        }
    ]
)

app.include_router(dinosaur)
app.include_router(enclosure)
app.include_router(truck)
app.include_router(gender)
app.include_router(alarm)
app.include_router(species)