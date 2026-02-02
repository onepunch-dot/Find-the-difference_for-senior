import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/device_utils.dart';
import 'stage_list_page.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final SupabaseService _supabaseService = SupabaseService();
  List<GameTheme> _themes = [];
  Set<int> _purchasedThemeIds = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // 테마 목록 가져오기
      final themes = await _supabaseService.fetchThemes();

      // 구매 이력 가져오기
      final deviceId = await DeviceUtils.getDeviceId();
      final purchases = await _supabaseService.fetchPurchases(deviceId);
      final purchasedIds = purchases.map((p) => p.themeId).toSet();

      setState(() {
        _themes = themes;
        _purchasedThemeIds = purchasedIds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool _isThemeAccessible(GameTheme theme) {
    return !theme.isPaid || _purchasedThemeIds.contains(theme.id);
  }

  void _onThemeTap(GameTheme theme) {
    if (_isThemeAccessible(theme)) {
      // 테마 접근 가능 - 스테이지 목록으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StageListPage(theme: theme),
        ),
      );
    } else {
      // 유료 테마 - 구매 화면 또는 안내
      _showPurchaseDialog(theme);
    }
  }

  void _showPurchaseDialog(GameTheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '테마 구매',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          '이 테마는 유료 콘텐츠입니다.\n구매하시겠습니까?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 실제 결제 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('결제 기능은 준비 중입니다')),
              );
            },
            child: const Text('구매하기', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 선택'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            '오류가 발생했습니다',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadThemes,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _themes.isEmpty
                    ? Center(
                        child: Text(
                          '등록된 테마가 없습니다',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _themes.length,
                        itemBuilder: (context, index) {
                          final theme = _themes[index];
                          final isAccessible = _isThemeAccessible(theme);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            child: InkWell(
                              onTap: () => _onThemeTap(theme),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    // 테마 아이콘/썸네일
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isAccessible
                                            ? Icons.landscape
                                            : Icons.lock,
                                        size: 40,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // 테마 정보
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            theme.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            theme.isPaid
                                                ? (isAccessible
                                                    ? '구매 완료'
                                                    : '유료 테마')
                                                : '무료 테마',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: theme.isPaid
                                                      ? (isAccessible
                                                          ? Colors.green
                                                          : Colors.orange)
                                                      : Colors.blue,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 화살표
                                    const Icon(Icons.chevron_right, size: 32),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
