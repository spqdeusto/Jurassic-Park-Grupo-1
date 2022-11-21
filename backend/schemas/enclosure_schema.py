from typing import Optional
from pydantic import BaseModel
from schemas.species_schema import Species

class Enclosure(BaseModel):
    id : Optional[str]
    name : str
    species: Species
    electricity : bool