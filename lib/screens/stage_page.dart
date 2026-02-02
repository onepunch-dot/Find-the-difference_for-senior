import 'package:flutter/material.dart';
import '../models/models.dart';

class StagePage extends StatefulWidget {
  final Stage stage;
  final GameTheme theme;

  const StagePage({
    super.key,
    required this.stage,
    required this.theme,
  });

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  int _foundCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 32,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 진행률
            Text(
              '$_foundCount/${widget.stage.totalAnswers}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 16),

            // 확대 초기화 버튼
            IconButton(
              icon: const Icon(Icons.zoom_out_map),
              iconSize: 28,
              onPressed: () {
                // TODO: 확대/위치 초기화
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('확대/위치 초기화')),
                );
              },
            ),

            // 힌트 버튼
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              iconSize: 28,
              onPressed: () {
                // TODO: 힌트 표시 (광고)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('힌트 기능 (광고 보기)')),
                );
              },
            ),
          ],
        ),
        actions: const [
          SizedBox(width: 56), // 중앙 정렬을 위한 공간
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.stage.title,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // TODO: A/B 이미지 표시 및 인터랙션
                Expanded(
                  child: Column(
                    children: [
                      // 이미지 A
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('이미지 A\n(구현 예정)'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 이미지 B
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('이미지 B\n(구현 예정)'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 임시 테스트 버튼
                    setState(() {
                      _foundCount++;
                    });
                    if (_foundCount >= widget.stage.totalAnswers) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('클리어!')),
                      );
                    }
                  },
                  child: const Text('정답 찾기 (테스트)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
