import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/Screens/Dashboard/dashboard_screen.dart';
import 'package:lecture/appcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(BuildContext context,
      {required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppConstant.textHint(context)),
      prefixIcon: Icon(icon, color: const Color(0xFF22D3EE)),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppConstant.inputBg(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstant.border(context))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 2)),
    );
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;
    return Scaffold(
      backgroundColor: AppConstant.scaffoldBg(context),
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        backgroundColor: AppConstant.primarycolor,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32 : 20, vertical: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 56),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 8,
                  color: AppConstant.cardBg(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 36 : 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                                child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF093046),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(Icons.lock_outline,
                                        color: Color(0xFF22D3EE), size: 38))),
                            const SizedBox(height: 20),
                            Text('Welcome Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant.textPrimary(context))),
                            const SizedBox(height: 8),
                            Text('Sign in to the Magnitude Admin Portal',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppConstant.textHint(context))),
                            const SizedBox(height: 30),
                            Text('Email Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppConstant.textPrimary(context))),
                            const SizedBox(height: 8),
                            TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: _fieldDecoration(context,
                                    hint: 'admin@company.com',
                                    icon: Icons.email_outlined),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                          .hasMatch(email)
                                      ? null
                                      : 'Enter a valid email address';
                                }),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Password',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppConstant.textPrimary(
                                              context))),
                                  TextButton(
                                      onPressed: () => ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Password reset will be available soon.'))),
                                      child: const Text('Forgot Password?'))
                                ]),
                            const SizedBox(height: 2),
                            TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _signIn(),
                                decoration: _fieldDecoration(context,
                                    hint: 'Enter your password',
                                    icon: Icons.lock_outline,
                                    suffix: IconButton(
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                        icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppConstant.textHint(
                                                context)))),
                                validator: (value) =>
                                    (value?.isNotEmpty ?? false)
                                        ? null
                                        : 'Enter your password'),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: const Color(0xFF22D3EE),
                                title: Text('Remember me for 30 days',
                                    style: TextStyle(
                                        color:
                                            AppConstant.textPrimary(context))),
                                value: _rememberMe,
                                onChanged: (value) => setState(
                                    () => _rememberMe = value ?? false)),
                            const SizedBox(height: 18),
                            SizedBox(
                                height: 54,
                                child: ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _signIn,
                                    icon: _isLoading
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white))
                                        : const Icon(Icons.login),
                                    label: Text(_isLoading
                                        ? 'Signing in...'
                                        : 'Sign In'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF22D3EE),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))))),
                            const SizedBox(height: 28),
                            Text('© 2026 Magnitude HRMS\nPowered by BriskDev',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppConstant.textHint(context))),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
