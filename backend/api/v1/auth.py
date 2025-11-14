# backend/api/v1/auth.py
from fastapi import APIRouter, HTTPException, Depends
from jose import JWTError, ExpiredSignatureError
from backend.auth import (
    verify_password, create_access_token, create_refresh_token, decode_token
)
from backend.schemas.auth import Login, LoginResult, RefreshIn, TokenOut
from backend.api.dependencies import auth_dependency
from backend.db.user_repository import get_user

router = APIRouter()

@router.post("/login", response_model=LoginResult)
def login(data: Login):
    row = get_user(data.id)
    if not row:
        raise HTTPException(status_code=404, detail="없는 유져입니다.")
    user_id, user_pw = row[0], row[1]

    if not verify_password(data.pw, user_pw):
        raise HTTPException(status_code=401, detail="비밀번호가 틀렸습니다.")

    access = create_access_token(user_id)
    refresh = create_refresh_token(user_id)

    return {
        "message": f"Welcome {user_id}!",
        "access_token": access,
        "refresh_token": refresh,
        "token_type": "Bearer",
    }

@router.post("/refresh", response_model=TokenOut)
def refresh_token(body: RefreshIn):
    try:
        payload = decode_token(body.refresh_token)
        if payload.get("type") != "refresh":
            raise HTTPException(status_code=400, detail="리프레시 토큰 타입이 아닙니다.")
        user_id = payload["sub"]
        new_access = create_access_token(user_id)
        return {"access_token": new_access, "token_type": "Bearer"}
    except ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="리프레시 토큰 만료, 다시 로그인 필요")
    except JWTError:
        raise HTTPException(status_code=401, detail="리프레시 토큰이 유효하지 않습니다.")

@router.get("/me")
def me(current_user_id: str = Depends(auth_dependency)):
    return {"id": current_user_id, "roles": ["USER"]}
