# backend/db/user_repository.py
from typing import Optional, Tuple
from DB.config import get_conn

'''
    데이터를 가져올 땐 fetchone, fetchall을 사용
    데이터를 삽입, 수정, 삭제할 땐 execute 후 commit을 사용
'''

# 사용자 정보 조회 DAO 함수
def get_user(id: str) -> Optional[tuple]:
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id, hash_pw FROM user WHERE id = %s", (id,))
    row = cur.fetchone()
    conn.close()
    return row

# 사용자 생성 DAO 함수
def create_user(id: str, hashed_pw: str, name: str, email: str, phone: str, address: str = "need address"):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO user (id, hash_pw, name, email, phone, address) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (id, hashed_pw, name, email, phone, address)
        )
        conn.commit()
    finally:
        conn.close()
