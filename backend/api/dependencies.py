# backend/api/dependencies.py
from typing import Optional
from fastapi import Header, HTTPException, Depends
from jose import JWTError, ExpiredSignatureError
from backend.auth import require_access  # 기존 코드 재사용

'''
    의존성이란?
    어떠한 기능이 실행되기 전에 반드시 선행되어야 하는 기능이나 처리를 의미.
'''
# 인증 의존성 함수
def auth_dependency(
    authorization: Optional[str] = Header(None),
) -> str:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="인증 토큰이 필요합니다.")
    token = authorization.split(" ", 1)[1]
    try:
        user_id = require_access(token)
        return user_id
    except ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Access 만료")
    except JWTError:
        raise HTTPException(status_code=401, detail="Access 토큰이 유효하지 않습니다.")
