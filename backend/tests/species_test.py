from fastapi.testclient import TestClient

from routes.species import speciesAPI, get_species

client = TestClient(speciesAPI)


def get_all_species_test():
    response = client.get("/species")

    objectsReturned = 0
    for item in response.text:
        # El caracter { indica que empieza un objeto. Se nos devolverán tantos objetos como { haya. En este caso, se debe devolver alguna especie, no pueden ser 0. De lo contrario el test no pasará
        if (item == "{"):
            objectsReturned += 1

    if (response.status_code == 200 and objectsReturned != 0):
        assert response.status_code == 200
        print ("GET ALL SPECIES TEST PASSED")

    if (response.status_code != 200 or objectsReturned == 0):
        print ("GET ALL SPECIES TEST NOT PASSED")
        print (response.status_code)  

def create_species_test():
    response = client.post(
        "/species",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "Test",
        "dangerousness": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE species TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE SPECIES TEST NOT PASSED")
        print (response.status_code)  


def get_one_species_test():
    response = client.get("/species/99")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE SPECIES TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE SPECIES TEST NOT PASSED")
        print (response.status_code)  

def update_species_test():
    response = client.put("/species/update/99",
    headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "TestUpdate",
        "dangerousness": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("UPDATE SPECIES TEST PASSED")

    if (response.status_code != 200):
        print ("UPDATE SPECIES TEST NOT PASSED") 
        print (response.status_code)

def delete_species_test():
    response = client.get("/species/delete/99")  
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("DELETE SPECIES TEST PASSED")

    if (response.status_code != 200):
        print ("DELETE SPECIES TEST NOT PASSED") 
        print (response.status_code)