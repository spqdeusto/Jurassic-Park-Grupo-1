from fastapi import FastAPI
from routes.dinosaur import dinosaur
from routes.enclosure import enclosure
from routes.truck import truck

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
        }
    ]
)

app.include_router(dinosaur)
app.include_router(enclosure)
app.include_router(truck)