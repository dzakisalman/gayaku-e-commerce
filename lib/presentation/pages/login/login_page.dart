import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gayaku/core/routes/app_pages.dart';
import 'package:gayaku/core/theme/app_colors.dart';
import 'package:gayaku/core/theme/app_text_styles.dart';
import 'package:gayaku/presentation/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildEmailField(controller),
                const SizedBox(height: 16),
                _buildPasswordField(controller),
                const SizedBox(height: 24),
                _buildLoginButton(controller),
                const SizedBox(height: 16),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(LoginController controller) {
    return GetBuilder<LoginController>(
      builder: (_) => TextFormField(
        onChanged: controller.updateEmail,
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPasswordField(LoginController controller) {
    return GetBuilder<LoginController>(
      builder: (_) => TextFormField(
        onChanged: controller.updatePassword,
        decoration: const InputDecoration(
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return GetBuilder<LoginController>(
      builder: (_) => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: controller.isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : Text(
                'Sign In',
                style: AppTextStyles.button,
              ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTextStyles.body2,
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.REGISTER),
          child: Text(
            'Sign Up',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} 