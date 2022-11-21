from typing import Optional
from pydantic import BaseModel
from schemas.gender_schema import Gender
from schemas.species_schema import Species

class Dinosaur(BaseModel):
    id : Optional[str]
    name : str
    species : Species
    age : int
    weight : float
    gender : Gender