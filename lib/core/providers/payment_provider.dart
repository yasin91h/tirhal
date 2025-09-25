import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import '../localization/localization_extension.dart';

class PaymentProvider extends ChangeNotifier {
  int _selectedPaymentIndex = 0;
  bool _isProcessing = false;

  // Private method to generate localized payment methods
  List<PaymentMethod> _getPaymentMethods(BuildContext context) {
    return [
      PaymentMethod(
        id: 'cash',
        name: context.l10n.cash,
        icon: Icons.money,
        description: context.l10n.cashDescription,
        isDefault: true,
      ),
      PaymentMethod(
        id: 'card_visa',
        name: '${context.l10n.visaCard} **** 1234',
        icon: Icons.credit_card,
        description: '${context.l10n.visaDescription} 1234',
        isDefault: false,
      ),
      PaymentMethod(
        id: 'card_master',
        name: '${context.l10n.mastercard} **** 5678',
        icon: Icons.credit_card,
        description: '${context.l10n.mastercardDescription} 5678',
        isDefault: false,
      ),
      PaymentMethod(
        id: 'apple_pay',
        name: context.l10n.applePay,
        icon: Icons.phone_android,
        description: context.l10n.applePayDescription,
        isDefault: false,
      ),
      PaymentMethod(
        id: 'google_pay',
        name: context.l10n.googlePay,
        icon: Icons.payment,
        description: context.l10n.googlePayDescription,
        isDefault: false,
      ),
    ];
  }

  // Getters
  int get selectedPaymentIndex => _selectedPaymentIndex;
  bool get isProcessing => _isProcessing;
  List<PaymentMethod> getPaymentMethods(BuildContext context) =>
      _getPaymentMethods(context);
  PaymentMethod getSelectedPaymentMethod(BuildContext context) =>
      _getPaymentMethods(context)[_selectedPaymentIndex];

  // Methods
  void selectPaymentMethod(int index, BuildContext context) {
    final paymentMethods = _getPaymentMethods(context);
    if (index >= 0 && index < paymentMethods.length) {
      _selectedPaymentIndex = index;
      notifyListeners();
    }
  }

  void setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void reset() {
    _selectedPaymentIndex = 0;
    _isProcessing = false;
    notifyListeners();
  }

  // Format price in Riyals
  String formatPrice(double price, BuildContext context) {
    return '${price.toStringAsFixed(0)} ${context.l10n.sar}';
  }

  // Convert USD to SAR (approximate rate, in real app this should come from API)
  double convertToSAR(double usdAmount) {
    const double usdToSarRate = 3.75; // 1 USD = 3.75 SAR (approximate)
    return usdAmount * usdToSarRate;
  }
}
