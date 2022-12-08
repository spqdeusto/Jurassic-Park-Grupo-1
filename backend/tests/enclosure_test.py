from fastapi.testclient import TestClient

from routes.enclosure import enclosure, get_enclosure

client = TestClient(enclosure)


def get_all_enclosures_test():
    response = client.get("/enclosures")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ALL ENCLOSURES TEST PASSED")

    if (response.status_code != 200):
        print ("GET ALL ENCLOSURES TEST NOT PASSED")

def create_enclosures_test():
    response = client.post(
        "/enclosures",
        headers = {"Content-Type": "application/json"},
        json = 
        {"name": "prueba", 
        "species": 1, 
        "electricity": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE ENCLOSURES TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE ENCLOSURES TEST NOT PASSED")






    
