import 'package:flutter/material.dart';
import '../../domain/model/user-model.dart';

import '../screens/UserDetailScreen.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;

  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String imageUrl =
        'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/ec2fa697-24a3-453e-98aa-9daa19ff5d78/ddogwv9-11d06768-dbbe-446e-bb47-0d0ee3c3a043.jpg/v1/fit/w_828,h_1104,q_70,strp/petrol_station_by_mclelun_ddogwv9-414w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTcwNyIsInBhdGgiOiJcL2ZcL2VjMmZhNjk3LTI0YTMtNDUzZS05OGFhLTlkYWExOWZmNWQ3OFwvZGRvZ3d2OS0xMWQwNjc2OC1kYmJlLTQ0NmUtYmI0Ny0wZDBlZTNjM2EwNDMuanBnIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.n5K7qhfrBry2hnFsyomdSXN8eg_P6k1IsfMLHAARASY';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                UserDetailScreen(imageUrl: imageUrl, user: user),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const beginOffset = Offset(0, 0.1);
              const endOffset = Offset.zero;
              final tween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: Curves.easeInOut));

              final opacityAnimation = animation.drive(Tween<double>(begin: 0.0, end: 1.0));

              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: opacityAnimation,
                  child: child,
                ),
              );
            },
          ),
        );

      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "profile_${user.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.verified, color: Colors.green, size: 16),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),

              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.business, size: 14, color: Colors.grey),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    user.company.name,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add, size: 14, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Follow', style: TextStyle(fontSize: 12, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
