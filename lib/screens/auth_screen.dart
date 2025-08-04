import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../utils/app_helpers.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Login Controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Register Controllers
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _isLoginPasswordVisible = false;
  bool _isRegisterPasswordVisible = false;
  bool _isRegisterConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan logo dan welcome text
              _buildHeader(),

              // Tab Bar
              _buildTabBar(),

              // Tab View Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildLoginTab(), _buildRegisterTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment_turned_in,
              color: Colors.white,
              size: AppSizes.iconXL,
            ),
          ).animate().scale(delay: 100.ms),

          const SizedBox(height: 20),

          // Welcome Text
          Text(
            'Selamat Datang!',
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

          const SizedBox(height: 8),

          Text(
            'Solusi terpercaya untuk kebutuhan tugas Anda',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: AppColors.secondaryGradient,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF718096),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        tabs: const [Tab(text: 'Masuk'), Tab(text: 'Daftar')],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Email Field
            _buildInputField(
              controller: _loginEmailController,
              label: 'Email',
              icon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!AppHelpers.isValidEmail(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password Field
            _buildInputField(
              controller: _loginPasswordController,
              label: 'Password',
              icon: FontAwesomeIcons.lock,
              isPassword: true,
              isPasswordVisible: _isLoginPasswordVisible,
              onTogglePassword: () {
                setState(() {
                  _isLoginPasswordVisible = !_isLoginPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (!AppHelpers.isValidPassword(value)) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Login Button
            _buildGradientButton(
              text: 'Masuk',
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  AppHelpers.showLoadingDialog(context, message: 'Masuk...');

                  final user = await AuthService.login(
                    _loginEmailController.text,
                    _loginPasswordController.text,
                  );

                  if (mounted) {
                    AppHelpers.hideLoadingDialog(context);

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      AppHelpers.showSuccess(context, 'Login berhasil!');
                    } else {
                      AppHelpers.showError(
                        context,
                        'Email atau password salah!',
                      );
                    }
                  }
                }
              },
            ),

            const SizedBox(height: 16),

            // Forgot Password Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Color(0xFF6B73FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Social Login Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Atau masuk dengan',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // Social Login Buttons
            Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    label: 'Google',
                    color: AppColors.google,
                    onPressed: () async {
                      AppHelpers.showLoadingDialog(
                        context,
                        message: 'Masuk dengan Google...',
                      );

                      final user = await AuthService.loginWithGoogle();

                      if (mounted) {
                        AppHelpers.hideLoadingDialog(context);

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                          AppHelpers.showSuccess(
                            context,
                            'Login dengan Google berhasil!',
                          );
                        } else {
                          AppHelpers.showError(
                            context,
                            'Login dengan Google gagal!',
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSocialButton(
                    icon: FontAwesomeIcons.facebook,
                    label: 'Facebook',
                    color: AppColors.facebook,
                    onPressed: () async {
                      AppHelpers.showLoadingDialog(
                        context,
                        message: 'Masuk dengan Facebook...',
                      );

                      final user = await AuthService.loginWithFacebook();

                      if (mounted) {
                        AppHelpers.hideLoadingDialog(context);

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                          AppHelpers.showSuccess(
                            context,
                            'Login dengan Facebook berhasil!',
                          );
                        } else {
                          AppHelpers.showError(
                            context,
                            'Login dengan Facebook gagal!',
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Name Field
            _buildInputField(
              controller: _registerNameController,
              label: 'Nama Lengkap',
              icon: FontAwesomeIcons.user,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                if (value.length < 2) {
                  return 'Nama minimal 2 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email Field
            _buildInputField(
              controller: _registerEmailController,
              label: 'Email',
              icon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!AppHelpers.isValidEmail(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password Field
            _buildInputField(
              controller: _registerPasswordController,
              label: 'Password',
              icon: FontAwesomeIcons.lock,
              isPassword: true,
              isPasswordVisible: _isRegisterPasswordVisible,
              onTogglePassword: () {
                setState(() {
                  _isRegisterPasswordVisible = !_isRegisterPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (!AppHelpers.isValidPassword(value)) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Confirm Password Field
            _buildInputField(
              controller: _registerConfirmPasswordController,
              label: 'Konfirmasi Password',
              icon: FontAwesomeIcons.lock,
              isPassword: true,
              isPasswordVisible: _isRegisterConfirmPasswordVisible,
              onTogglePassword: () {
                setState(() {
                  _isRegisterConfirmPasswordVisible =
                      !_isRegisterConfirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                if (value != _registerPasswordController.text) {
                  return 'Password tidak sama';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Terms and Conditions
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dengan mendaftar, Anda menyetujui Syarat & Ketentuan kami',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Register Button
            _buildGradientButton(
              text: 'Daftar',
              onPressed: () async {
                if (_registerFormKey.currentState!.validate()) {
                  AppHelpers.showLoadingDialog(
                    context,
                    message: 'Mendaftar...',
                  );

                  final user = await AuthService.register(
                    name: _registerNameController.text,
                    email: _registerEmailController.text,
                    password: _registerPasswordController.text,
                  );

                  if (mounted) {
                    AppHelpers.hideLoadingDialog(context);

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      AppHelpers.showSuccess(context, 'Registrasi berhasil!');
                    } else {
                      AppHelpers.showError(context, 'Registrasi gagal!');
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !isPasswordVisible,
      validator: validator,
      decoration: AppDecorations.inputDecoration(
        label: label,
        icon: icon,
        suffixIcon:
            isPassword
                ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: FaIcon(
                      isPasswordVisible
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      color: Colors.grey.shade400,
                      size: 18,
                    ),
                    onPressed: onTogglePassword,
                    padding: const EdgeInsets.all(8.0),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: AppSizes.inputL,
      decoration: AppDecorations.gradientButtonDecoration,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        child: Text(text, style: AppTextStyles.buttonLarge),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: AppDecorations.socialButtonDecoration,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        icon: FaIcon(icon, color: color, size: 18),
        label: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
