# from typing import Optional # 타입 힌트용
# from fastapi import FastAPI, HTTPException, Depends, Header
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel, field_validator
# from jose import JWTError, ExpiredSignatureError
# from db.config import get_conn # DB 연결 함수 가져오기
# from backend.auth import ( #내가 만든 함수들 가져오기
#     verify_password, hash_password,
#     create_access_token, create_refresh_token,
#     require_access, decode_token
# )

# app = FastAPI()

# # ★ CORS (웹에서 호출 가능하도록 열기)
# app.add_middleware(
#     CORSMiddleware,          # 라이브러리
#     allow_origins=["*"],     # 개발용: 모든 도메인 허용 (운영은 특정 도메인으로 제한)
#     allow_credentials=True,  # 쿠키(로그인 정보) 보낼 수 있게 허락
#     allow_methods=["*"],     # GET, POST, PUT, DELETE, OPTIONS 전부 가능
#     allow_headers=["*"],     #모든 종류의 헤더를 받을 수 있게 허용
# )

# '''
#     BaseModel은 Pydantic 라이브러리에서 제공하는 데이터 모델링 클래스이며
#     클라이언트가 보낸 데이터를 id가 str인지 pw가 str인지 검증하는 역할함. => 일치하지 않을 시 422 에러 발생
# '''

# #로그인 요청 데이터 검증용
# class Login(BaseModel):
#     id: str
#     pw: str 

# #로그인 출력용
# class LoginResult(BaseModel):
#     message: str
#     access_token: str #로그인을 했으니 토큰 발급
#     refresh_token: str
#     token_type: str = "Bearer" #토큰 기본 타입

# #토큰 재발급 요청용
# class RefreshIn(BaseModel):
#     refresh_token: str

# #토큰 출력용
# class TokenOut(BaseModel):
#     access_token: str   # 재발급 했으니 토큰 발급
#     token_type: str = "Bearer"

# #회원가입 요청용
# class SignUpIn(BaseModel):
#     id: str
#     pw: str
#     name: str
#     email: str
#     phone: str

#     @field_validator('id', 'pw', 'name', 'email', 'phone')
#     def not_empty(cls, v, field) :
#         if not v or not str(v).strip() :
#             raise ValueError(f"{field.name}은/는 비어 있을 수 없습니다.")
#         return v

# class SignUpOut(BaseModel):
#     message: str

# #유져 정보 조회 함수
# def get_user(id : str) -> Optional[tuple] : #return 타입이 tuple or None
#     conn = get_conn()   # DB 연결
#     cur = conn.cursor() # 커서 획득
#     cur.execute("SELECT id, hash_pw FROM user WHERE id = %s", (id,))  # 튜플로 전달
#     row = cur.fetchone() # 결과가 여러개 일 땐 fetchall()
#     conn.close()
#     return row


# #로그인 요청
# @app.post("/login", response_model=LoginResult)
# def login(data: Login):
#     row = get_user(data.id)
#     if not row:
#         raise HTTPException(status_code=404, detail="없는 유져입니다.")
#     user_id, user_pw = row[0], row[1]
#     if not verify_password(data.pw, user_pw):
#         raise HTTPException(status_code=401, detail="비밀번호가 틀렸습니다.")
    
#     access = create_access_token(user_id)
#     refresh = create_refresh_token(user_id)
#     return {
#         "message": f"Welcome {user_id}!",
#         "access_token": access,
#         "refresh_token": refresh,
#         "token_type": "Bearer",
#     }

# #토큰 재발급 요청
# # 토큰 형식 : header . payload . (verify) signature
# @app.post("/refresh", response_model=TokenOut)
# def refresh_token(body: RefreshIn) :
#     try:
#         payload = decode_token(body.refresh_token)
#         if payload.get("type") != "refresh":
#             raise HTTPException(status_code=400, detail="리프레시 토큰 타입이 아닙니다.")
#         user_id = payload["sub"] # 토큰의 주인 ID
#         new_access = create_access_token(user_id) # 토큰 주인 id로 새로운 토큰 생성
#         return {"access_token": new_access, "token_type": "Bearer"}
#     except ExpiredSignatureError:
#         raise HTTPException(status_code=401, detail="리프레시 토큰 만료, 다시 로그인 필요")
#     except JWTError:
#         raise HTTPException(status_code=401, detail="리프레시 토큰이 유효하지 않습니다.")
    
# # Access Token 인증 검사기
# def auth_dependency(authorization: Optional[str] = Header(None)) -> str : #헤더에서 Authrization 찾아. 없으면 None 주기
#     if not authorization or not authorization.startswith("Bearer ") : # 요청 헤더에 Beare로 시작하나? Authorization이 있나?
#         raise HTTPException(status_code=401, detail="인증 토큰이 필요합니다.")
#     token = authorization.split(" ",1)[1] #인증요청에서 토큰 떼내기
#     try :
#         user_id = require_access(token)
#         return user_id
#     except ExpiredSignatureError:
#         raise HTTPException(status_code=401, detail="Access 만료")
#     except JWTError :
#         raise HTTPException(status_code=401, detail="Access 토큰이 유효하지 않습니다.")

# # 사용자의 정보를 보여주는 API
# @app.get("/me")
# def me(current_user_id :str = Depends(auth_dependency)): #의존성 주입
#     return { "id":current_user_id, "roles":["USER"] }

# # 개발용: 비밀번호를 해시화하여 DB에 저장하는 API
# @app.post("/_dev/hash-once")
# def dev_hash_once(id: str, plain_pw:str):
#     hashed = hash_password(plain_pw)
#     conn = get_conn()
#     cur = conn.cursor()
#     cur.execute("UPDATE \"user\" SET pw = %s WHERE id = %s", (hashed, id))
#     conn.commit()
#     conn.close()
#     return{"id":id, "pw":hashed}

# #회원가입 요청 API
# @app.post("/signup", response_model=SignUpOut)
# def signup(body: SignUpIn) :  

#     #입력값 검증    
#     if len(body.id)>100 :
#         raise HTTPException(status_code=400, detail="ID의 길이가 너무 깁니다.")
#     if len(body.pw)<4 :
#         raise HTTPException(status_code=400, detail="비밀번호는 4자리 이상이어야 합니다.")
   
    
#     # 아이디 중복 확인
#     if get_user(body.id) :
#         raise HTTPException(status_code=409, detail="이미 존재하는 아이디 입니다.")
    
#     # 비밀번호 해시 후 저장
#     hashed = hash_password(body.pw)

#     conn = get_conn()
#     cur = conn.cursor()

#     try :
#         cur.execute(
#             "INSERT INTO user (id, hash_pw, name, email, phone, address) VALUES (%s, %s, %s, %s, %s, %s)", (body.id, hashed, body.name, body.email, body.phone, "need address")
#         )
#         conn.commit()
#     finally :
#         conn.close()

#     return {"message" : f"{body.id}님, 회원가입이 완료되었습니다."}
    
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.api.v1 import auth, users

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(users.router, prefix="/users", tags=["users"])