from fastapi.testclient import TestClient

from routes.enclosure import enclosure, get_enclosure

client = TestClient(enclosure)


def get_all_enclosures_test():
    response = client.get("/enclosures")

    objectsReturned = 0
    for item in response.text:
        # El caracter { indica que empieza un objeto. Se nos devolverán tantos objetos como { haya. En este caso, se debe devolver algún recinto, no pueden ser 0. De lo contrario el test no pasará
        if (item == "{"):
            objectsReturned += 1

    if (response.status_code == 200 and objectsReturned != 0):
        assert response.status_code == 200
        print ("GET ALL ENCLOSURES TEST PASSED")

    if (response.status_code != 200 or objectsReturned ==0):
        print ("GET ALL ENCLOSURES TEST NOT PASSED")
        print (response.status_code)  

def create_enclosures_test():
    response = client.post(
        "/enclosures",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "Test",
        "species": 1,
        "electricity": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE ENCLOSURE TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE ENCLOSURE TEST NOT PASSED")
        print (response.status_code)  


def get_one_enclosure_test():
    response = client.get("/enclosures/99")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE ENCLOSURE TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE ENCLOSURE TEST NOT PASSED")
        print (response.status_code)  

def update_enclosure_test():
    response = client.put("/enclosures/update/99",
    headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "TestUpdate",
        "species": 1,
        "electricity": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("UPDATE ENCLOSURE TEST PASSED")

    if (response.status_code != 200):
        print ("UPDATE ENCLOSURE TEST NOT PASSED") 
        print (response.status_code)

def delete_enclosure_test():
    response = client.get("/enclosures/delete/99")  
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("DELETE ENCLOSURE TEST PASSED")

    if (response.status_code != 200):
        print ("DELETE ENCLOSURE TEST NOT PASSED") 
        print (response.status_code)


    
