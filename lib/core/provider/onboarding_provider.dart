import 'package:flutter/material.dart';
import 'package:tirhal/core/models/onboarding.dart';
import 'package:tirhal/core/localization/localization_extension.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentPage = 0;
  final PageController controller = PageController();

  int get currentPage => _currentPage;

  List<OnboardingModel> getPages(BuildContext context) {
    return [
      OnboardingModel(
        title: context.l10n.onboardingTitle1,
        subtitle: context.l10n.onboardingSubtitle1,
        image: "assets/images/logo2.jpg",
      ),
      OnboardingModel(
        title: context.l10n.onboardingTitle2,
        subtitle: context.l10n.onboardingSubtitle2,
        image: "assets/images/logo1.jpg",
      ),
      OnboardingModel(
        title: context.l10n.onboardingTitle3,
        subtitle: context.l10n.onboardingSubtitle3,
        image: "assets/images/logo3.jpg",
      ),
    ];
  }

  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    final pages = getPages(context);
    if (_currentPage < pages.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToHome(context);
    }
  }

  void skip(BuildContext context) {
    goToHome(context);
  }

  void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/LoginScreen");
  }
}
