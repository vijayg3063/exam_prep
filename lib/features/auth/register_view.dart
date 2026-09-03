import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/repositories/auth_repository.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authNotifierProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) {
        context.go('/exam-onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/login'),
        ),
        title: const Text('Create Student Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join Pariksha Prep 🚀',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Prepare for UPSC, SSC, Banking, Rajasthan Exams with top educators.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter your name';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Email Address',
                  hint: 'name@example.com',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || !val.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Mobile Number',
                  hint: '+91 98765 43210',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.length < 10) return 'Enter a 10-digit mobile number';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Password',
                  hint: 'Create strong password',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (val) {
                    if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Continue to Preference',
                  isLoading: isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
