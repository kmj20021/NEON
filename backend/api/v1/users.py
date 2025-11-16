# backend/api/v1/users.py
from fastapi import APIRouter, HTTPException
from backend.auth import hash_password
from backend.schemas.user import SignUpIn, SignUpOut
from backend.db.user_repository import get_user, create_user

router = APIRouter()

@router.post("/signup", response_model=SignUpOut)
def signup(body: SignUpIn):

    if len(body.id) > 100:
        raise HTTPException(status_code=400, detail="ID의 길이가 너무 깁니다.")
    if len(body.pw) < 4:
        raise HTTPException(status_code=400, detail="비밀번호는 4자리 이상이어야 합니다.")

    if get_user(body.id):
        raise HTTPException(status_code=409, detail="이미 존재하는 아이디 입니다.")

    hashed = hash_password(body.pw)

    create_user(body.id, hashed, body.name, body.email, body.phone)

    return {"message": f"{body.name}님, 회원가입이 완료되었습니다."}
