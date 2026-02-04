import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/supabase/supabase_client.dart';
import '../audio/bgm_service.dart';
import '../purchase/iap_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _musicEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: '사운드 & 진동',
            children: [
              _buildSwitchTile(
                icon: Icons.volume_up,
                title: '효과음',
                subtitle: '게임 효과음 활성화',
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                  _saveSetting('sound_enabled', value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.music_note,
                title: 'BGM',
                subtitle: '배경 음악 활성화',
                value: _musicEnabled,
                onChanged: (value) async {
                  setState(() => _musicEnabled = value);
                  await _saveSetting('music_enabled', value);
                  await BGMService().setEnabled(value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.vibration,
                title: '진동',
                subtitle: '햅틱 피드백 활성화',
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() => _vibrationEnabled = value);
                  _saveSetting('vibration_enabled', value);
                },
              ),
            ],
          ),
          _buildSection(
            title: '정보',
            children: [
              _buildTile(
                icon: Icons.info_outline,
                title: '앱 버전',
                subtitle: '1.0.0',
                onTap: null,
              ),
            ],
          ),
          _buildSection(
            title: '지원',
            children: [
              _buildTile(
                icon: Icons.help_outline,
                title: '도움말',
                subtitle: '사용 방법 및 FAQ',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('도움말 페이지 구현 예정')),
                  );
                },
              ),
              _buildTile(
                icon: Icons.email_outlined,
                title: '문의하기',
                subtitle: '개발자에게 문의',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('문의 기능 구현 예정')),
                  );
                },
              ),
              _buildTile(
                icon: Icons.rate_review_outlined,
                title: '앱 평가',
                subtitle: '스토어에서 평가하기',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('앱 평가 기능 구현 예정')),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            title: '구매',
            children: [
              _buildTile(
                icon: Icons.restore,
                title: '구매 복원',
                subtitle: '이전 구매 내역 복원',
                onTap: _showRestorePurchaseDialog,
                textColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF6200EE).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF6200EE), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF6200EE),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? const Color(0xFF6200EE)).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: textColor ?? const Color(0xFF6200EE),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: textColor ?? Colors.grey,
            )
          : null,
      onTap: onTap,
    );
  }

  Future<void> _showRestorePurchaseDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('구매 복원'),
        content: const Text(
          '이전에 구매한 항목을 복원합니다.\n스토어 계정의 구매 내역을 확인합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('복원'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // 진짜 IAP 구매 복원 (Apple/Google 스토어에서)
      try {
        final restoredProducts = await IAPService().restorePurchases();

        if (mounted) {
          Navigator.of(context).pop(); // 로딩 닫기

          if (restoredProducts.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('복원할 구매 내역이 없습니다'),
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${restoredProducts.length}개 항목을 복원했습니다'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop(); // 로딩 닫기
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('복원 실패: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
