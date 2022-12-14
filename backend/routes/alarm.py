from fastapi import APIRouter

from sqlalchemy import and_

from config.db import conn

from models.alarm import alarms
from models.truck import trucks
from models.species import species
from models.enclosure import enclosures

from schemas.alarm_schema import Alarm

alarm = APIRouter()

@alarm.get("/alarms", response_model= list[Alarm], tags= ["Alarms"], description= "**Return all** the alarms.", response_description="All the alarms")
def get_alarms():
    return conn.execute(alarms.select()).fetchall()

@alarm.post("/alarms", response_model= Alarm, tags= ["Alarms"], description="**Create** an alarm.", response_description="Created alarm")
def create_alarm(alarm: Alarm):
    new_alarm = {"id": alarm.id, "name": alarm.name, "active": alarm.active}
    result = conn.execute(alarms.insert().values(new_alarm))
    return conn.execute(alarms.select().where(alarms.c.id == result.lastrowid)).first()

@alarm.get("/alarms/{id}", response_model= Alarm, tags= ["Alarms"], description="**Return one** alarm with Id.", response_description="Alarm with given Id")
def get_alarm(id: str):
    return conn.execute(alarms.select().where(alarms.c.id == id)).first()

@alarm.get("/alarms/delete/{id}", response_model= str, tags= ["Alarms"], description="**Delete one** alarm with Id.", response_description="String with message: delated alarm and Id")
def delete_alarm(id: str):
    result = conn.execute(alarms.delete().where(alarms.c.id == id))
    return ("deleted alarm with id = " + id)

@alarm.put("/alarms/update/{id}", response_model= Alarm, tags= ["Alarms"], description="**Update** alarm with Id", response_description="Updated alarm")
def update_alarm(id: str, alarm: Alarm):
    result = conn.execute(alarms.update().values(name= alarm.name,
    active= alarm.active).where(alarms.c.id == id))
    return conn.execute(alarms.select().where(alarms.c.id == id)).first()

"""
    Actualiza el sistema de seguridad

    Primero se hacen dos listas, una con los ids de las especies piligrosas y otra con la de las especies no peligrosas. Después, se comprueban 3 estados:

        deactivate_and_dangereous: Existen zonas con la seguridad desactivada de especies peligrosas
        deactivate_but_not_dangereous: Existen zonas con la seguridad desactivada, pero de especies no peligrosas
        trucks_on_route: Hay trucks en ruta actualmente
    
    Por último se hace lo siguiente:
        
        Si esta desactivada una zona peligrosa y hay trucks en ruta, se pone como false la alarma activa actualmente, se activa la alerta máxima. Se activa el piloto automático de los trukcs en ruta y se desactiva en los que no estén en ruta.

        Si esta desactivada una zona peligrosa y no hay trucks en ruta, se pone como false la alarma activa actualmente, se activa la alerta media. Se activa el piloto automático de los trukcs en ruta y se desactiva en los que no estén en ruta.

        Si esta desactivada una zona no peligrosa se pone como false la alarma activa actualmente, se activa la alerta baja. Se desactiva el piloto automático de todos los trucks.

        Si no hay ninguna zona desactivada se pone como false la alarma activa actualmente, se activa la alerta de normalidad. Se desactiva el piloto automático de todos los trucks.
    
    Este método se ejecutará en dos situaciones, cuando se haga un update de un enclosure (ya que podría significar desactivar el sistema de seguridad de una zona) o cuando se hace un update de un truck (ya que podría significar cambiar el onRute de un truck). Estas situaciones son las únicas que implicarán un cambio en la alarma.
"""
def updateAlarmState():
    
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

    if (deactivate_and_dangereous and trucks_on_route):
        
        current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
        conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

        new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 1)).first()
        conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

        for truck in all_trucks:
            conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= True).where(and_(trucks.c.id == truck.id, trucks.c.onRute == True)))

            conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= False).where(and_(trucks.c.id == truck.id, trucks.c.onRute == False)))
        
    else:
        if (deactivate_and_dangereous):

            current_active_alarm = conn.execute(alarms.select().where(alarms.c.active == True)).first()
            conn.execute(alarms.update().values(name= current_active_alarm.name, active= False).where(alarms.c.id == current_active_alarm.id))

            new_active_alarm = conn.execute(alarms.select().where(alarms.c.id == 2)).first()
            conn.execute((alarms.update().values(name= new_active_alarm.name, active= True).where(alarms.c.id == new_active_alarm.id)))

            for truck in all_trucks:
                conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= True).where(and_(trucks.c.id == truck.id, trucks.c.onRute == True)))

                conn.execute(trucks.update().values(onRute= truck.onRute, passengers= truck.passengers, securitySystem= False).where(and_(trucks.c.id == truck.id, trucks.c.onRute == False)))
              
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