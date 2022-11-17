from typing import Optional
from pydantic import BaseModel

class Enclosure(BaseModel):
    id : Optional[str]
    name : str
    electricity : bool