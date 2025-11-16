# backend/api/v1/photos.py

import io
import os

from fastapi import APIRouter, UploadFile, File, Depends, HTTPException
from fastapi import status

from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseUpload
from google.oauth2.service_account import Credentials

from backend.schemas.photo import PhotoBase, PhotoListResponse  # 상대경로 주의
from backend.db import photo_repository  # backend/db/photo_repository.py
from backend.api.dependencies import auth_dependency  # 이미 사용중인 auth dependency (현재 유저 id 얻기)

router = APIRouter(
    prefix="/photos",
    tags=["photos"],
)


# 구글 드라이브 서비스 생성 함수
def get_drive_service():
    service_account_file = os.getenv("GOOGLE_SERVICE_ACCOUNT_FILE")
    if not service_account_file:
        raise RuntimeError("GOOGLE_SERVICE_ACCOUNT_FILE is not set in .env")

    scopes = ["https://www.googleapis.com/auth/drive.file"]
    creds = Credentials.from_service_account_file(
        service_account_file,
        scopes=scopes,
    )
    service = build("drive", "v3", credentials=creds)
    return service


@router.post("/upload", response_model=PhotoBase, status_code=status.HTTP_201_CREATED)
async def upload_photo(
    file: UploadFile = File(...),
    current_user_id: str = Depends(auth_dependency),
):
    """
    Flutter에서 올라온 사진을 구글 드라이브에 업로드하고
    해당 유저와 매핑하여 DB에 저장한 뒤, image_url을 반환.
    """
    # 파일 읽기
    file_bytes = await file.read()
    if not file_bytes:
        raise HTTPException(status_code=400, detail="빈 파일입니다.")

    drive_folder_id = os.getenv("GOOGLE_DRIVE_FOLDER_ID")
    if not drive_folder_id:
        raise HTTPException(status_code=500, detail="GOOGLE_DRIVE_FOLDER_ID 설정 필요")

    # 구글 드라이브 서비스
    service = get_drive_service()

    # 메타데이터
    file_metadata = {
        "name": file.filename,
        "parents": [drive_folder_id],
    }

    media = MediaIoBaseUpload(
        io.BytesIO(file_bytes),
        mimetype=file.content_type or "image/jpeg",
        resumable=True,
    )

    # 파일 업로드
    uploaded_file = (
        service.files()
        .create(body=file_metadata, media_body=media, fields="id, webViewLink, webContentLink")
        .execute()
    )
    drive_file_id = uploaded_file["id"]

    # 공개 읽기 권한 부여 (anyone with the link)
    service.permissions().create(
        fileId=drive_file_id,
        body={"type": "anyone", "role": "reader"},
    ).execute()

    # webContentLink 또는 webViewLink 중 하나 사용
    image_url = uploaded_file.get("webContentLink") or uploaded_file.get("webViewLink")

    if not image_url:
        # fallback: 직접 다운로드 URL(간단 예시)
        image_url = f"https://drive.google.com/uc?id={drive_file_id}"

    # DB 저장
    record = photo_repository.save_photo(
        user_id=current_user_id,
        drive_file_id=drive_file_id,
        image_url=image_url,
    )

    return PhotoBase(id=record["id"], image_url=record["image_url"])


@router.get("/me", response_model=PhotoListResponse)
def get_my_photos(current_user_id: str = Depends(auth_dependency)):
    """
    현재 로그인한 유저의 사진 리스트 반환
    """
    records = photo_repository.get_photos_by_user(current_user_id)
    photos = [PhotoBase(id=r["id"], image_url=r["image_url"]) for r in records]
    return PhotoListResponse(photos=photos)
