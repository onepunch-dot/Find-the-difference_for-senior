# Supabase 설정 가이드

## 1. Supabase 프로젝트 생성

1. [Supabase](https://supabase.com)에 접속하여 로그인
2. "New Project" 클릭
3. 프로젝트 이름, 데이터베이스 비밀번호 설정
4. 리전 선택 (Seoul 또는 Tokyo 권장)
5. 프로젝트 생성 완료

## 2. 데이터베이스 스키마 적용

1. Supabase 대시보드에서 SQL Editor 열기
2. `supabase/schema.sql` 파일의 내용을 복사하여 붙여넣기
3. "Run" 버튼 클릭하여 실행
4. 에러 없이 완료되었는지 확인

## 3. Storage 설정

### 버킷 생성

1. Supabase 대시보드에서 Storage 메뉴 선택
2. "Create a new bucket" 클릭
3. 다음 버킷들을 생성:
   - `stage-images` (Public)
   - `theme-audio` (Public)

### Storage 정책 설정

SQL Editor에서 다음 쿼리 실행:

```sql
-- stage-images 버킷 공개 읽기 권한
CREATE POLICY "Public Access" ON storage.objects FOR SELECT
USING (bucket_id = 'stage-images');

-- theme-audio 버킷 공개 읽기 권한
CREATE POLICY "Public Access" ON storage.objects FOR SELECT
USING (bucket_id = 'theme-audio');
```

## 4. 앱 설정

1. Supabase 대시보드에서 Settings > API 메뉴 선택
2. Project URL과 anon public key 복사
3. `lib/data/supabase/supabase_client.dart` 파일 수정:

```dart
static const String _supabaseUrl = 'YOUR_SUPABASE_URL';
static const String _supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

## 5. 테스트

앱을 실행하여 다음 사항 확인:

1. ✅ 테마 목록 로드
2. ✅ 스테이지 목록 로드
3. ✅ 익명 로그인 작동
4. ✅ 완료 기록 저장
5. ✅ 구매 기록 저장

## 6. 이미지 업로드 (선택)

실제 이미지를 사용하려면:

1. Storage > stage-images 버킷 선택
2. 폴더 구조: `{stage_id}/imageA.webp`, `{stage_id}/imageB.webp`
3. 이미지 업로드 후 URL 확인
4. stages 테이블의 image_a_url, image_b_url 필드 업데이트

## 7. 샘플 데이터 확인

SQL Editor에서 확인:

```sql
-- 테마 개수 확인
SELECT COUNT(*) FROM themes;

-- 스테이지 개수 확인
SELECT COUNT(*) FROM stages;

-- 테마별 스테이지 개수
SELECT t.name, COUNT(s.id) as stage_count
FROM themes t
LEFT JOIN stages s ON t.id = s.theme_id
GROUP BY t.id, t.name
ORDER BY t."order";
```

## 트러블슈팅

### 연결 오류
- URL과 anon key가 정확한지 확인
- 인터넷 연결 확인
- Supabase 프로젝트가 활성 상태인지 확인

### RLS 오류
- 익명 로그인이 활성화되어 있는지 확인
- RLS 정책이 올바르게 설정되었는지 확인

### 데이터 없음
- schema.sql이 정상적으로 실행되었는지 확인
- 샘플 데이터가 삽입되었는지 SQL Editor에서 확인
