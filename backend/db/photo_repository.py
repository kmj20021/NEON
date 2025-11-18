from typing import List, Dict
from DB.config import get_conn  # 네가 쓰는 config 위치에 맞춰서 import

# 사진 저장 DAO 함수
def save_photo(user_id: str, drive_file_id: str, image_url: str) -> Dict:
    conn = get_conn()
    cur = conn.cursor()
    try:
        # id 는 AUTO_INCREMENT 이므로 INSERT 에서 넣지 않음
        cur.execute(
            """
            INSERT INTO photo (user_id, drive_file_id, image_url)
            VALUES (%s, %s, %s)
            """,
            (user_id, drive_file_id, image_url),
        )
        conn.commit()

        photo_id = cur.lastrowid  # 방금 INSERT 된 행의 PK 값 가져오기

        return {
            "id": photo_id,
            "user_id": user_id,
            "drive_file_id": drive_file_id,
            "image_url": image_url,
        }
    except Exception as e:
        print(f"사진 저장 실패: {e}")
        return {"error": str(e)}
    finally:
        conn.close()


# 사용자별 사진 목록 조회 DAO 함수
def get_photos_by_user(user_id: str) -> List[Dict]:
    conn = get_conn()
    # dictionary=True 옵션이 없다면, 튜플로 받아서 dict 로 바꿔야 함
    cur = conn.cursor()
    try:
        cur.execute(
            """
            SELECT id, user_id, drive_file_id, image_url
            FROM photo
            WHERE user_id = %s
            ORDER BY id DESC
            """,
            (user_id,),
        )
        rows = cur.fetchall()

        # rows 가 (id, user_id, drive_file_id, image_url) 튜플 리스트라고 가정
        result: List[Dict] = []
        for row in rows:
            result.append(
                {
                    "id": row[0],
                    "user_id": row[1],
                    "drive_file_id": row[2],
                    "image_url": row[3],
                }
            )

        return result
    except Exception as e:
        print(f"사용자별 사진 조회 실패: {e}")
        return []
    finally:
        conn.close()
