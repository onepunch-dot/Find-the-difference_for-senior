-- purchases 테이블에 누락된 컬럼 추가 마이그레이션
-- 생성일: 2026-02-04

-- 1. 기존 purchases 테이블 삭제 (데이터가 없는 경우에만)
-- 주의: 실제 구매 데이터가 있다면 이 부분은 주석 처리하고 ALTER TABLE 방식 사용
DROP TABLE IF EXISTS purchases CASCADE;

-- 2. 새로운 purchases 테이블 생성
CREATE TABLE IF NOT EXISTS purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('theme', 'ad_removal')), -- 'theme' | 'ad_removal'
  theme_id UUID REFERENCES themes(id) ON DELETE CASCADE, -- nullable: ad_removal일 경우 NULL
  product_id VARCHAR(100) NOT NULL, -- IAP 제품 ID
  purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, type, theme_id) -- type별로 중복 방지
);

-- 3. 인덱스 재생성
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_user_type ON purchases(user_id, type); -- type 조회 최적화
CREATE INDEX IF NOT EXISTS idx_purchases_theme_id ON purchases(theme_id);

-- 4. RLS (Row Level Security) 활성화
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

-- 5. RLS 정책 재생성
DROP POLICY IF EXISTS "Users can read their own purchases" ON purchases;
DROP POLICY IF EXISTS "Users can insert their own purchases" ON purchases;

CREATE POLICY "Users can read their own purchases" ON purchases
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own purchases" ON purchases
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 완료 메시지
DO $$
BEGIN
  RAISE NOTICE 'Migration completed successfully!';
  RAISE NOTICE 'purchases 테이블이 type, product_id 컬럼과 함께 재생성되었습니다.';
END $$;
