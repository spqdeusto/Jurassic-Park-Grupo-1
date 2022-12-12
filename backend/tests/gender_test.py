from fastapi.testclient import TestClient

from routes.gender import gender, get_genders, delete_gender

client = TestClient(gender)



def get_all_genders_test():
    response = client.get("/genders")
    
    objectsReturned = 0
    for item in response.text:
        #El caracter { indica que empieza un objeto. Se nos devolverán tantos objetos como { haya. En este caso, se deben devolver 2 objetos, uno para Male y otro para Female, de lo contrario el test no pasará
        if (item == "{"):
            objectsReturned += 1
            
    if (response.status_code == 200 and objectsReturned == 2):
        assert response.status_code == 200
        print ("GET ALL GENDERS TEST PASSED")

    if (response.status_code != 200 or objectsReturned != 2):
        print ("GET ALL GENDERS TEST NOT PASSED")
        print (response.status_code)  

def create_gender_test():
    response = client.post(
        "/genders",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "Test",
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE GENDER TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE GENDER TEST NOT PASSED")
        print (response.status_code)  


def get_one_gender_test():
    response = client.get("/genders/99")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE GENDER TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE GENDER TEST NOT PASSED")
        print (response.status_code)  

def update_gender_test():
    response = client.put("/genders/update/99",
    headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "TestUpdate",
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("UPDATE GENDER TEST PASSED")

    if (response.status_code != 200):
        print ("UPDATE GENDER TEST NOT PASSED") 
        print (response.status_code)

def delete_gender_test():
    response = client.get("/genders/delete/99")  
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("DELETE GENDER TEST PASSED")

    if (response.status_code != 200):
        print ("DELETE GENDER TEST NOT PASSED") 
        print (response.status_code)