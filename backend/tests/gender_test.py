from fastapi.testclient import TestClient

from routes.gender import gender, get_genders

client = TestClient(gender)


def get_all_genders_test():
    response = client.get("/genders")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ALL GENDERS TEST PASSED")

    if (response.status_code != 200):
        print ("GET ALL GENDERS TEST NOT PASSED")

def create_gender_test():
    response = client.post(
        "/genders",
        headers = {"Content-Type": "application/json"},
        json = 
        {
            "name": "prueba"
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE GENDER TEST PASSED")

    if (response.status_code != 200):
        print ("CREATE GENDER TEST NOT PASSED")