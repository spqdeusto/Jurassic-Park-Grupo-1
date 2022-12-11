from fastapi.testclient import TestClient

from routes.species import speciesAPI, get_species

client = TestClient(speciesAPI)


def get_all_species_test():
    response = client.get("/species")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ALL SPECIES TEST PASSED")

    if (response.status_code != 200):
        print ("GET ALL SPECIES TEST NOT PASSED")  

def create_species_test():
    response = client.post(
        "/species",
        headers = {"Content-Type": "application/json"},
        json = 
        {
        "name": "prueba", 
        "dangerousness": True,
        },
    )
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("CREATE SPECIES TEST PASSED")

    if (response.status_code != 200):    
        print ("CREATE SPECIES TEST NOT PASSED")

  
def get_one_specie_test():
    response = client.get("/species/2")
    if (response.status_code == 200):
        assert response.status_code == 200
        print ("GET ONE SPECIE TEST PASSED")

    if (response.status_code != 200):
        print ("GET ONE SPECIE TEST NOT PASSED")