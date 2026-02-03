import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/initialize_app_usecase.dart';
import '../../data/supabase/repositories/theme_repository_impl.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  String _statusMessage = '로딩 중...';
  bool _hasError = false;
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() {
      _statusMessage = '로딩 중...';
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final useCase = InitializeAppUseCase(ThemeRepositoryImpl());
    final result = await useCase.execute();

    if (!mounted) return;

    if (result.isSuccess) {
      context.go('/home');
    } else {
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
      backgroundColor: const Color(0xFFF2F2F7),
      body: Stack(
        children: [
          // Background blur effects
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  _buildMainTitle(),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Column(
              children: [
                Text(
                  'VOLUME 01',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ISSUE NO. 01',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainTitle() {
    if (_hasError) {
      return Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ],
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D1D6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  '틀린그림찾기',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Curated visual experiences\nfor the curious mind.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    if (_hasError) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Column(
              children: [
                SizedBox(
                  width: 192,
                  child: Stack(
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D1D6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: FractionallySizedBox(
                              widthFactor: 0.33,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _statusMessage.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF999999),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      size: 20,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
