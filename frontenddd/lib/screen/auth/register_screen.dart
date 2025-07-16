import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await _authService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _passwordConfirmationController.text,
        );

        if (response.statusCode == 201 && mounted) {
          NotificationService.showSuccessNotification(
              context, 'Registrasi berhasil! Silakan login.');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          NotificationService.showErrorNotification(context, e.toString());
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
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildRegisterForm(),
                const SizedBox(height: 24),
                _buildLoginRedirect(context),
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
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(height: 16),
        Text(
          'Buat Akun Baru',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Isi data di bawah untuk memulai.',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder()),
            validator: (value) =>
                value!.isEmpty ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
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
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (value) =>
                value!.length < 8 ? 'Password minimal 8 karakter' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordConfirmationController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() =>
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
            ),
            validator: (value) => value != _passwordController.text
                ? 'Password tidak cocok'
                : null,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Daftar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sudah punya akun?"),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Login di sini'),
        ),
      ],
    );
  }
}
