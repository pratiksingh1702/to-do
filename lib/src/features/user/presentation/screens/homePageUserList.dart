import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/userProvider.dart';
import '../widgets/onNoConnection.dart';
import '../widgets/userCardHomeScreen.dart';
import '../widgets/userPost.dart';

class HomeScreenUser extends ConsumerWidget {
  const HomeScreenUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      body: usersAsync.when(
        data: (users) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ProfileCard(user: user);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Latest Posts',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: PostCard(user: user),
                  );
                },
                childCount: users.length, // Or any dynamic count
              ),
            ),


          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>  NoInternetScreen(onRetry: () => ref.refresh(userProvider),),

      ),
    );
  }
}
