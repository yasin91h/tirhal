import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/features/auth/auth_provider.dart';
import 'package:tirhal/core/localization/localization_extension.dart';

class AuthScreen extends StatefulWidget {
  final String phoneNumber;

  const AuthScreen({super.key, required this.phoneNumber});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    void handleVerify() async {
      bool success = await authProvider.verifyOtp(widget.phoneNumber);
      if (success) {
        Navigator.pushReplacementNamed(context, "/MainScreen");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.invalidOTP,
              style: TextStyle(color: theme.colorScheme.onError),
            ),
            backgroundColor: theme.colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.l10n.otpVerification),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      context.l10n.verifyYourNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      "${context.l10n.enterSixDigitCode} ${widget.phoneNumber}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // OTP Input Field with enhanced styling
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        cursorColor: theme.colorScheme.primary,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 58,
                          fieldWidth: 50,
                          activeFillColor: theme.colorScheme.primaryContainer
                              .withOpacity(0.15),
                          inactiveFillColor:
                              theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          selectedFillColor: theme.colorScheme.primaryContainer
                              .withOpacity(0.25),
                          activeColor: theme.colorScheme.primary,
                          selectedColor: theme.colorScheme.primary,
                          inactiveColor:
                              theme.colorScheme.outline.withOpacity(0.4),
                          borderWidth: 2,
                          fieldOuterPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                        ),
                        animationDuration: const Duration(milliseconds: 200),
                        enableActiveFill: true,
                        backgroundColor: Colors.transparent,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        onChanged: (value) {
                          authProvider.updateOtp(value);
                        },
                        onCompleted: (_) => handleVerify(),
                        validator: (value) {
                          if (value != null && value.length == 6) {
                            return null;
                          }
                          return '';
                        },
                        errorTextSpace: 0,
                        showCursor: true,
                        cursorWidth: 2,
                        cursorHeight: 20,
                        autoFocus: true,
                        pastedTextStyle: GoogleFonts.poppins(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Verify Button
                    ElevatedButton(
                      onPressed: handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        context.l10n.verify,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Resend OTP Button
                    TextButton(
                      onPressed: () {
                        authProvider.resetOtp();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.otpResent,
                              style: TextStyle(
                                  color: theme.colorScheme.onInverseSurface),
                            ),
                            backgroundColor: theme.colorScheme.inverseSurface,
                          ),
                        );
                      },
                      child: Text(
                        context.l10n.resendOTP,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.enterDemoCode,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
