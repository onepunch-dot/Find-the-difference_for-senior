# Find Difference App (틀린그림찾기)

Flutter 기반 모바일 틀린그림찾기 게임 애플리케이션

## 프로젝트 구조

```
lib/
  ├── app.dart                      # MaterialApp 설정
  ├── main.dart                     # 앱 진입점
  ├── core/                         # 핵심 인프라
  │   ├── constants/
  │   ├── routing/                  # go_router 설정
  │   ├── theme/                    # Material 3 테마
  │   ├── localization/             # KO/EN 다국어
  │   ├── logging/
  │   └── utils/                    # ConnectivityService 등
  ├── features/                     # 기능별 모듈
  │   ├── loading/                  # 로딩 화면
  │   ├── home/                     # 테마 선택 화면
  │   ├── stages/                   # 스테이지 목록 화면
  │   ├── stage_play/               # 게임 플레이 화면
  │   ├── result/                   # 결과 화면
  │   ├── ads/                      # AdMob 광고
  │   └── purchase/                 # 인앱결제
  ├── data/                         # 데이터 레이어
  │   ├── supabase/                 # Supabase 연동
  │   │   ├── repositories/
  │   │   └── dto/
  │   └── local/                    # 로컬 캐시
  ├── domain/                       # 도메인 레이어
  │   ├── models/                   # 핵심 모델
  │   ├── repositories/             # 레포지토리 인터페이스
  │   └── usecases/                 # 유즈케이스
  └── presentation/                 # 공통 UI 컴포넌트
      ├── widgets/                  # LoadingWidget, ErrorWidget 등
      └── dialogs/
```

## 주요 기능

### 1. 테마 시스템
- 무료/구매/잠금 상태 관리
- 테마별 스테이지 그룹핑
- 구매 여부 추적

### 2. 스테이지 진행
- 순차 진행 (이전 스테이지 완료 필수)
- 완료 상태 표시
- Editorial 스타일 UI

### 3. 게임 플레이
- A/B 이미지 비교
- 원형 좌표 기반 정답 판정 (x, y, radius)
- 정답 마커 표시 (보라색 glow 효과)
- 오답 피드백 (빨간 점 100ms)
- 뒤로가기 확인 모달
- Progress bar

### 4. 광고 및 수익화
- AdMob 배너 광고
- 리워드 광고 (힌트용)
- 인앱결제 (테마팩, 광고 제거)

### 5. 다국어 지원
- 한국어 (KO)
- 영어 (EN)
- flutter_localizations 기반

## UI/UX 디자인

### LoadingPage
- Editorial 테마
- Volume/Issue 헤더
- 애니메이션 progress bar
- 배경 blur 효과

### HomePage
- Today's Highlight: 큰 카드 (상단)
- More Themes: 가로 스크롤 카드
- Music/Vibration/Settings 버튼

### StageListPage
- 세로 스크롤 큰 카드 레이아웃
- Featured 뱃지
- Locked 상태 표시 (grayscale + overlay)
- Progress 정보

### StagePage
- Cream 배경 (#FFF9F2)
- Progress bar + Zoom/Hint 버튼
- A/B 이미지 세로 배치
- Original / Find the Changes 라벨
- 정답 마커 (보라색 glow)

## 기술 스택

- **Flutter**: 3.38.9
- **상태관리**: Provider (ChangeNotifier)
- **라우팅**: go_router
- **백엔드**: Supabase (Postgres + Storage)
- **광고**: google_mobile_ads
- **결제**: in_app_purchase
- **다국어**: flutter_localizations
- **캐싱**: shared_preferences, path_provider

## 아키텍처

Clean Architecture 기반:
- **Domain**: 비즈니스 로직 (models, repositories 인터페이스, usecases)
- **Data**: 데이터 소스 구현 (Supabase, 로컬 캐시)
- **Presentation**: UI 및 상태 관리 (ViewModel, Widgets)

## 핵심 로직

### 정답 판정 (Answer Model)
```dart
bool isHit(double tapX, double tapY) {
  final dx = tapX - x;
  final dy = tapY - y;
  final distance = dx * dx + dy * dy;
  return distance <= radius * radius;
}
```
- 좌표는 0.0~1.0 비율로 저장
- 실제 픽셀 좌표로 변환하여 원형 영역 hit test

### 순차 진행 (StageListViewModel)
```dart
// 첫 스테이지는 무조건 available
if (stage.stageNumber == 1) {
  status = StageStatus.available;
} else {
  // 이전 스테이지 완료 여부 확인
  final isPreviousCompleted = completedIds.contains(previousStage.id);
  status = isPreviousCompleted ? StageStatus.available : StageStatus.locked;
}
```

### 자동 완료 처리 (StagePage)
```dart
if (viewModel.isCompleted) {
  Future.delayed(const Duration(milliseconds: 500), () {
    context.push('/result', extra: {
      'stage': widget.stage,
      'nextStage': widget.nextStage,
    });
  });
}
```

## 환경 설정

### 1. Flutter 설치
```bash
flutter doctor
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. Supabase 설정
- Supabase 프로젝트 생성
- `lib/data/supabase/supabase_client.dart`에서 URL/anon key 설정

### 4. AdMob 설정
- Android: `android/app/src/main/AndroidManifest.xml`에 App ID 추가
- iOS: `ios/Runner/Info.plist`에 App ID 추가
- 현재는 테스트 ID 사용 중 (production에서 교체 필요)

## 실행

```bash
# 디버그 모드
flutter run

# 릴리즈 모드
flutter run --release
```

## 테스트

```bash
# 모든 테스트 실행
flutter test

# 특정 파일 테스트
flutter test test/features/stage_play/stage_viewmodel_test.dart

# 코드 분석
flutter analyze
```

### 테스트 커버리지
- Domain 모델 (Answer hit detection)
- StageViewModel (정답 판정, 완료 상태)
- 총 16개 테스트 (모두 통과)

## 빌드

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

## 구현 상태

### 완료 ✅
- [x] 프로젝트 스캐폴딩 + 라우팅 + 다국어
- [x] Supabase 연결 + Repository 구조
- [x] 캐시/파일 저장 모듈
- [x] LoadingPage (Editorial 스타일)
- [x] HomePage (Today's Highlight + More Themes)
- [x] StageListPage (세로 스크롤 큰 카드)
- [x] StagePage (Progress bar + Zoom/Hint 버튼)
- [x] ResultPage
- [x] 광고/결제 스켈레톤
- [x] 공통 위젯 (Loading, Error, Empty)

### TODO
- [ ] A/B 이미지 동기화 (핀치 줌, 드래그)
- [ ] 힌트 시스템 (무료 힌트 + 리워드 광고)
- [ ] 실제 IAP 구현
- [ ] 오프라인 모드 (다운로드된 콘텐츠 플레이)
- [ ] 설정 페이지
- [ ] 튜토리얼 모드
- [ ] BGM 재생
- [ ] 화면 회전 대응

## 디자인 참고
- `page_Loading.md`: LoadingPage 디자인
- `page_Home.md`: HomePage 디자인
- `page_Stage.md`: StageListPage 디자인
- `page_game stage.md`: StagePage 디자인

## 라이선스

MIT License

## 참고 문서

- [CLAUDE.md](CLAUDE.md): 구현 규칙 및 원칙
- [PRD.md](PRD.md): 제품 요구사항 정의서
