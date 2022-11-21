from typing import Optional
from pydantic import BaseModel

class Dinosaur(BaseModel):
    id : Optional[str]
    name : str
    species : int
    age : int
    weight : float
    gender : int