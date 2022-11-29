from fastapi import APIRouter
from sqlalchemy import and_
from config.db import conn
from models.enclosure import enclosures
from models.truck import trucks
from models.species import species
from models.alarm import alarms
from schemas.enclosure_schema import Enclosure

enclosure = APIRouter()

@enclosure.get("/enclosures", response_model= list[Enclosure], tags= ["Enclosures"], description= "Return all the enclosures")
def get_enclosures():
    return conn.execute(enclosures.select()).fetchall()

@enclosure.post("/enclosures", response_model= Enclosure, tags= ["Enclosures"])
def create_enclosure(enclosure : Enclosure):
    new_enclosure = {"id": enclosure.id, "name": enclosure.name, "species": enclosure.species, "electricity": enclosure.electricity}
    result = conn.execute(enclosures.insert().values(new_enclosure))
    return conn.execute(enclosures.select().where(enclosures.c.id == result.lastrowid)).first()

@enclosure.get("/enclosures/{id}", response_model= Enclosure, tags= ["Enclosures"])
def get_enclosure(id: str):
    return conn.execute(enclosures.select().where(enclosures.c.id == id)).first()

@enclosure.get("/enclosures/delete/{id}", response_model= str, tags= ["Enclosures"])
def delete_enclosure(id: str):
    result = conn.execute(enclosures.delete().where(enclosures.c.id == id))
    return ("deleted enclosure with id = " + id)

@enclosure.put("/enclosures/update/{id}", response_model= Enclosure, tags= ["Enclosures"])
def update_enclosure(id: str, enclosure : Enclosure):
    result = conn.execute(enclosures.update().values(name= enclosure.name, 
    species= enclosure.species,
    electricity= enclosure.electricity).where(enclosures.c.id == id))
    updateAlarm()
    return conn.execute(enclosures.select().where(enclosures.c.id == id)).first()

def updateAlarm():
    
    dangereous_species = conn.execute(species.select().filter(species.c.dangerousness == True)).all()
    not_dangereous_species = conn.execute(species.select().filter(species.c.dangerousness == False)).all()

    dangereous_species_ids = []
    not_dangereous_species_ids = []

    for item in dangereous_species:
        dangereous_species_ids.append(item.id)

    for item in not_dangereous_species:
        not_dangereous_species_ids.append(item.id)
  
    deactivate_and_dangereous = conn.execute(enclosures.select().where(and_(enclosures.c.electricity == False, 
    enclosures.c.species.in_(dangereous_species_ids)))).first()

    deactivate_but_not_dangereous = conn.execute(enclosures.select().where(and_(enclosures.c.electricity == False, enclosures.c.species.in_(not_dangereous_species_ids)))).first()

    trucks_on_route = conn.execute(trucks.select().where(trucks.c.onRute == True)).first()

    all_trucks = conn.execute(trucks.select()).fetchall()

    print(dangereous_species_ids)
    print(not_dangereous_species_ids)
    print(deactivate_and_dangereous)
    print(deactivate_but_not_dangereous)

    if (deactivate_and_dangereous and trucks_on_route):
        
        current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
        conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

        new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 1)).first()
        conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

        for truck in all_trucks:
            conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= True).where(and_(trucks.c.id == truck.id, trucks.c.onRute == True)))
        
    else:
        if (deactivate_and_dangereous):

            current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
            conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

            new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 2)).first()
            conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

            for truck in all_trucks:
                conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= True).where(and_(trucks.c.id == truck.id, trucks.c.onRute == True)))
              
        else:
            if (deactivate_but_not_dangereous):

                current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
                conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

                new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 3)).first()
                conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

                for truck in all_trucks:
                    conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= False).where(trucks.c.id == truck.id))
                
            else:
                current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
                conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

                new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 4)).first()
                conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

                for truck in all_trucks:
                    conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= False).where(trucks.c.id == truck.id))