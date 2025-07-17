import 'package:flutter/material.dart';
import 'package:todo_app/src/features/user/domain/model/user-model.dart';

class PostCard extends StatelessWidget {
  final UserModel user;
  const PostCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/45.jpg'),
                radius: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Colors.teal, size: 16),
                      ],
                    ),
                    Text(
                      'Posted 3m ago',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[600]),
            ],
          ),

          const SizedBox(height: 16),

          // Post Content
          Text(
            "I’ve been struggling with severe headaches for years, but recently I’ve found some relief with thanks to Doc Nightingale AI.! 🎉🙌",
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            '#goodbyeheadache  #nightingalerocks',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.teal),
          ),

          const SizedBox(height: 16),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1573497491208-6b1acb260507',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.fullscreen, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bottom Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _iconWithText(Icons.remove_red_eye, '5,874', Colors.grey),
                  const SizedBox(width: 12),
                  _iconWithText(Icons.favorite, '215', Colors.red),
                  const SizedBox(width: 12),
                  _iconWithText(Icons.chat_bubble_outline, '11', Colors.green),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.bookmark_outline, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('Save', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconWithText(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
