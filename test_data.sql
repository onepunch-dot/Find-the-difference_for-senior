-- 테스트 데이터 입력
-- Supabase SQL Editor에서 실행

-- 1. 기존 테스트 테마 업데이트 (서울)
UPDATE themes
SET
  is_paid = false,
  bgm_path = 'seoul/bgm.mp3',
  bgm_version = 1,
  preview_images = '["seoul/preview1.jpg", "seoul/preview2.jpg"]'::jsonb
WHERE title = '서울';

-- 2. 추가 테마 입력 (부산 - 유료, 도쿄 - 유료)
INSERT INTO themes (title, order_index, is_published, is_paid, price_tier, bgm_path, bgm_version, preview_images)
VALUES
  ('부산', 2, false, true, 'theme_pack_busan', 'busan/bgm.mp3', 1, '["busan/preview1.jpg"]'::jsonb),
  ('도쿄', 3, false, true, 'theme_pack_tokyo', 'tokyo/bgm.mp3', 1, '["tokyo/preview1.jpg"]'::jsonb)
ON CONFLICT DO NOTHING;

-- 3. 서울 테마의 스테이지 입력 (테스트용 3개)
-- 먼저 서울 테마 ID 가져오기
DO $$
DECLARE
  seoul_theme_id BIGINT;
BEGIN
  SELECT id INTO seoul_theme_id FROM themes WHERE title = '서울';

  -- 스테이지 1
  INSERT INTO stages (
    theme_id,
    title,
    imageA_path,
    imageB_path,
    answers,
    total_answers,
    image_width,
    image_height,
    imageA_version,
    imageB_version,
    order_index,
    is_published,
    difficulty
  ) VALUES (
    seoul_theme_id,
    '남산타워',
    'seoul/101/imageA.webp',
    'seoul/101/imageB.webp',
    '[
      {"x": 300, "y": 400, "radius": 30},
      {"x": 800, "y": 600, "radius": 35},
      {"x": 1200, "y": 800, "radius": 40}
    ]'::jsonb,
    3,
    2048,
    1536,
    1,
    1,
    1,
    true,
    1
  );

  -- 스테이지 2
  INSERT INTO stages (
    theme_id,
    title,
    imageA_path,
    imageB_path,
    answers,
    total_answers,
    image_width,
    image_height,
    imageA_version,
    imageB_version,
    order_index,
    is_published,
    difficulty
  ) VALUES (
    seoul_theme_id,
    '경복궁',
    'seoul/102/imageA.webp',
    'seoul/102/imageB.webp',
    '[
      {"x": 400, "y": 500, "radius": 35},
      {"x": 900, "y": 700, "radius": 40},
      {"x": 1400, "y": 900, "radius": 30},
      {"x": 600, "y": 300, "radius": 35}
    ]'::jsonb,
    4,
    2048,
    1536,
    1,
    1,
    2,
    true,
    1
  );

  -- 스테이지 3
  INSERT INTO stages (
    theme_id,
    title,
    imageA_path,
    imageB_path,
    answers,
    total_answers,
    image_width,
    image_height,
    imageA_version,
    imageB_version,
    order_index,
    is_published,
    difficulty
  ) VALUES (
    seoul_theme_id,
    '한강공원',
    'seoul/103/imageA.webp',
    'seoul/103/imageB.webp',
    '[
      {"x": 500, "y": 600, "radius": 30},
      {"x": 1000, "y": 800, "radius": 35},
      {"x": 1500, "y": 1000, "radius": 40},
      {"x": 700, "y": 400, "radius": 35},
      {"x": 300, "y": 200, "radius": 30}
    ]'::jsonb,
    5,
    2048,
    1536,
    1,
    1,
    3,
    true,
    2
  );

END $$;

-- 확인
SELECT t.title as theme, s.title as stage, s.total_answers, s.is_published
FROM themes t
LEFT JOIN stages s ON t.id = s.theme_id
ORDER BY t.order_index, s.order_index;
