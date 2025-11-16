from typing import List, Dict
from DB.config import get_conn

_FAKE_DB: List[Dict] = []
_AUTO_ID = 1


def save_photo1(user_id: str, drive_file_id: str, image_url: str)-> Dict:
    global _AUTO_ID
    record = {
        "id": _AUTO_ID,
        "user_id": user_id,
        "drive_file_id": drive_file_id,
        "image_url": image_url,
    }
    _FAKE_DB.append(record)
    _AUTO_ID += 1
    return record

# 사진 저장 DAO 함수
def save_photo(user_id: str, drive_file_id: str, image_url: str)-> Dict:
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO photo (id, user_id, drive_file_id, image_url) "
            "VALUES (%s, %s, %s, %s)",
            (_AUTO_ID, user_id, drive_file_id, image_url)
        )
        conn.commit()
        _AUTO_ID += 1
        return {
            "id": _AUTO_ID - 1,
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
    return[p for p in _FAKE_DB if p["user_id"] == user_id]