# 틀린그림찾기 (Spot the Difference)

시니어를 위한 스트레스 프리 틀린그림찾기 모바일 게임

Flutter + Supabase로 제작된 Android/iOS 크로스플랫폼 게임입니다.

## 주요 기능

- 🎯 테마별 스테이지 구조 (서울, 부산, 도쿄 등)
- 🔍 이미지 확대/축소 및 A/B 동기화
- 💡 힌트 시스템 (광고 기반)
- 🎵 테마별 BGM
- 🛒 테마팩 인앱 구매
- 👴 시니어 UX (큰 버튼, 타이머/하트 OFF)

## 프로젝트 설정

### 1. 저장소 클론

```bash
git clone https://github.com/onepunch-dot/find_difference_app.git
cd find_difference_app
```

### 2. Flutter 패키지 설치

```bash
flutter pub get
```

### 3. Supabase 설정

**중요**: Supabase 설정 파일을 생성해야 합니다.

```bash
# 템플릿 파일을 복사
cp lib/constants/supabase_config.dart.example lib/constants/supabase_config.dart
```

`lib/constants/supabase_config.dart` 파일을 열고 Supabase 정보를 입력:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabasePublishableKey = 'your-publishable-key';
}
```

### 4. 앱 실행

```bash
# 웹으로 실행 (가장 빠름)
flutter run -d chrome

# Android 에뮬레이터로 실행
flutter run -d android

# iOS 시뮬레이터로 실행
flutter run -d ios
```

## 기술 스택

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase
  - Database (PostgreSQL)
  - Storage (이미지, BGM)
- **패키지**:
  - supabase_flutter
  - cached_network_image
  - path_provider
  - shared_preferences
  - vibration
  - audioplayers

## 프로젝트 구조

```
lib/
├── constants/       # 설정 파일
├── models/          # 데이터 모델 (Theme, Stage, Answer, Purchase)
├── screens/         # 화면 (Home, Theme, StageList, Stage, Result)
├── services/        # 서비스 (Supabase, Audio, Cache)
├── utils/           # 유틸리티
└── widgets/         # 재사용 가능한 위젯
```

## 다른 컴퓨터에서 작업 이어하기

1. GitHub에서 최신 코드 pull
2. `supabase_config.dart` 파일 생성 (위의 설정 참고)
3. `flutter pub get` 실행
4. 앱 실행

## 개발 가이드

### Supabase 데이터베이스

- `themes`: 테마 정보
- `stages`: 스테이지 정보 (이미지 경로, 정답 좌표)
- `purchases`: 구매 이력

### Storage 버킷

- `stage-images`: 스테이지 이미지 (A/B)
- `theme-audio`: 테마 BGM

## 라이선스

Private Project
