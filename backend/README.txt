//만약 서버를 열어서 DB를 갔다오고 싶으면 다음 코드를 터미널에서 실행시키세요.
uvicorn backend.main:app --reload --host 127.0.0.1 --port 8000



***
uvicorn => FastAPI를 실행해주는 ASGI서버
backend.main:app => <모듈경로>:<FastAPI 객체 이름>
--reload => 코드가 바뀔 때 자동으로 서버를 재시작
--host 127.0.0.1 => 서버가 어디에서 접근 가능한지를 설정 127.0.0.1은 내 컴퓨터 내부 전용 주소
                    다른 기기에서 접근하고 싶으면 --host 0.0.0.0으로 변경
--port 8000 => 서버가 열릴 포트 번호
***

JWT의존성을 위해 다음 코드를 실행 해 주세요.(1번만 실행)
pip install fastapi uvicorn[standard] python-jose[cryptography] passlib[bcrypt] python-dotenv
