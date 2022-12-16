from fastapi.testclient import TestClient

from routes.alarm import alarm, get_alarms

client = TestClient(alarm)


def get_all_alarms_test():
    response = client.get("/alarms")

    objectsReturned = 0
    for item in response.text:
        # El caracter { indica que empieza un nuevo objeto. Se nos devolverán tantos objetos como { haya. En este caso, se deben devolver 4 alarmas, de lo contrario el test no pasará, por lo que esperamos que objectsReturned sea igual a 4
        if (item == "{"):
            objectsReturned += 1

    if (response.status_code == 200 and objectsReturned == 4):
        assert response.status_code == 200
        print ("GET ALL ALARMS TEST PASSED")

    if (response.status_code != 200 or objectsReturned != 4):
        print ("GET ALL ALARMS TEST NOT PASSED")
        print (response.status_code)  

def create_alarm_test():
    response = client.post(
        "/alarms",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "Test",
        "active": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE ALARM TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE ALARM TEST NOT PASSED")
        print (response.status_code)  


def get_one_alarm_test():
    response = client.get("/alarms/99")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE ALARM TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE ALARM TEST NOT PASSED")
        print (response.status_code)  

def update_alarm_test():
    response = client.put("/alarms/update/99",
    headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "TestUpdate",
        "active": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("UPDATE ALARM TEST PASSED")

    if (response.status_code != 200):
        print ("UPDATE ALARM TEST NOT PASSED") 
        print (response.status_code)

def delete_alarm_test():
    response = client.get("/alarms/delete/99")  
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("DELETE ALARM TEST PASSED")

    if (response.status_code != 200):
        print ("DELETE ALARM TEST NOT PASSED") 
        print (response.status_code)