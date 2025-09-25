import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/features/auth/auth_screen.dart';
import 'package:tirhal/features/login_Screen/Login_provider.dart';
import 'package:tirhal/core/theme/app_theme.dart';
import 'package:tirhal/core/localization/localization_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize login provider and load saved phone number
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      await loginProvider.initializeLogin();

      // Load saved phone number if available
      final savedPhone = await loginProvider.getSavedPhoneNumber();
      if (savedPhone != null && savedPhone.isNotEmpty) {
        _phoneController.text = savedPhone;
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);

      // Save phone number to LoginProvider
      final success = await loginProvider.loginWithPhone(phone);

      if (success) {
        // Navigate to AuthScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuthScreen(phoneNumber: phone),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.failedSaveLogin),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),

                          // Logo
                          Image.asset(
                            "assets/images/logo1.jpg",
                            height: 150,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            context.l10n.loginWithPhone,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.l10n.enterPhoneNumber,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          // Form
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                hintText: context.l10n.enterPhoneNumber,
                                filled: true,
                                fillColor: Theme.of(context).cardTheme.color,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.l10n.phoneNumberRequired;
                                }
                                if (value.length < 9) {
                                  return context.l10n.enterValidPhoneNumber;
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Button
                          ElevatedButton(
                            onPressed: loginProvider.isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: loginProvider.isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    context.l10n.continueText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.termsAndPrivacy,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
