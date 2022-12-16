from fastapi.testclient import TestClient

from routes.dinosaur import dinosaur, get_dinosaurs

client = TestClient(dinosaur)


def get_all_dinosaurs_test():
    response = client.get("/dinosaurs")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ALL DINOSAURS TEST PASSED")

    if (response.status_code != 200):
        print ("GET ALL DINOSAURS TEST NOT PASSED")
        print (response.status_code)  

def create_dinosaur_test():
    response = client.post(
        "/dinosaurs",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "Test",
        "species": 1,
        "age": 11,
        "weight": 111,
        "gender": 1,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE DINOSAUR TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE DINOSAUR TEST NOT PASSED")
        print (response.status_code)  


def get_one_dinosaur_test():
    response = client.get("/dinosaurs/99")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE DINOSAUR TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE DINOSAUR TEST NOT PASSED")
        print (response.status_code)  

def update_dinosaur_test():
    response = client.put("/dinosaurs/update/99",
    headers = {"Content-Type": "application/json"},
        json = 
        {
        "id": 99,
        "name": "TestUpdate",
        "species": 1,
        "age": 11,
        "weight": 111,
        "gender": 1,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("UPDATE DINOSAUR TEST PASSED")

    if (response.status_code != 200):
        print ("UPDATE DINOSAUR TEST NOT PASSED") 
        print (response.status_code)

def delete_dinosaur_test():
    response = client.get("/dinosaurs/delete/99")  
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("DELETE DINOSAUR TEST PASSED")

    if (response.status_code != 200):
        print ("DELETE DINOSAUR TEST NOT PASSED") 
        print (response.status_code)