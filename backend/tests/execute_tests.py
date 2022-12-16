from tests.dinosaur_test import get_all_dinosaurs_test, create_dinosaur_test, get_one_dinosaur_test, update_dinosaur_test, delete_dinosaur_test

from tests.gender_test import get_all_genders_test, create_gender_test, delete_gender_test, get_one_gender_test, update_gender_test

from tests.species_test import get_all_species_test, create_species_test, get_one_species_test, update_species_test, delete_species_test

from tests.enclosure_test import get_all_enclosures_test, create_enclosures_test, get_one_enclosure_test, update_enclosure_test, delete_enclosure_test

from tests.alarm_tests import get_all_alarms_test, create_alarm_test, get_one_alarm_test, update_alarm_test, delete_alarm_test


def execute_all_test():
    print("=========================================")
    print("STARTING WITH DINOSAURS TESTS...")
    print ("")
    get_all_dinosaurs_test()
    create_dinosaur_test()
    get_one_dinosaur_test()
    update_dinosaur_test()
    delete_dinosaur_test()
    print("=========================================")  

    print("STARTING WITH ALARMS TESTS...")
    print ("")
    get_all_alarms_test()
    create_alarm_test()   
    get_one_alarm_test()
    update_alarm_test()
    delete_alarm_test()
    print("=========================================")

    print("STARTING WITH ENCLOSURES TESTS...")
    print ("")
    get_all_enclosures_test() 
    create_enclosures_test() 
    get_one_enclosure_test()  
    update_enclosure_test()
    delete_enclosure_test()
    print("=========================================")   

    print("STARTING WITH GENDERS TESTS...")
    print ("")
    get_all_genders_test()
    create_gender_test()
    get_one_gender_test()
    update_gender_test()
    delete_gender_test() 
    print("=========================================")  

    print("STARTING WITH SPECIES TESTS...")
    print ("")
    get_all_species_test()
    create_species_test()   
    get_one_species_test()
    update_species_test()
    delete_species_test()
    print("=========================================")