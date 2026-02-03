-- 틀린그림찾기 앱 데이터베이스 스키마

-- 테마 테이블
CREATE TABLE IF NOT EXISTS themes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  name_en VARCHAR(100) NOT NULL,
  description TEXT,
  description_en TEXT,
  thumbnail_url TEXT,
  is_free BOOLEAN DEFAULT true,
  price INTEGER, -- 원타임 결제 가격 (원)
  bgm_url TEXT,
  bgm_version INTEGER DEFAULT 1,
  "order" INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 스테이지 테이블
CREATE TABLE IF NOT EXISTS stages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  theme_id UUID NOT NULL REFERENCES themes(id) ON DELETE CASCADE,
  stage_number INTEGER NOT NULL,
  image_a_url TEXT,
  image_b_url TEXT,
  image_version INTEGER DEFAULT 1,
  answers JSONB NOT NULL DEFAULT '[]'::jsonb, -- [{x, y, radius}, ...]
  difficulty INTEGER DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(theme_id, stage_number)
);

-- 구매 기록 테이블
CREATE TABLE IF NOT EXISTS purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  theme_id UUID NOT NULL REFERENCES themes(id) ON DELETE CASCADE,
  purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, theme_id)
);

-- 완료 기록 테이블
CREATE TABLE IF NOT EXISTS completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  stage_id UUID NOT NULL REFERENCES stages(id) ON DELETE CASCADE,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, stage_id)
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_stages_theme_id ON stages(theme_id);
CREATE INDEX IF NOT EXISTS idx_stages_stage_number ON stages(theme_id, stage_number);
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_theme_id ON purchases(theme_id);
CREATE INDEX IF NOT EXISTS idx_completions_user_id ON completions(user_id);
CREATE INDEX IF NOT EXISTS idx_completions_stage_id ON completions(stage_id);

-- RLS (Row Level Security) 활성화
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE completions ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 모든 사용자가 테마와 스테이지를 읽을 수 있음
CREATE POLICY "Anyone can read themes" ON themes FOR SELECT USING (true);
CREATE POLICY "Anyone can read stages" ON stages FOR SELECT USING (true);

-- RLS 정책: 사용자는 자신의 구매/완료 기록만 읽고 쓸 수 있음
CREATE POLICY "Users can read their own purchases" ON purchases FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own purchases" ON purchases FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read their own completions" ON completions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own completions" ON completions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 샘플 데이터 삽입 (테스트용)
INSERT INTO themes (id, name, name_en, description, description_en, is_free, "order")
VALUES
  ('550e8400-e29b-41d4-a716-446655440001', '도시의 그림자', 'City Shadows', '어두운 도시의 숨겨진 이야기를 찾아보세요', 'Find hidden stories in the dark city', true, 1),
  ('550e8400-e29b-41d4-a716-446655440002', '비밀의 정원', 'Secret Garden', '신비로운 정원의 비밀을 발견하세요', 'Discover secrets in the mysterious garden', true, 2),
  ('550e8400-e29b-41d4-a716-446655440003', '미래의 빛', 'Future Light', '미래 도시의 찬란한 빛을 탐험하세요', 'Explore brilliant lights of future city', false, 3)
ON CONFLICT (id) DO NOTHING;

-- 샘플 스테이지 데이터
INSERT INTO stages (theme_id, stage_number, answers, difficulty)
VALUES
  -- 도시의 그림자 테마
  ('550e8400-e29b-41d4-a716-446655440001', 1, '[{"x": 0.3, "y": 0.4, "radius": 0.05}, {"x": 0.6, "y": 0.7, "radius": 0.04}, {"x": 0.5, "y": 0.2, "radius": 0.06}]'::jsonb, 1),
  ('550e8400-e29b-41d4-a716-446655440001', 2, '[{"x": 0.2, "y": 0.3, "radius": 0.05}, {"x": 0.7, "y": 0.5, "radius": 0.04}, {"x": 0.4, "y": 0.8, "radius": 0.05}]'::jsonb, 2),
  ('550e8400-e29b-41d4-a716-446655440001', 3, '[{"x": 0.25, "y": 0.35, "radius": 0.04}, {"x": 0.65, "y": 0.55, "radius": 0.05}, {"x": 0.45, "y": 0.75, "radius": 0.06}]'::jsonb, 2),

  -- 비밀의 정원 테마
  ('550e8400-e29b-41d4-a716-446655440002', 1, '[{"x": 0.35, "y": 0.45, "radius": 0.06}, {"x": 0.55, "y": 0.65, "radius": 0.05}, {"x": 0.75, "y": 0.25, "radius": 0.04}]'::jsonb, 1),
  ('550e8400-e29b-41d4-a716-446655440002', 2, '[{"x": 0.3, "y": 0.5, "radius": 0.05}, {"x": 0.6, "y": 0.6, "radius": 0.04}, {"x": 0.8, "y": 0.3, "radius": 0.05}]'::jsonb, 2),

  -- 미래의 빛 테마 (잠긴 테마)
  ('550e8400-e29b-41d4-a716-446655440003', 1, '[{"x": 0.4, "y": 0.5, "radius": 0.05}, {"x": 0.5, "y": 0.6, "radius": 0.04}]'::jsonb, 1)
ON CONFLICT (theme_id, stage_number) DO NOTHING;

-- 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- 업데이트 트리거 생성
DROP TRIGGER IF EXISTS update_themes_updated_at ON themes;
CREATE TRIGGER update_themes_updated_at BEFORE UPDATE ON themes
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_stages_updated_at ON stages;
CREATE TRIGGER update_stages_updated_at BEFORE UPDATE ON stages
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
