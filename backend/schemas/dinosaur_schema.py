from typing import Optional
from pydantic import BaseModel

class Dinosaur(BaseModel):
    id : Optional[str]
    name : str
    species : str
    age : int
    weight : float
    gender : str
    dangerousness : bool