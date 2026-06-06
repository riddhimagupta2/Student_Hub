import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/colours.dart';
import '../../../app/theme/text_style.dart';
import '../controller/auth_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildLogo(),
                  const SizedBox(height: 32),
                  _buildTabBar(),
                  const SizedBox(height: 28),
                  Builder(
                    builder: (ctx) {
                      final tab = DefaultTabController.of(ctx);
                      return AnimatedBuilder(
                        animation: tab,
                        builder: (_, __) =>
                        tab.index == 0 ? _LoginForm(c: controller) : _RegisterForm(c: controller),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('🎓', style: TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student Hub', style: AppTextStyles.h2),
            Text('Your campus community',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        tabs: const [
          Tab(text: 'Sign In'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final AuthController c;
  const _LoginForm({required this.c});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: c.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back! 👋', style: AppTextStyles.h1),
          const SizedBox(height: 6),
          Text('Sign in to your account', style: AppTextStyles.bodySmall),
          const SizedBox(height: 28),

          CustomTextField(
            controller: c.loginEmailCtrl,
            label: 'Email Address',
            hint: 'you@university.edu',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: c.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          Obx(() => CustomTextField(
            controller: c.loginPasswordCtrl,
            label: 'Password',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: c.loginObscure.value,
            validator: c.validatePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => c.login(),
            suffixWidget: GestureDetector(
              onTap: c.toggleLoginObscure,
              child: Icon(
                c.loginObscure.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ),
          )),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text('Forgot Password?',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 8),

          Obx(() => CustomButton(
            label: 'Sign In',
            onTap: c.login,
            isLoading: c.isLoginLoading.value,
            icon: Icons.arrow_forward_rounded,
          )),

          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleBtn(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or continue with',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
      ),
      const Expanded(child: Divider()),
    ]);
  }

  Widget _buildGoogleBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('G', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4285F4))),
            const SizedBox(width: 10),
            Text('Sign in with Google',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final AuthController c;
  const _RegisterForm({required this.c});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: c.registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create Account 🎓', style: AppTextStyles.h1),
          const SizedBox(height: 6),
          Text('Join the student community', style: AppTextStyles.bodySmall),
          const SizedBox(height: 28),

          CustomTextField(
            controller: c.regNameCtrl,
            label: 'Full Name',
            hint: 'Your full name',
            prefixIcon: Icons.person_outline_rounded,
            validator: c.validateName,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: c.regEmailCtrl,
            label: 'Email Address',
            hint: 'you@university.edu',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: c.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          Obx(() => CustomTextField(
            controller: c.regPasswordCtrl,
            label: 'Password',
            hint: 'Min. 6 characters',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: c.regObscure.value,
            validator: c.validatePassword,
            textInputAction: TextInputAction.next,
            suffixWidget: GestureDetector(
              onTap: c.toggleRegObscure,
              child: Icon(
                c.regObscure.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20, color: AppColors.textTertiary,
              ),
            ),
          )),
          const SizedBox(height: 16),

          Obx(() => CustomTextField(
            controller: c.regConfirmCtrl,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: c.regConfirmObscure.value,
            validator: c.validateConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => c.register(),
            suffixWidget: GestureDetector(
              onTap: c.toggleConfirmObscure,
              child: Icon(
                c.regConfirmObscure.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20, color: AppColors.textTertiary,
              ),
            ),
          )),
          const SizedBox(height: 24),

          Obx(() => CustomButton(
            label: 'Create Account',
            onTap: c.register,
            isLoading: c.isRegisterLoading.value,
            icon: Icons.arrow_forward_rounded,
          )),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}