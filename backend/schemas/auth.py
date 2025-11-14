# backend/schemas/auth.py
from pydantic import BaseModel

# 로그인 요청 DTO
class Login(BaseModel):
    id: str
    pw: str 

# 로그인 결과 DTO
class LoginResult(BaseModel):
    message: str
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"

# 리프레시 토큰 입력 DTO
class RefreshIn(BaseModel):
    refresh_token: str

# 토큰 출력 DTO
class TokenOut(BaseModel):
    access_token: str
    token_type: str = "Bearer"
