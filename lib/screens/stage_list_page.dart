import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'stage_page.dart';

class StageListPage extends StatefulWidget {
  final GameTheme theme;

  const StageListPage({
    super.key,
    required this.theme,
  });

  @override
  State<StageListPage> createState() => _StageListPageState();
}

class _StageListPageState extends State<StageListPage> {
  final SupabaseService _supabaseService = SupabaseService();
  final AudioService _audioService = AudioService();
  List<Stage> _stages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStages();
    _playThemeBgm();
  }

  @override
  void dispose() {
    // BGM은 계속 재생 (Stage 페이지에서도 사용)
    super.dispose();
  }

  Future<void> _loadStages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stages = await _supabaseService.fetchStagesByTheme(widget.theme.id);

      setState(() {
        _stages = stages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _playThemeBgm() async {
    if (widget.theme.bgmPath != null && widget.theme.bgmPath!.isNotEmpty) {
      await _audioService.playThemeBgm(
        widget.theme.title,
        bgmPath: widget.theme.bgmPath!,
        version: widget.theme.bgmVersion,
      );
    }
  }

  void _onStageTap(Stage stage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StagePage(
          stage: stage,
          theme: widget.theme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theme.title),
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
                            onPressed: _loadStages,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _stages.isEmpty
                    ? Center(
                        child: Text(
                          '등록된 스테이지가 없습니다',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _stages.length,
                        itemBuilder: (context, index) {
                          final stage = _stages[index];

                          return Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () => _onStageTap(stage),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 스테이지 번호
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // 스테이지 제목
                                    Text(
                                      stage.title,
                                      style:
                                          Theme.of(context).textTheme.titleLarge,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),

                                    // 틀린 부분 개수
                                    Text(
                                      '틀린 곳 ${stage.totalAnswers}개',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
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
