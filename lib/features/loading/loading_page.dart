import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/initialize_app_usecase.dart';
import '../../data/supabase/repositories/theme_repository_impl.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String _statusMessage = '로딩 중...';
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _statusMessage = '앱을 준비하고 있습니다...';
      _hasError = false;
    });

    // 짧은 지연 (스플래시 효과)
    await Future.delayed(const Duration(milliseconds: 500));

    // 초기화 실행
    final useCase = InitializeAppUseCase(ThemeRepositoryImpl());
    final result = await useCase.execute();

    if (!mounted) return;

    if (result.isSuccess) {
      // 성공: Home으로 이동
      context.go('/home');
    } else {
      // 실패: 에러 표시
      setState(() {
        _hasError = true;
        _errorMessage = result.errorMessage;
        _statusMessage = '오류 발생';
      });
    }
  }

  void _retry() {
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 앱 타이틀
              const Text(
                '틀린그림찾기',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6400f0),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 80),

              // 로딩 스피너 또는 에러 아이콘
              if (_hasError)
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                )
              else
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6400f0)),
                  ),
                ),

              const SizedBox(height: 32),

              // 상태 메시지
              Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              if (_hasError && _errorMessage != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6400f0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('다시 시도'),
                ),
              ],

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
