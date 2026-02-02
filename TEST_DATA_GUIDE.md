# 테스트 데이터 준비 가이드

## 1. 데이터베이스 테스트 데이터 입력

### Supabase SQL Editor에서 실행

1. Supabase 대시보드 → SQL Editor 열기
2. `test_data.sql` 파일 내용 복사 & 붙여넣기
3. "Run" 클릭
4. Table Editor에서 확인:
   - themes: 서울(무료), 부산(유료), 도쿄(유료)
   - stages: 서울 테마에 3개 스테이지

---

## 2. 테스트 이미지 준비

### 방법 A: 간단한 테스트 이미지 사용 (빠른 테스트용)

임시로 동일한 이미지를 A/B에 사용하여 구조만 테스트할 수 있습니다.

1. 무료 이미지 사이트에서 이미지 다운로드:
   - [Unsplash](https://unsplash.com) - 서울 풍경 검색
   - [Pexels](https://pexels.com)
   - 가로 2048px, 세로 1536px 권장

2. 이미지 준비:
   ```
   seoul/101/imageA.webp
   seoul/101/imageB.webp
   seoul/102/imageA.webp
   seoul/102/imageB.webp
   seoul/103/imageA.webp
   seoul/103/imageB.webp
   ```

3. WebP 변환 (선택사항):
   - 온라인 변환: https://cloudconvert.com/jpg-to-webp
   - 또는 JPG 그대로 사용 가능 (확장자를 .webp로 변경)

### 방법 B: 실제 틀린그림 이미지 제작

포토샵이나 이미지 편집 툴 사용:
1. imageA.jpg 준비
2. imageA를 복사하여 imageB 생성
3. imageB에서 일부 요소 수정:
   - 색상 변경
   - 작은 객체 추가/제거
   - 텍스트 수정 등
4. WebP로 저장

---

## 3. Storage에 이미지 업로드

### Supabase Storage 업로드

1. **stage-images 버킷 열기**
   - Supabase 대시보드 → Storage → stage-images

2. **폴더 구조 생성**
   - "New folder" 클릭: `seoul` 폴더 생성
   - seoul 폴더 진입 → `101` 폴더 생성
   - 같은 방식으로 `102`, `103` 폴더 생성

3. **이미지 업로드**
   ```
   seoul/101/ → imageA.webp, imageB.webp 업로드
   seoul/102/ → imageA.webp, imageB.webp 업로드
   seoul/103/ → imageA.webp, imageB.webp 업로드
   ```

4. **이미지 경로 확인**
   - 업로드 후 이미지 클릭 → "Copy URL" 확인
   - 경로 형식: `https://[project].supabase.co/storage/v1/object/public/stage-images/seoul/101/imageA.webp`

---

## 4. BGM 파일 (선택사항)

테스트 단계에서는 BGM 없이 진행 가능합니다. BGM을 추가하려면:

1. **무료 BGM 다운로드**
   - [YouTube Audio Library](https://studio.youtube.com)
   - [Incompetech](https://incompetech.com)
   - MP3 형식, 1-3분 길이

2. **theme-audio 버킷에 업로드**
   ```
   seoul/bgm.mp3
   ```

---

## 5. 앱 실행 및 테스트

### Flutter 앱 실행

```bash
cd /Users/han/Downloads/projects/find_difference_app
flutter run
```

### 테스트 시나리오

1. ✅ 홈 화면 → "시작하기" 버튼
2. ✅ 테마 선택 화면 → "서울" 테마 클릭
3. ✅ 스테이지 목록 → 3개 스테이지 표시 확인
4. ✅ 스테이지 1 클릭 → 게임 화면 진입
5. ✅ 이미지 A/B 표시 확인 (placeholder)

---

## 6. 문제 해결

### 이미지가 표시되지 않는 경우

1. **Storage 경로 확인**
   - stages 테이블의 `imageA_path`, `imageB_path` 확인
   - Storage에 실제 파일이 있는지 확인

2. **버킷 public 설정 확인**
   - Storage → stage-images → Settings
   - "Public bucket" 체크되어 있어야 함

3. **URL 직접 테스트**
   - 브라우저에서 이미지 URL 직접 열어보기
   - `https://[project].supabase.co/storage/v1/object/public/stage-images/seoul/101/imageA.webp`

### 테마가 표시되지 않는 경우

1. **is_published 확인**
   ```sql
   SELECT * FROM themes WHERE is_published = true;
   ```

2. **Flutter 앱 재시작**
   ```bash
   flutter run
   ```

---

## 다음 단계

테스트 데이터 입력 완료 후:
- [ ] 데이터베이스에 테마 3개 확인
- [ ] 서울 테마에 스테이지 3개 확인
- [ ] Storage에 이미지 6개 업로드
- [ ] 앱 실행 및 화면 흐름 테스트
- [ ] StagePage 핵심 기능 구현으로 진행
