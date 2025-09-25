import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/features/profile/profile_provider.dart';
import 'package:tirhal/features/auth/auth_provider.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/localization/localization_extension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.l10n.selectLanguage,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Consumer<LanguageProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: provider.availableLanguages.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value),
                    leading: Radio<AppLanguage>(
                      value: entry.key,
                      groupValue: provider.selectedLanguage,
                      onChanged: (AppLanguage? value) {
                        if (value != null) {
                          provider.setLanguage(value);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    onTap: () {
                      provider.setLanguage(entry.key);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.cancel,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLocalizedThemeLabel(BuildContext context, AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return context.l10n.light;
      case AppThemeMode.dark:
        return context.l10n.dark;
      case AppThemeMode.system:
        return context.l10n.system;
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.l10n.selectTheme,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: AppThemeMode.values.map((themeMode) {
                  return ListTile(
                    title: Text(_getLocalizedThemeLabel(context, themeMode)),
                    leading: Radio<AppThemeMode>(
                      value: themeMode,
                      groupValue: provider.themeMode,
                      onChanged: (AppThemeMode? value) {
                        if (value != null) {
                          provider.setThemeMode(value);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    onTap: () {
                      provider.setThemeMode(themeMode);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.cancel,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: theme.colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.logout,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            context.l10n.areYouSureLogout,
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                context.l10n.cancel,
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);

                // Close dialog first
                Navigator.of(context).pop();

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                );

                try {
                  // Perform logout
                  await authProvider.logout();

                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Navigate to login screen and clear stack
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/LoginScreen',
                    (route) => false,
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.onInverseSurface,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.successfullyLoggedOut,
                            style: GoogleFonts.poppins(
                              color: theme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.inverseSurface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error logging out: ${e.toString()}',
                        style: TextStyle(color: theme.colorScheme.onError),
                      ),
                      backgroundColor: theme.colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                context.l10n.logout,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, LanguageProvider, ThemeProvider>(
      builder:
          (context, profileProvider, languageProvider, themeProvider, child) {
        final profile = profileProvider.profile;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(context.l10n.profile),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header section with avatar and name
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(profile.imagePath),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account information section
                  _buildListTile(
                    context: context,
                    icon: Icons.person,
                    title: context.l10n.account,
                    subtitle: profile.email,
                    onTap: () {},
                  ),
                  _buildDivider(context),

                  _buildListTile(
                    context: context,
                    icon: Icons.language,
                    title: context.l10n.language,
                    subtitle: languageProvider.selectedLanguageDisplayName,
                    onTap: () => _showLanguageDialog(context),
                  ),
                  _buildDivider(context),

                  _buildListTile(
                    context: context,
                    icon: Icons.palette,
                    title: context.l10n.theme,
                    subtitle: _getLocalizedThemeLabel(
                        context, themeProvider.themeMode),
                    onTap: () => _showThemeDialog(context),
                  ),
                  _buildDivider(context),

                  _buildListTile(
                    context: context,
                    icon: Icons.info,
                    title: context.l10n.aboutUs,
                    subtitle: context.l10n.learnMoreAboutApp,
                    onTap: () {},
                  ),
                  _buildDivider(context),

                  // Logout
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.error,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        context.l10n.logout,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
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

  // Reusable list tile with consistent design
  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return const SizedBox(height: 8); // Just spacing between cards
  }
}
