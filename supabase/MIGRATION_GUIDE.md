# Purchases 테이블 마이그레이션 가이드

## 문제 상황
앱에서 다음 오류 발생:
```
PostgrestException: column purchases.type does not exist, code: 42703
```

## 원인
- `purchases` 테이블에 `type`, `product_id` 컬럼이 없음
- 코드에서는 이 컬럼들을 사용하고 있어 불일치 발생

## 해결 방법

### 옵션 1: 마이그레이션 SQL 실행 (권장)

1. **Supabase 대시보드 접속**
   - https://orjuplurmdbpkdsmameb.supabase.co 접속
   - SQL Editor 메뉴 선택

2. **마이그레이션 SQL 실행**
   - `supabase/migration_add_purchase_columns.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭
   - 성공 메시지 확인

3. **검증**
   ```sql
   -- purchases 테이블 구조 확인
   SELECT column_name, data_type, is_nullable
   FROM information_schema.columns
   WHERE table_name = 'purchases'
   ORDER BY ordinal_position;
   ```

   **예상 결과:**
   ```
   column_name   | data_type              | is_nullable
   --------------|------------------------|------------
   id            | uuid                   | NO
   user_id       | uuid                   | NO
   type          | character varying      | NO
   theme_id      | uuid                   | YES
   product_id    | character varying      | NO
   purchased_at  | timestamp with time zone| YES
   ```

### 옵션 2: 전체 스키마 재실행 (새 프로젝트인 경우)

1. **모든 테이블 삭제 (주의!)**
   ```sql
   DROP TABLE IF EXISTS completions CASCADE;
   DROP TABLE IF EXISTS purchases CASCADE;
   DROP TABLE IF EXISTS stages CASCADE;
   DROP TABLE IF EXISTS themes CASCADE;
   ```

2. **전체 스키마 실행**
   - `supabase/schema.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭

## 변경 사항 요약

### 수정 전
```sql
CREATE TABLE purchases (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  theme_id UUID NOT NULL,
  purchased_at TIMESTAMP
);
```

### 수정 후
```sql
CREATE TABLE purchases (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  type VARCHAR(20) NOT NULL,          -- 추가됨
  theme_id UUID,                       -- nullable로 변경
  product_id VARCHAR(100) NOT NULL,    -- 추가됨
  purchased_at TIMESTAMP
);
```

## 적용 후 확인사항

1. ✅ Flutter 앱 핫 리로드 (터미널에서 `R` 입력)
2. ✅ 테마 목록이 정상적으로 로드되는지 확인
3. ✅ 에러 메시지가 사라졌는지 확인

## 트러블슈팅

### "relation purchases already exists" 에러
- 이미 테이블이 존재하는 경우
- `DROP TABLE purchases CASCADE;` 먼저 실행 후 다시 시도

### "permission denied" 에러
- Supabase 프로젝트 소유자 계정으로 로그인했는지 확인
- SQL Editor에서 실행 권한 확인

## 참고
- 수정된 스키마: `supabase/schema.sql`
- 마이그레이션 파일: `supabase/migration_add_purchase_columns.sql`
