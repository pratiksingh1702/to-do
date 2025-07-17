import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/src/features/auth/presentation/provider/authProvider.dart';
import 'package:todo_app/src/features/auth/presentation/screens/login.dart';
import 'package:todo_app/src/features/user/presentation/screens/homePageUserList.dart';
import 'src/common/theme/app_theme.dart';
import 'src/common/providers/theme_provider.dart';
import 'src/features/todo/domain/models/todo.dart';
import 'src/features/todo/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TodoAdapter());
  // Hive.registerAdapter(TaskGroupTypeAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<bool>('settings');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: authState.when(
        data: (user) => user == null ? const AuthPage() : const HomeScreen(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Something went wrong')),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
