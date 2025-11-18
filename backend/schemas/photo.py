from pydantic import BaseModel
from typing import List

class PhotoBase(BaseModel):
    id : int
    image_url : str

    # ORM 모드 활성화 ORM(Object Relational Mapping) : 데이터베이스 모델을 Pydantic 모델로 변환할 수 있게 해줌
    class Config:
        orm_mode = True

class PhotoListResponse(BaseModel):
    photos : List[PhotoBase]