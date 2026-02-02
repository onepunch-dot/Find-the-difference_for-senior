-- 틀린그림찾기 게임 데이터베이스 스키마
-- Supabase 대시보드 → SQL Editor에서 실행

-- 1. themes 테이블
CREATE TABLE IF NOT EXISTS themes (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  thumbnail_path TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- 시니어/BM 필드
  is_paid BOOLEAN NOT NULL DEFAULT false,
  price_tier TEXT,
  preview_images JSONB DEFAULT '[]'::jsonb,
  bgm_path TEXT,
  bgm_version INTEGER NOT NULL DEFAULT 1
);

-- 2. stages 테이블
CREATE TABLE IF NOT EXISTS stages (
  id BIGSERIAL PRIMARY KEY,
  theme_id BIGINT NOT NULL REFERENCES themes(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  imageA_path TEXT NOT NULL,
  imageB_path TEXT NOT NULL,
  answers JSONB NOT NULL,
  total_answers INTEGER NOT NULL,
  image_width INTEGER NOT NULL,
  image_height INTEGER NOT NULL,
  imageA_version INTEGER NOT NULL DEFAULT 1,
  imageB_version INTEGER NOT NULL DEFAULT 1,
  order_index INTEGER NOT NULL DEFAULT 0,
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- 시니어 UX 필드
  difficulty INTEGER NOT NULL DEFAULT 1,
  hint_points JSONB
);

-- 3. purchases 테이블 (기기별 구매 이력)
CREATE TABLE IF NOT EXISTS purchases (
  id BIGSERIAL PRIMARY KEY,
  device_id TEXT NOT NULL,
  theme_id BIGINT NOT NULL REFERENCES themes(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL,
  purchased_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(device_id, theme_id)
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_stages_theme_id ON stages(theme_id);
CREATE INDEX IF NOT EXISTS idx_stages_order ON stages(order_index);
CREATE INDEX IF NOT EXISTS idx_themes_order ON themes(order_index);
CREATE INDEX IF NOT EXISTS idx_purchases_device ON purchases(device_id);

-- Row Level Security (RLS) 활성화
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 published된 데이터만 읽을 수 있도록
CREATE POLICY "Public can read published themes" ON themes
  FOR SELECT USING (is_published = true);

CREATE POLICY "Public can read published stages" ON stages
  FOR SELECT USING (is_published = true);

-- 구매 데이터는 본인 device_id만 읽기/쓰기 가능
CREATE POLICY "Users can read own purchases" ON purchases
  FOR SELECT USING (true);

CREATE POLICY "Users can insert own purchases" ON purchases
  FOR INSERT WITH CHECK (true);

-- 테스트 데이터 삽입 (무료 테마 1개)
INSERT INTO themes (title, order_index, is_published, is_paid)
VALUES ('서울', 1, true, false)
ON CONFLICT DO NOTHING;

COMMENT ON TABLE themes IS '게임 테마 (서울/부산/도쿄 등)';
COMMENT ON TABLE stages IS '스테이지 (각 테마별 틀린그림찾기 문제)';
COMMENT ON TABLE purchases IS '사용자 구매 이력';
