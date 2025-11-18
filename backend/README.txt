//만약 서버를 열어서 DB를 갔다오고 싶으면 다음 코드를 터미널에서 실행시키세요.
uvicorn backend.main:app --reload --host 127.0.0.1 --port 8000



***
uvicorn => FastAPI를 실행해주는 ASGI서버
backend.main:app => <모듈경로>:<FastAPI 객체 이름>
--reload => 코드가 바뀔 때 자동으로 서버를 재시작
--host 127.0.0.1 => 서버가 어디에서 접근 가능한지를 설정 127.0.0.1은 내 컴퓨터 내부 전용 주소
                    다른 기기에서 접근하고 싶으면 --host 0.0.0.0으로 변경
--port 8000 => 서버가 열릴 포트 번호 (문)
***

JWT의존성을 위해 다음 코드를 실행 해 주세요.(1번만 실행)
pip install fastapi uvicorn[standard] python-jose[cryptography] passlib[bcrypt] python-dotenv


__pycache__ : 성능을 높이기 위해 파이썬이 자동으로 생성하는 캐시 디렉토리

__init__ : 해당 폴더가 파이썬 패키지라는 것을 인식시키기 위한 명시적 표현

[테스트 id]
id kmj
pw kmjkmj


[오류정리]
401 : 토큰 에러
400 : 입력 형식 오류
409 : 이미 존재하는 데이터

토큰에 담긴 정보
Header : 알고리즘, 토큰 타입
Payload : 사용자 정보 (sub(id), type(access/refresh), iat(발급시간), exp(만료시간) )
Signature : 비밀키와 알고리즘으로 개인마다 다른 시그니처를 갖음