import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lecture/presentation/screens/no_internet/no_internet_screen.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/presentation/screens/open/open_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted || _navigated) return;

    final hasInternet = await _hasInternetConnection();
    if (!mounted || _navigated) return;

    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            hasInternet ? const OpenScreen() : const NoInternetScreen(),
      ),
    );
  }

  Future<bool> _hasInternetConnection() async {
    return await InternetConnection().hasInternetAccess;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstant.splashBackground,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: AppConstant.splashBackground,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstant.splashGradientStart,
                  AppConstant.splashGradientEnd,
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 360),
                SizedBox(
                  height: 100,
                  width: 150,
                  child: Card(
                    color: AppConstant.splashGradientStart,
                    child: Image.asset("assets/magnitude.png"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
