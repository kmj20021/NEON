# backend/schemas/user.py
from pydantic import BaseModel, field_validator

class SignUpIn(BaseModel):
    id: str
    pw: str
    name: str
    email: str
    phone: str


    @field_validator('id', 'pw', 'name', 'email', 'phone')# 검사 대상 필드들
    # cls:클래스 자신, v:사용자 입력값, field:필드 정보
    def not_empty(cls, v, field):
        if not v or not str(v).strip():
            raise ValueError(f"{field.name}은/는 비어 있을 수 없습니다.")
        return v

class SignUpOut(BaseModel):
    message: str
