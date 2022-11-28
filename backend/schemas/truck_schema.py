from typing import Optional
from pydantic import BaseModel

class Truck(BaseModel):
    id : Optional[str]
    onRute : bool
    passengers : int
    securitySystem : bool