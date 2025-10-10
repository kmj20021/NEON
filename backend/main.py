from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from db.config import get_conn

app = FastAPI()

# ★ CORS (웹에서 호출 가능하도록 열기)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 개발용: 모든 도메인 허용 (운영은 특정 도메인으로 제한)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Login(BaseModel):
    id: str
    pw: str 

@app.post("/login")
def login(data: Login):
    conn = get_conn()   # 함수 호출
    cur = conn.cursor()
    cur.execute("SELECT pw FROM user WHERE id = ?", (data.id,))  # 튜플로 전달
    row = cur.fetchone()
    conn.close()

    if not row:
        raise HTTPException(status_code=404, detail="User not found")

    if row[0] != data.pw:
        raise HTTPException(status_code=401, detail="Wrong password")

    return {"message": f"Welcome {data.id}!"}
