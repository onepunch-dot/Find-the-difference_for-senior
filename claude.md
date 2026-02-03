## 0) 이 문서의 역할
- 이 프로젝트에서 **Claude Code가 지켜야 할 구현 규칙 + 산출물 기준 + 실행 순서**를 정의한다.
- 기능/요구사항의 “설명”은 PRD에 있고, 여기서는 **구조/규칙/체크**만 다룬다.
- UI/UIX는 반드시 **Stitch MCP**로 “화면 스케치 → 위젯 구현” 순서로 진행한다.

---

## 1) 기술 스택 고정
- Flutter (Android/iOS)
- Supabase: Postgres + Storage
- 광고: AdMob (배너 + 리워드)
- 인앱결제: 원타임(테마팩), 광고제거(원타임)
- 로컬 캐시: 이미지/BGM 파일 캐시 + 버전 무효화
- 오프라인: **다운로드된(또는 구매된) 콘텐츠는 네트워크 없이 플레이 가능**

---

## 2) 개발 원칙 (중요)
### 2-1. UX 우선순위
- 조작 실수/피로를 줄이는 방향이 최우선(큰 버튼/명확한 피드백/과도한 연출 금지).
- “하트/타이머”는 기본 OFF이며, 설정에서 ON 가능하도록 **옵션 기반 설계**로 만든다.

### 2-2. UI 구현 프로세스(필수)
- **모든 화면은 먼저 Stitch MCP로 화면 스케치 생성** 후, 그 결과를 기반으로 Flutter UI를 작성한다.
- 화면을 하나씩 만든다. (Loading → Home → StageList → Stage → Result 순)

### 2-3. 데이터/오프라인 원칙
- 서버는 “정답 좌표/스테이지 메타/에셋 경로/버전”의 단일 진실(SoT).
- 클라이언트는 “다운로드 + 캐시 + 버전 비교 후 갱신”만 책임진다.
- 네트워크 실패 시에도 앱이 “깨지지 않게” 상태 UI를 표준화한다.

### 2-4. 자동화/개입 최소화 원칙 (Claude Code 주도)
- Supabase 스키마/정책/인덱스/마이그레이션(SQL), 그리고 Stitch MCP 기반 UI 스케치는 Claude Code가 가능한 범위에서 스스로 생성·적용·검증한다.
- 사용자의 수동 개입은 최초 로그인/인증, 권한 승인, 스토어 결제 승인처럼 필수로 막히는 구간으로만 제한한다.
- 수동 개입이 필요해지는 경우에도, Claude Code는 사용자가 해야 할 동작을 최소 단계로 정리하고 그 외 작업은 계속 자동으로 진행한다.

### 2-5. TDD 원칙
- 핵심 로직(정답 판정, A/B 동기화 상태, 힌트 카운터/리셋, 버전 비교/캐시 무효화, 오프라인 접근 제한)은 테스트를 먼저 작성하고 구현한다.
- 버그 수정은 “재현 테스트 추가 → 수정 → 회귀 방지” 순서를 고정한다.
- 테스트는 결정적/재현 가능해야 하며(시간/네트워크 의존 최소화), 외부 의존성(Supabase/AdMob/IAP)은 가능한 범위에서 mock/fake로 분리한다.

---

## 3) 폴더 구조 (권장, 고정)
아래 구조로 생성/유지한다.

```
lib/
  app.dart
  main.dart

  core/
    constants/
    routing/
    theme/
    localization/
    logging/
    utils/

  features/
    loading/
    home/
    stages/
    stage_play/
    result/
    settings/
    purchase/
    ads/
    audio/
    cache/
    offline/

  data/
    supabase/
      supabase_client.dart
      repositories/
      dto/
    local/
      cache_store.dart
      file_store.dart

  domain/
    models/
    repositories/
    usecases/

  presentation/
    widgets/
    dialogs/
    state/
```

**규칙**
- feature 단위로 “UI + state + usecase”가 한 덩어리로 묶이게 한다.
- `domain/models`는 UI 의존 금지.
- Supabase 접근은 `data/supabase/repositories`에서만 한다.

---

## 4) 네이밍 & 코드 규칙
- 화면: `HomePage`, `StageListPage`, `StagePage`, `ResultPage`, `LoadingPage`
- 상태관리: 화면별 `Controller/ViewModel` 1개로 단순화(불필요한 분할 금지)
- 비동기 로직은 “UI에서 직접 호출 금지” → usecase/controller 통해서만 호출
- 함수 80줄 이상 금지(쪼개기)
- 예외는 공통 `AppError`로 래핑하고 UI는 표준 에러 위젯 사용

---

## 5) 핵심 기능 모듈 경계(중복 없이 “경계만” 정의)
### 5-1. 콘텐츠(Theme/Stage)
- Theme: 카드 렌더링, 잠김/구매됨/무료 상태 표현
- Stage 목록: 완료 처리(시각적으로 채도↓/스탬프), 접근 불가 시 안내 모달

### 5-2. Stage 플레이(동기화가 핵심)
- A/B 이미지 뷰어는 한쪽 조작(핀치/드래그)이 다른쪽에 동일 반영
- 정답 판정은 원형(hit circle) 기반: `(x, y, radius)`  
- 정답 마커는 “두꺼운 링(테두리)”로 A/B 동일 위치에 표시
- 오답 피드백: 빨간 점 100~150ms, 페널티 없음(하트 ON일 때만 차감)

### 5-3. 힌트/광고
- 무료 힌트: 일 2개(00:00 리셋)
- 무료 힌트 0이면: 게임 일시정지 + 모달에서 리워드 광고로 힌트 획득
- 힌트는 “정답 위치 강조(점멸 링)”로 표시

### 5-4. BGM(테마별)
- 홈/대기실 BGM 1개 + 테마별 BGM 1개
- 최초 1회 다운로드 후 로컬 캐시 재생
- `bgm_version` 비교로 캐시 무효화

### 5-5. 오프라인 규칙
- 오프라인에서도 테마 리스트는 보이게
- “인터넷 필요(미구매/미다운로드)”는 비활성 또는 탭 시 안내 모달

---

## 6) Supabase 계약(Contract)
### 6-1. 테이블/스토리지
- DB 스키마는 PRD의 테이블 정의를 따른다. (themes, stages, purchases)
- Storage 버킷
  - `stage-images/` : 스테이지 이미지
  - `theme-audio/` : 테마 BGM

### 6-2. 버전 기반 캐시 무효화
- Stage 이미지: `image_version` 비교 → 다르면 재다운로드
- BGM: `bgm_version` 비교 → 다르면 재다운로드

### 6-3. 다운로드/캐시 키 규칙
- 이미지 캐시 키: `{stage_id}/imageA.webp`, `{stage_id}/imageB.webp`
- BGM 캐시 키: `{theme_id}/bgm.mp3`

---

## 7) Stitch MCP 연결(필수, 단일 진입점)
### 7-1. 원칙
- **UI 작업 시작 전** 반드시 Stitch MCP로 해당 화면을 그린다.
- 화면별 Stitch 프롬프트는 PRD의 “#6 Stitch 프롬프트”를 **참조**한다.
- claude.md에는 프롬프트를 복붙하지 않고, “어떤 섹션을 쓰는지”만 명시한다.

### 7-2. 화면별 Stitch 사용 지시
- Loading: PRD `#6 > 0) Loading`
- Home: PRD `#6 > 1) HOME`
- StageListPage: PRD `#6 > 2) STAGE LIST PAGE`
- StagePage: PRD `#6 > 4) STAGE PAGE` (+ TutorialMode 포함)
- ResultPage: PRD `#6 > 5) RESULT PAGE`
- Global/Design System: PRD `#6 > 0) GLOBAL / DESIGN SYSTEM`

**실행 규칙**
- 각 화면 구현 시, 먼저 Stitch 결과물을 기준으로 위젯 트리 구성 → 그 다음 상태/데이터 연결.

---

## 8) 구현 순서(이 순서 고정)
1) 프로젝트 스캐폴딩 + 라우팅 + 로컬라이즈 KO/EN 토대
2) Supabase client 연결 + repository 뼈대
3) 캐시/파일 저장 모듈(이미지/BGM)
4) LoadingPage 구현(콘텐츠 확인 후 Home 이동)
5) HomePage 구현(테마 리스트 + 잠김/구매 모달 + 설정 진입)
6) StageListPage 구현(2열/가로 스와이프 + 완료 표시)
7) StagePage 구현(핵심: A/B 동기화 + 판정 + 힌트/광고)
8) ResultPage 구현(다음/다시/나가기)
9) 광고/결제 모듈 연결(리워드/배너/IAP)
10) 오프라인/에러/로딩 상태 전 화면 정리

---

## 9) 품질 게이트(“맞는 코드인지 항상 검증” 실행 규칙)
### 9-1. 화면별 필수 체크
- Loading: 성공/실패/오프라인 처리 존재
- Home:
  - 테마 상태 3종(무료/구매됨/잠김) 표현이 명확
  - 오프라인 탭 시 안내 모달
- StageList:
  - 세로 2열 스크롤 / 가로 좌우 정렬(또는 스와이프) 동작 확인
  - 완료 스탬프 처리
- Stage:
  - A/B 핀치/드래그 완전 동기화
  - 정답 판정(원형 좌표) 정확
  - 정답 마커 A/B 동시 표시
  - 오답 피드백 100~150ms
  - 힌트: 무료 있을 때 즉시 / 없을 때 모달+리워드 광고
  - 뒤로가기 확인 모달
  - 튜토리얼 4단계 “스킵 없음” + 완료 후 원래 스테이지로 진입
- Result:
  - 3버튼(다음/다시/나가기) 동작
  - 다음 준비 로딩 처리

### 9-2. 자동/수동 테스트 최소셋
- 단위: hit-test(원형 판정), 힌트 카운터 리셋 로직, 버전 비교 로직
- 통합: 오프라인에서 접근 불가 콘텐츠 탭 시 모달 노출
- 수동: A/B 동기화(확대/이동), 화면 회전 시 레이아웃 전환

---

## 10) 출력 언어 규칙
- Claude의 작업 결과/리포트/커밋 메시지 설명은 **한글**로 작성한다.
- UI 카피는 기기 언어에 따라 KO/EN이 자동 적용되도록 설계한다(영어는 짧고 쉬운 단어).

---

## 11) 금지 사항
- Stitch 없이 UI부터 코드로 때려박기 금지
- 요구사항에 없는 과도한 UX(하트/타이머 강제, 페널티 강화 등) 금지
- 상태/에러 UI 없이 “그냥 스낵바”로 끝내기 금지
- 서버 데이터 계약을 임의로 바꾸기 금지(필요 시 마이그레이션 문서 먼저)
