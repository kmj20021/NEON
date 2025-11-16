from datetime import datetime, timedelta, timezone # 순서대로 시간 가져오기, 시간 차이 계산, 지역 시간대 처리
from jose import jwt, JWTError
from passlib.context import CryptContext #암호화 관리 라이브러리
import os

# 파이썬의 표준 라이브러리 함수로 운영체제의 환경 변수값을 읽어옴
SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret")
# 운영체제에서 ALGORITHM 환경 변수가 설정되어 있지 않으면 기본값으로 "HS256" 사용
ALGORITHM = os.getenv("ALGORITHM", "HS256")
# 운영체제에서 ACCESS_TOKEN_MINUTES 환경 변수가 없다면 15분으로 설정
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_MINUTES", "15"))
# 운영체제에서 REFRESH_TOKEN_DAYS 환경 변수가 없다면 7일로 설정
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_DAYS", "7"))


#schemes: 사용할 암호화 알고리즘 목록, deprecated: 더 이상 사용되지 않는 알고리즘 처리 방법
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# 평문 비밀번호(plain)와 해시된 비밀번호(hashed)를 비교하여 일치 여부를 반환 함수
def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

# 평문 비밀번호(plain)를 해시된 비밀번호로 변환하는 함수
def hash_password(plain: str) -> str:
    return pwd_context.hash(plain)

# JWT 토큰 생성 함수
def _create_token(subject: str, expires_delta: timedelta, token_type: str):
    '''
    Header: 자동 생성 후 encoding 과정에서 포함됨 ex) {"alg": "HS256", "typ": "JWT"}
    Payload: 사용자 정보 encoding
    Signature: SECRET_KEY와 ALGORITHM으로 생성
    '''
    now = datetime.now(timezone.utc) #표준 세계 시각
    payload = {
        "sub": subject,             # 사용자 식별자
        "type": token_type,         # "access" or "refresh"
        "iat": int(now.timestamp()),# 토큰 발급 시간 (timestamp : 초 단위 실수)
        "exp": int((now + expires_delta).timestamp()), # 토큰 만료 시간
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def create_access_token(user_id: str) -> str:
    return _create_token(user_id, timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES), "access")

def create_refresh_token(user_id: str) -> str:
    return _create_token(user_id, timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS), "refresh")

def decode_token(token: str) -> dict:
    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM]) # 페이로드값만 나옴

#토큰으로 id 추출 및 검증
def require_access(token: str) -> str:
    """
    Access 토큰 검증. 성공 시 user_id(sub) 리턴.
    실패/만료 시 예외를 그대로 올림.
    """
    payload = decode_token(token)
    if payload.get("type") != "access":
        raise JWTError("Invalid token type")
    return payload["sub"] #식별자인 id 반환
