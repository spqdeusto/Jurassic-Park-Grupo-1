from typing import Optional
from pydantic import BaseModel

class Species(BaseModel):
    id : Optional[str]
    name : str
    dangerousness : bool