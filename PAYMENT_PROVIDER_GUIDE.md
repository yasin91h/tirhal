# Payment Selection Page - Provider Implementation

## Overview

The PaymentSelectionPage has been restructured to use the Provider pattern with proper separation of concerns and currency conversion from USD to Saudi Riyals (SAR).

## Architecture

### Models

- **PaymentMethod Model** (`lib/core/models/payment_method_model.dart`)
  - Defines payment method structure with id, name, icon, description, and default status
  - Includes proper copyWith method and equality operators

### Providers

- **PaymentProvider** (`lib/core/providers/payment_provider.dart`)
  - Manages payment methods list
  - Handles selected payment method state
  - Provides processing state for loading indicators
  - Includes currency conversion (USD to SAR at 1:3.75 ratio)
  - Formats prices in Saudi Riyal format (XX ر.س)

### UI Components

- **PaymentSelectionPage** (`lib/features/payment/payment_selection_page.dart`)
  - Uses Consumer<PaymentProvider> for reactive UI
  - Separated into focused build methods
  - Implements proper error handling and loading states

## Key Features

### Currency Support

- Automatic conversion from USD to SAR (1 USD = 3.75 SAR)
- Proper Arabic currency formatting: "XX ر.س"
- Consistent price display throughout the payment flow

### State Management

- Reactive selection changes using Provider
- Loading states for payment processing
- Error handling with user feedback

### Dark Mode Support

- Full theme-aware color usage
- Proper contrast ratios in both light and dark themes
- Uses Material Design 3 color schemes

## Usage

### Integration in Main App

```dart
// In your main.dart or app.dart, wrap your app with providers:
MultiProvider(
  providers: [
    // ... other providers
    ChangeNotifierProvider(create: (_) => PaymentProvider()),
  ],
  child: MyApp(),
)
```

### Navigation

```dart
// Navigate to payment selection
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PaymentSelectionPage(
      destination: destinationLocation,
      pickup: pickupLocation,
      carType: selectedCarType,
    ),
  ),
);
```

### Accessing Payment Data

```dart
// In other parts of your app:
Consumer<PaymentProvider>(
  builder: (context, paymentProvider, child) {
    return Text('Selected: ${paymentProvider.selectedPaymentMethod.name}');
  },
)

// Or without Consumer:
final paymentProvider = Provider.of<PaymentProvider>(context);
final selectedMethod = paymentProvider.selectedPaymentMethod;
```

## API Integration Points

### Currency Conversion

```dart
// Update the conversion rate from API
class PaymentProvider extends ChangeNotifier {
  double _usdToSarRate = 3.75; // Default rate

  void updateExchangeRate(double newRate) {
    _usdToSarRate = newRate;
    notifyListeners();
  }

  double convertToSAR(double usdAmount) {
    return usdAmount * _usdToSarRate;
  }
}
```

### Payment Methods Management

```dart
// Add payment methods from API
paymentProvider.addPaymentMethod(
  PaymentMethod(
    id: 'new_card',
    name: 'Visa **** 9876',
    icon: Icons.credit_card,
    description: 'Added from API',
    isDefault: false,
  ),
);
```

## Benefits

1. **Separation of Concerns**: UI logic separated from business logic
2. **Reactive Updates**: Automatic UI updates when state changes
3. **Currency Localization**: Proper SAR formatting and conversion
4. **Maintainable Code**: Clear provider pattern implementation
5. **Type Safety**: Strong typing with proper models
6. **Error Handling**: Comprehensive error states and user feedback
7. **Dark Mode Support**: Complete theme integration
8. **Performance**: Efficient state updates and rebuilds

## Testing

The provider pattern makes unit testing easier:

```dart
// Test provider methods
test('should convert USD to SAR correctly', () {
  final provider = PaymentProvider();
  expect(provider.convertToSAR(100), equals(375.0));
});

test('should format SAR price correctly', () {
  final provider = PaymentProvider();
  expect(provider.formatPrice(100), equals('100 ر.س'));
});
```
