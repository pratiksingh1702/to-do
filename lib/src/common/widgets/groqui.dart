import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/todo/presentation/providers/todo_provider.dart';
import 'groq.dart';

class TaskSummaryScreen extends ConsumerStatefulWidget {
  const TaskSummaryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskSummaryScreen> createState() => _TaskSummaryScreenState();
}

class _TaskSummaryScreenState extends ConsumerState<TaskSummaryScreen> with SingleTickerProviderStateMixin {
  String _summaryText = '';
  bool _isLoading = false;
  bool _showResult = false;
  String _animatedText = '';

  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  Future<void> _summarizeTasks() async {
    setState(() {
      _isLoading = true;
      _showResult = false;
      _summaryText = '';
      _animatedText = '';
    });

    _controller.stop();
    _controller.reset();

    final todos = ref.read(todoProvider.notifier).getTodosByDate(DateTime.now());
    final groqService = GroqService();
    final summary = await groqService.summarizeTodos(todos);
    print(summary);

    setState(() {
      _summaryText = summary ?? 'Failed to get summary.';
      _isLoading = false;
      _showResult = true;
    });

    _startTypewriterAnimation();
  }

  void _startTypewriterAnimation() {
    _controller.duration = Duration(milliseconds: 30 * _summaryText.length);
    _animation = StepTween(begin: 0, end: _summaryText.length).animate(_controller)
      ..addListener(() {
        setState(() {
          final characters = _summaryText.characters;
          _animatedText = characters.take(_animation.value).toString();
          ;
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Hello I am PIXI ✨'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _showResult
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology_alt_outlined, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 16),
              Text(
                "Here’s your summarized tasks!",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _animatedText,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _summarizeTasks,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Summarize Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.task, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 24),
              Text(
                'AI Task Summarizer',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Click below to let AI summarize your day’s tasks into simple words!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _summarizeTasks,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Summarize My Tasks'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
