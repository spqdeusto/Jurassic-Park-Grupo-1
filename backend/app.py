from fastapi import FastAPI
from routes.dinosaur import dinosaur

app = FastAPI(
    title= "Jurassic Park API",
    description= "This is the group 1 API",
    openapi_tags=[{
        "name": "Dinosaurs",
        "description": "These are the routes of the dinosaurs"
    }
    ]
)

app.include_router(dinosaur)