import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/domain/usecases/initialize_app_usecase.dart';
import 'package:find_difference_app/domain/repositories/theme_repository.dart';
import 'package:find_difference_app/domain/models/theme.dart';

// Mock ThemeRepository
class MockThemeRepository implements ThemeRepository {
  final List<Theme> _themes;
  final bool shouldFail;

  MockThemeRepository({
    List<Theme>? themes,
    this.shouldFail = false,
  }) : _themes = themes ?? [];

  @override
  Future<List<Theme>> getAllThemes() async {
    if (shouldFail) {
      throw Exception('Network error');
    }
    return _themes;
  }

  @override
  Future<Theme?> getThemeById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getPurchasedThemeIds(String userId) async {
    throw UnimplementedError();
  }
}

void main() {
  group('InitializeAppUseCase', () {
    test('returns success when themes are available', () async {
      // Arrange
      final mockThemes = [
        Theme(
          id: '1',
          name: '테마1',
          nameEn: 'Theme1',
          description: '설명',
          descriptionEn: 'Description',
          isFree: true,
          bgmVersion: 1,
          order: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      final repository = MockThemeRepository(themes: mockThemes);
      final useCase = InitializeAppUseCase(repository, skipAuth: true);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, true);
      expect(result.errorMessage, null);
    });

    test('returns failure when no themes are available', () async {
      // Arrange
      final repository = MockThemeRepository(themes: []);
      final useCase = InitializeAppUseCase(repository, skipAuth: true);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, false);
      expect(result.errorMessage, isNotNull);
      expect(result.errorMessage, contains('콘텐츠를 불러올 수 없습니다'));
    });

    test('returns failure when network error occurs', () async {
      // Arrange
      final repository = MockThemeRepository(shouldFail: true);
      final useCase = InitializeAppUseCase(repository, skipAuth: true);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, false);
      expect(result.errorMessage, isNotNull);
      expect(result.errorMessage, contains('오류가 발생했습니다'));
    });
  });
}
