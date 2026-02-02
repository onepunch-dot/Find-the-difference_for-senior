#!/usr/bin/env python3
"""
테스트용 placeholder 이미지 생성 스크립트
실제 이미지 없이 빠르게 테스트하기 위한 용도

사용법:
    python3 generate_test_images.py

필요한 패키지:
    pip3 install pillow
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_placeholder_image(text, filename, width=2048, height=1536, color='lightblue'):
    """Placeholder 이미지 생성"""
    # 이미지 생성
    img = Image.new('RGB', (width, height), color=color)
    draw = ImageDraw.Draw(img)

    # 텍스트 추가
    try:
        # 시스템 폰트 사용 시도
        font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 120)
    except:
        # 기본 폰트 사용
        font = ImageFont.load_default()

    # 텍스트 중앙 정렬
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    position = ((width - text_width) // 2, (height - text_height) // 2)

    # 텍스트 그리기
    draw.text(position, text, fill='darkblue', font=font)

    # 장식용 사각형들 추가
    for i in range(5):
        x = i * 400 + 100
        y = i * 300 + 100
        draw.rectangle([x, y, x + 200, y + 150], outline='navy', width=5)

    # 저장
    img.save(filename, 'JPEG', quality=85)
    print(f"생성 완료: {filename}")

def main():
    """메인 함수"""
    # 출력 디렉토리 생성
    output_dir = "test_images"
    os.makedirs(output_dir, exist_ok=True)

    stages = [
        {"id": "101", "name": "남산타워"},
        {"id": "102", "name": "경복궁"},
        {"id": "103", "name": "한강공원"},
    ]

    for stage in stages:
        stage_dir = os.path.join(output_dir, "seoul", stage["id"])
        os.makedirs(stage_dir, exist_ok=True)

        # ImageA 생성
        imageA_path = os.path.join(stage_dir, "imageA.jpg")
        create_placeholder_image(
            f"{stage['name']}\nImage A",
            imageA_path,
            color='lightblue'
        )

        # ImageB 생성 (약간 다른 색상)
        imageB_path = os.path.join(stage_dir, "imageB.jpg")
        create_placeholder_image(
            f"{stage['name']}\nImage B",
            imageB_path,
            color='lightcoral'
        )

    print("\n✅ 테스트 이미지 생성 완료!")
    print(f"📁 위치: {os.path.abspath(output_dir)}")
    print("\n다음 단계:")
    print("1. Supabase Storage → stage-images 버킷 열기")
    print("2. test_images/seoul 폴더 전체를 업로드")
    print("   (101, 102, 103 폴더가 자동으로 생성됨)")

if __name__ == "__main__":
    main()
