from typing import Optional
from pydantic import BaseModel

class Gender(BaseModel):
    id : Optional[str]
    name : str