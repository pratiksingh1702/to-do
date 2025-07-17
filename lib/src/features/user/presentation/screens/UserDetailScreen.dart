import 'package:flutter/material.dart';
import '../../domain/model/user-model.dart';

class UserDetailScreen extends StatelessWidget {
  final String imageUrl;
  final UserModel user;

  const UserDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: "profile_${user.id}",
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user.company.name,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                        const Spacer(),
                        Icon(Icons.email_outlined, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Icon(Icons.phone, color: Colors.grey[600]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle(theme, 'About'),
                    const SizedBox(height: 8),
                    Text(
                      user.company.catchPhrase,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle(theme, 'Contact Details'),
                    const SizedBox(height: 8),
                    _buildUserInfoRow(Icons.email, user.email),
                    _buildUserInfoRow(Icons.phone, user.phone),
                    _buildUserInfoRow(Icons.language, user.website),
                    const SizedBox(height: 20),
                    _buildSectionTitle(theme, 'Address'),
                    const SizedBox(height: 8),
                    Text(
                      '${user.address.street}, ${user.address.suite},\n${user.address.city}, ${user.address.zipcode}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle(theme, 'Interests'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ['Design', 'Travel', 'Photography', 'Art', 'Creativity']
                          .map((e) => Chip(label: Text(e), backgroundColor: theme.colorScheme.surface))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Follow Now'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle(theme, 'Description'),
                    const SizedBox(height: 10),
                    Text(
                      'I love collaborating with creative teams and helping others bring their visions to life. '
                          'My work revolves around building delightful experiences through thoughtful design.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle(theme, 'What They Say About Us'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '"Their work is absolutely incredible. Highly recommended for any creative project!"',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        '😊 Happy user since 2022',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 16),
          const SizedBox(width: 10),
          Flexible(child: Text(info)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
