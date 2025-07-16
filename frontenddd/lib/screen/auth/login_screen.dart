import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontenddd/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import '../../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await _authService.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (response.statusCode == 200) {
          final token = response.data['access_token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          NotificationService.showErrorNotification(
            context,
            e.toString(),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimationLimiter(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildLoginForm(),
                const SizedBox(height: 24),
                // _buildSocialLoginDivider(),
                const SizedBox(height: 24),
                // _buildSocialLoginButtons(),
                const SizedBox(height: 32),
                _buildRegisterRedirect(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.shopping_cart_checkout_rounded,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          'Selamat Datang Kembali!',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Login untuk melanjutkan belanja.',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Email tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Password tidak boleh kosong' : null,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSocialLoginDivider() {
  //   return const Row(
  //     children: [
  //       Expanded(child: Divider()),
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 12.0),
  //         child: Text('Atau lanjutkan dengan',
  //             style: TextStyle(color: Colors.grey)),
  //       ),
  //       Expanded(child: Divider()),
  //     ],
  //   );
  // }

  // Widget _buildSocialLoginButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         onPressed: () {},
  //         icon: Image.asset('assets/images/google_logo.png', height: 32),
  //         style: IconButton.styleFrom(
  //             side: BorderSide(color: Colors.grey.shade300),
  //             padding: const EdgeInsets.all(16)),
  //       ),
  //       const SizedBox(width: 24),
  //       IconButton(
  //         onPressed: () {},
  //         icon: Image.asset('assets/images/facebook_logo.png', height: 32),
  //         style: IconButton.styleFrom(
  //             side: BorderSide(color: Colors.grey.shade300),
  //             padding: const EdgeInsets.all(16)),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRegisterRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Belum punya akun?"),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RegisterScreen()));
          },
          child: const Text('Daftar di sini'),
        ),
      ],
    );
  }
}
