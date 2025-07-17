import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../service/authService.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my To_DO 😊',
          style: TextStyle(fontWeight: FontWeight.bold,color: theme.colorScheme.surface),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.surface,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),


        ],
      ),
      backgroundColor: theme.colorScheme.inversePrimary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: [
                   const SizedBox(height: 24),
                   Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Go ahead and set up\nyour account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.surface

                      ),
                    ),
                                 ),
                   const SizedBox(height: 8),
                   Align(
                     alignment: Alignment.centerLeft,
                     child: Text(
                       'Sign in-up to enjoy the best managing experience',
                       style: theme.textTheme.bodyMedium?.copyWith(
                           color: theme.colorScheme.surface
                       ),
                     ),
                   ),
                 ],
               ),
             ),

            const SizedBox(height: 24),

            // White Card
            Container(

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                ),

              ),
              child: Column(
                children: [
                  // Login/Register Switch
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _buildTabButton('Login', true),
                        _buildTabButton('Register', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  _buildInputField(
                    controller: _emailController,
                    hint: 'Email Address',
                    icon: Icons.mail_outline,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _buildInputField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Remember + Forgot
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) => setState(() => rememberMe = value!),
                        activeColor: Colors.green,
                      ),
                      const Text('Remember me', style: TextStyle(fontSize: 14)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Login/Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (isLogin) {
                            await authService.signIn(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          } else {
                            await authService.signUp(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isLogin ? 'Login' : 'Register',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Or login with
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Or login with', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Social buttons
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isForLogin) {
    final selected = isLogin == isForLogin;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = isForLogin),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
        )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
//
//   Widget _buildSocialButton(String label, String assetPath) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           Image.asset(assetPath, height: 20, width: 20),
//           const SizedBox(width: 10),
//           Text(label, style: const TextStyle(color: Colors.black)),
//         ],
//       ),
//     );
//   }
}
