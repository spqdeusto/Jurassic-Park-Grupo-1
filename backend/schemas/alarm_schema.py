from typing import Optional
from pydantic import BaseModel

class Alarm(BaseModel):
    id : Optional[str]
    name : str
    active : bool