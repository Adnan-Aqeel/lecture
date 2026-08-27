import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/presentation/screens/login/login_screen.dart';
import 'package:lecture/core/constants/app_colors.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({super.key});

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  bool _isOpening = false;

  Future<void> _openLogin() async {
    setState(() => _isOpening = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    setState(() => _isOpening = false);
  }

  Widget _feature(
      BuildContext context, IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Row(children: [
        Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color)),
        const SizedBox(width: 14),
        Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textPrimary(context)))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              horizontal: isTablet ? 40 : 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(children: [
                Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.fromLTRB(24, isTablet ? 34 : 26, 24, 28),
                    decoration: const BoxDecoration(
                        color: Color(0xFF22D3EE),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(34),
                            bottomRight: Radius.circular(34),
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22))),
                    child: Column(children: [
                      Container(
                          width: 112,
                          height: 82,
                          decoration: BoxDecoration(
                              color: const Color(0xFF0D2D3F),
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/magnitude.png',
                              fit: BoxFit.contain)),
                      const SizedBox(height: 22),
                      const Text('Magnitude',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D2D3F))),
                      const SizedBox(height: 8),
                      Text('Enterprise HR & ERP platform',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D2D3F))),
                    ])),
                const SizedBox(height: 24),
                Text('Everything your workforce needs, in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: isTablet ? 22 : 19,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(context))),
                const SizedBox(height: 8),
                Text(
                    'Manage your entire workforce from a single, intelligent dashboard.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: AppConstant.textHint(context))),
                const SizedBox(height: 24),
                _feature(
                    context,
                    Icons.people_alt_outlined,
                    'Employee & Attendance Management',
                    const Color(0xFF2563EB)),
                const SizedBox(height: 12),
                _feature(context, Icons.bar_chart_outlined,
                    'Payroll, KPIs & Performance', const Color(0xFF7C3AED)),
                const SizedBox(height: 12),
                _feature(context, Icons.shield_outlined,
                    'Role-Based Access Control', const Color(0xFF059669)),
                const SizedBox(height: 12),
                _feature(context, Icons.analytics_outlined,
                    'Real-Time Analytics & Reports', const Color(0xFFEA580C)),
                const SizedBox(height: 28),
                SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                        onPressed: _isOpening ? null : _openLogin,
                        icon: _isOpening
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.arrow_forward_rounded),
                        label: Text(_isOpening ? 'Opening...' : 'Get Started'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22D3EE),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))))),
                const SizedBox(height: 20),
                Text('© 2026 Magnitude HRMS  •  Powered by BriskDev',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: AppConstant.textHint(context))),
              ]),
            ),
          ),
        );
      }),
    );
  }
}
