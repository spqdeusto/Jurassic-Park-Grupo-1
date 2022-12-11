from fastapi import APIRouter
from config.db import conn
from models.truck import trucks
from schemas.truck_schema import Truck

truck = APIRouter()

@truck.get("/trucks", response_model= list[Truck], tags= ["Trucks"], description= "Return all the trucks")
def get_trucks():
    return conn.execute(trucks.select()).fetchall()

@truck.post("/trucks", response_model= Truck, tags= ["Trucks"], description="**Create** a truck.")
def create_truck(truck: Truck):
    new_truck = {"id": truck.id, "onRute": truck.onRute, "passengers": truck.passengers, "securitySystem": truck.securitySystem}
    result = conn.execute(trucks.insert().values(new_truck))
    return conn.execute(trucks.select().where(trucks.c.id == result.lastrowid)).first()

@truck.get("/trucks/{id}", response_model= Truck, tags= ["Trucks"], description="**Return one** truck with Id.")
def get_truck(id: str):
    return conn.execute(trucks.select().where(trucks.c.id == id)).first()

@truck.get("/trucks/delete/{id}", response_model= str, tags= ["Trucks"], description="**Delete one** truck with Id.")
def delete_truck(id: str):
    result = conn.execute(trucks.delete().where(trucks.c.id == id))
    return ("deleted truck with id = " + id)

@truck.put("/trucks/update/{id}", response_model= Truck, tags= ["Trucks"], description="**Update** truck with Id.")
def update_truck(id: str, truck: Truck):
    result = conn.execute(trucks.update().values(
    onRute= truck.onRute, 
    passengers= truck.passengers, 
    securitySystem= truck.securitySystem).where(trucks.c.id == id))
    return conn.execute(trucks.select().where(trucks.c.id == id)).first()