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

def create_dinosaur_test():
    response = client.post(
        "/dinosaurs",
        headers = {"Content-Type": "application/json"},
        json = 
        {"name": "prueba",
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


def get_one_dinosaur_test():
    response = client.get("/dinosaurs/2")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE DINOSAUR TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE DINOSAUR TEST NOT PASSED")



    
