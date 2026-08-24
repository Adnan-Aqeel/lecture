import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstant {
  static String appMainName = "HRMS";
  static String appPoweredBy = "BriskDev";

  // ── Primary Colors ────────────────────────────────────────────────────────
  static const primarycolor = Color(0xFF22d3ee);
  static const SecondaryColor = Color(0xff981206);

  // ── Splash Colors ─────────────────────────────────────────────────────────
  static const Color splashBackground = Color(0xFF0B2032);
  static const Color splashGradientStart = Color(0xFF0D2D3F);
  static const Color splashGradientEnd = Color(0xFF0A192A);
  static const Color loginIconBackground = Color(0xFF093046);

  // ── Status Colors ─────────────────────────────────────────────────────────
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // ── Dark Mode ─────────────────────────────────────────────────────────────
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color scaffoldBg(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF0F0F1A) : const Color(0xFFF3F5F9);
  }

  static Color cardBg(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF1E1E30) : Colors.white;
  }

  static Color appBarBg(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF1A1A2E) : primarycolor;
  }

  static Color textPrimary(BuildContext context) {
    return isDarkMode(context) ? Colors.white : Colors.black87;
  }

  static Color textSecondary(BuildContext context) {
    return isDarkMode(context) ? Colors.white70 : Colors.black54;
  }

  static Color textHint(BuildContext context) {
    return isDarkMode(context) ? Colors.white38 : Colors.grey;
  }

  static Color divider(BuildContext context) {
    return isDarkMode(context) ? Colors.grey.shade800 : Colors.grey.shade300;
  }

  static Color border(BuildContext context) {
    return isDarkMode(context) ? Colors.grey.shade700 : Colors.grey.shade300;
  }

  static Color inputBg(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF252540) : Colors.white;
  }

  static Color tableHeaderBg(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF252540) : Colors.grey.shade100;
  }

  static Color tableRowBg(BuildContext context, int index) {
    if (isDarkMode(context)) {
      return index.isEven ? const Color(0xFF1A1A2E) : const Color(0xFF1E1E30);
    }
    return index.isEven ? Colors.white : Colors.grey.shade50;
  }

  static Color chipBg(BuildContext context) {
    return isDarkMode(context) ? Colors.teal.shade900 : Colors.teal.shade50;
  }

  static Color statusBarColor(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF0F0F1A) : const Color(0xFF0F172A);
  }

  // ── Common InputDecoration ─────────────────────────────────────────────────
  static InputDecoration searchInputDecoration(BuildContext context, {String? hintText}) {
    return InputDecoration(
      hintText: hintText ?? 'Search...',
      hintStyle: TextStyle(fontSize: 13, color: textHint(context)),
      prefixIcon: Icon(Icons.search_rounded, size: 18, color: textHint(context)),
      filled: true,
      fillColor: cardBg(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primarycolor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  // ── Common AppBar ─────────────────────────────────────────────────────────
  static AppBar buildAppBar(BuildContext context, {required String title, String? subtitle, List<Widget>? actions}) {
    return AppBar(
      backgroundColor: appBarBg(context),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            isDarkMode(context) ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            isDarkMode(context) ? Brightness.dark : Brightness.light,
      ),
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimary(context))),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13, color: textPrimary(context))),
              ],
            )
          : Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary(context))),
      actions: actions,
    );
  }

  // ── Common Card Decoration ────────────────────────────────────────────────
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: cardBg(context),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: border(context)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ── Common SnackBar ───────────────────────────────────────────────────────
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        backgroundColor: backgroundColor ?? primarycolor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Common Elevated Button ────────────────────────────────────────────────
  static ButtonStyle primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primarycolor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      elevation: 0,
    );
  }

  // ── SystemUiOverlayStyle ──────────────────────────────────────────────────
  static SystemUiOverlayStyle systemUiOverlayStyle(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness:
          isDarkMode(context) ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          isDarkMode(context) ? Brightness.dark : Brightness.light,
    );
  }
}
