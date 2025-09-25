import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common App Strings
  String get appName => locale.languageCode == 'ar' ? 'ترحال' : 'Tirhal';

  // Authentication
  String get loginWithPhone =>
      locale.languageCode == 'ar' ? 'تسجيل الدخول بالهاتف' : 'Login with Phone';
  String get enterPhoneNumber =>
      locale.languageCode == 'ar' ? 'أدخل رقم الهاتف' : 'Enter phone number';
  String get phoneNumberRequired => locale.languageCode == 'ar'
      ? 'رقم الهاتف مطلوب'
      : 'Phone number is required';
  String get enterValidPhoneNumber => locale.languageCode == 'ar'
      ? 'أدخل رقم هاتف صحيح'
      : 'Enter valid phone number';
  String get continueText =>
      locale.languageCode == 'ar' ? 'متابعة' : 'Continue';
  String get otpVerification =>
      locale.languageCode == 'ar' ? 'تأكيد الرمز' : 'OTP Verification';
  String get verifyYourNumber =>
      locale.languageCode == 'ar' ? 'تأكيد رقمك' : 'Verify Your Number';
  String get enterSixDigitCode => locale.languageCode == 'ar'
      ? 'أدخل الرمز المكون من 6 أرقام المرسل إلى'
      : 'Enter the 6-digit code sent to';
  String get verify => locale.languageCode == 'ar' ? 'تأكيد' : 'Verify';
  String get resendOTP =>
      locale.languageCode == 'ar' ? 'إعادة إرسال الرمز' : 'Resend OTP';
  String get invalidOTP => locale.languageCode == 'ar'
      ? 'رمز خاطئ، يرجى المحاولة مرة أخرى'
      : 'Invalid OTP, please try again';
  String get otpResent => locale.languageCode == 'ar'
      ? 'تم إعادة إرسال الرمز بنجاح'
      : 'OTP Resent Successfully';
  String get enterDemoCode => locale.languageCode == 'ar'
      ? 'أدخل 123456 للمتابعة والذهاب إلى الصفحة الرئيسية'
      : 'Enter 123456 to complete and go to Home Page';

  // Onboarding
  String get skip => locale.languageCode == 'ar' ? 'تخطي' : 'Skip';
  String get next => locale.languageCode == 'ar' ? 'التالي' : 'Next';
  String get getStarted => locale.languageCode == 'ar' ? 'ابدأ' : 'Get Started';

  // Onboarding Content
  String get onboardingTitle1 =>
      locale.languageCode == 'ar' ? 'مرحباً بك في ترحال' : 'Welcome to Tirhal';
  String get onboardingSubtitle1 => locale.languageCode == 'ar'
      ? 'رفيقك الآمن والسريع في الرحلات 🚖'
      : 'Your safe and fast ride companion 🚖';

  String get onboardingTitle2 =>
      locale.languageCode == 'ar' ? 'حجز سهل' : 'Easy Booking';
  String get onboardingSubtitle2 => locale.languageCode == 'ar'
      ? 'احجز تاكسي في أي وقت وأي مكان في ثوانٍ 📲'
      : 'Book a taxi anytime, anywhere in just seconds 📲';

  String get onboardingTitle3 =>
      locale.languageCode == 'ar' ? 'تتبع رحلتك' : 'Track Your Ride';
  String get onboardingSubtitle3 => locale.languageCode == 'ar'
      ? 'تتبع في الوقت الفعلي وسائقين موثوقين 🗺️'
      : 'Real-time tracking & reliable drivers 🗺️';

  // Navigation
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get profile =>
      locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';
  String get history => locale.languageCode == 'ar' ? 'التاريخ' : 'History';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';

  // Profile
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get theme => locale.languageCode == 'ar' ? 'المظهر' : 'Theme';
  String get selectLanguage =>
      locale.languageCode == 'ar' ? 'اختر اللغة' : 'Select Language';
  String get logout => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get areYouSureLogout => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من تسجيل الخروج؟ سيتم توجيهك إلى شاشة تسجيل الدخول.'
      : 'Are you sure you want to logout? You will be redirected to the login screen.';
  String get successfullyLoggedOut => locale.languageCode == 'ar'
      ? 'تم تسجيل الخروج بنجاح'
      : 'Successfully logged out';

  // Ride Tracking
  String get pickup => locale.languageCode == 'ar' ? 'نقطة الانطلاق' : 'Pickup';
  String get destination =>
      locale.languageCode == 'ar' ? 'الوجهة' : 'Destination';
  String get tripCompleted =>
      locale.languageCode == 'ar' ? 'تمت الرحلة!' : 'Trip Completed!';
  String get totalFare =>
      locale.languageCode == 'ar' ? 'إجمالي الأجرة:' : 'Total Fare:';
  String get done => locale.languageCode == 'ar' ? 'تم' : 'Done';
  String get cancelRide =>
      locale.languageCode == 'ar' ? 'إلغاء الرحلة' : 'Cancel Ride';
  String get areYouSureCancelRide => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من إلغاء هذه الرحلة؟'
      : 'Are you sure you want to cancel this ride?';

  // General
  String get yes => locale.languageCode == 'ar' ? 'نعم' : 'Yes';
  String get no => locale.languageCode == 'ar' ? 'لا' : 'No';
  String get ok => locale.languageCode == 'ar' ? 'موافق' : 'OK';
  String get loading =>
      locale.languageCode == 'ar' ? 'جار التحميل...' : 'Loading...';
  String get error => locale.languageCode == 'ar' ? 'خطأ' : 'Error';
  String get success => locale.languageCode == 'ar' ? 'نجح' : 'Success';
  String get aboutUs =>
      locale.languageCode == 'ar' ? 'حول التطبيق' : 'About Us';
  String get learnMoreAboutApp => locale.languageCode == 'ar'
      ? 'تعرف أكثر على تطبيقنا'
      : 'Learn more about our app';

  // Terms and Privacy
  String get termsAndPrivacy => locale.languageCode == 'ar'
      ? 'بمتابعتك، فأنت توافق على الشروط وسياسة الخصوصية الخاصة بنا'
      : 'By continuing, you agree to our Terms & Privacy Policy';

  String get failedSaveLogin => locale.languageCode == 'ar'
      ? 'فشل في حفظ معلومات تسجيل الدخول'
      : 'Failed to save login information';

  // Home Screen & Ride
  String get currentLocation =>
      locale.languageCode == 'ar' ? 'الموقع الحالي' : 'Current Location';
  String get whereTo => locale.languageCode == 'ar' ? 'إلى أين؟' : 'Where to?';
  String get work => locale.languageCode == 'ar' ? 'العمل' : 'Work';
  String get saved => locale.languageCode == 'ar' ? 'المحفوظ' : 'Saved';
  String get complete => locale.languageCode == 'ar' ? 'إكمال' : 'Complete';
  String get lookingForDrivers => locale.languageCode == 'ar'
      ? 'البحث عن سائقين قريبين...'
      : 'Looking for nearby drivers...';
  String get driverOnWay =>
      locale.languageCode == 'ar' ? 'السائق في الطريق' : 'Driver is on the way';
  String get tripCompletedSuccessfully => locale.languageCode == 'ar'
      ? 'تمت الرحلة بنجاح'
      : 'Trip completed successfully';
  String get tripWasCanceled =>
      locale.languageCode == 'ar' ? 'تم إلغاء الرحلة' : 'Trip was canceled';

  // Location Permission
  String get locationAccessRequired => locale.languageCode == 'ar'
      ? 'مطلوب الوصول للموقع'
      : 'Location Access Required';
  String get locationAccessDescription => locale.languageCode == 'ar'
      ? 'يحتاج هذا التطبيق للوصول للموقع لإظهار السائقين القريبين وتوفير خدمات الرحلات الدقيقة.'
      : 'This app needs location access to show nearby drivers and provide accurate ride services.';
  String get grantLocationAccess => locale.languageCode == 'ar'
      ? 'منح الوصول للموقع'
      : 'Grant Location Access';
  String get openAppSettings =>
      locale.languageCode == 'ar' ? 'فتح إعدادات التطبيق' : 'Open App Settings';
  String get locationPrivacyNote => locale.languageCode == 'ar'
      ? 'بيانات الموقع تستخدم فقط لتحسين تجربة الرحلة ولا تتم مشاركتها أبداً بدون موافقتك.'
      : 'Location data is used only to enhance your ride experience and is never shared without your consent.';

  // Ride History
  String get rideHistory =>
      locale.languageCode == 'ar' ? 'تاريخ الرحلات' : 'Ride History';
  String get loadingRideHistory => locale.languageCode == 'ar'
      ? 'جار تحميل تاريخ الرحلات...'
      : 'Loading ride history...';
  String get errorLoadingRides => locale.languageCode == 'ar'
      ? 'خطأ في تحميل الرحلات'
      : 'Error loading rides';
  String get retry => locale.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry';
  String get noRidesFound =>
      locale.languageCode == 'ar' ? 'لا توجد رحلات' : 'No rides found';
  String get rideHistoryWillAppearHere => locale.languageCode == 'ar'
      ? 'سيظهر تاريخ رحلاتك هنا'
      : 'Your ride history will appear here';
  String get rideId => locale.languageCode == 'ar' ? 'رقم الرحلة:' : 'Ride ID:';
  String get from => locale.languageCode == 'ar' ? 'من:' : 'From: ';
  String get to => locale.languageCode == 'ar' ? 'إلى:' : 'To: ';

  // Currency
  String get sar => locale.languageCode == 'ar' ? 'ريال سعودي' : 'SAR';

  // Ride Screen - New methods only (avoiding duplicates)
  String get tirhalRide =>
      locale.languageCode == 'ar' ? 'رحلة ترحال' : 'Tirhal Ride';
  String get dismiss => locale.languageCode == 'ar' ? 'إخفاء' : 'Dismiss';
  String get pickupLocation =>
      locale.languageCode == 'ar' ? 'موقع الاستلام: ' : 'Pickup Location: ';
  String get noActiveRide =>
      locale.languageCode == 'ar' ? 'لا توجد رحلة نشطة' : 'No Active Ride';
  String get rideStatus =>
      locale.languageCode == 'ar' ? 'حالة الرحلة' : 'Ride Status';
  String get processingRequest => locale.languageCode == 'ar'
      ? 'جاري معالجة طلبك...'
      : 'Processing your request...';
  String get rideTime =>
      locale.languageCode == 'ar' ? 'وقت الرحلة' : 'Ride Time';
  String get rideProgress =>
      locale.languageCode == 'ar' ? 'تقدم الرحلة' : 'Ride Progress';
  String get request => locale.languageCode == 'ar' ? 'طلب' : 'Request';
  String get accepted => locale.languageCode == 'ar' ? 'مقبول' : 'Accepted';
  String get yourDriver =>
      locale.languageCode == 'ar' ? 'سائقك' : 'Your Driver';
  String get completeRide =>
      locale.languageCode == 'ar' ? 'إنهاء الرحلة' : 'Complete Ride';
  String get rideCompletedSuccessfully => locale.languageCode == 'ar'
      ? 'تم إنهاء الرحلة بنجاح!'
      : 'Ride Completed Successfully!';
  String get thankYouForUsingTirhal => locale.languageCode == 'ar'
      ? 'شكراً لاستخدامك ترحال'
      : 'Thank you for using Tirhal';
  String get requestRideToGetStarted => locale.languageCode == 'ar'
      ? 'اطلب رحلة للبدء'
      : 'Request a ride to get started';
  String get areYouSureYouWantToCancelThisRide => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من إلغاء هذه الرحلة؟'
      : 'Are you sure you want to cancel this ride?';
  String get yesCancel =>
      locale.languageCode == 'ar' ? 'نعم، إلغاء' : 'Yes, Cancel';

  // Ride Model Localization
  String get unknownTime =>
      locale.languageCode == 'ar' ? 'وقت غير معروف' : 'Unknown time';
  String get justNow => locale.languageCode == 'ar' ? 'الآن' : 'Just now';
  String minAgo(int minutes) =>
      locale.languageCode == 'ar' ? 'منذ $minutes دقيقة' : '$minutes min ago';
  String hrAgo(int hours) =>
      locale.languageCode == 'ar' ? 'منذ $hours ساعة' : '$hours hr ago';
  String daysAgo(int days) =>
      locale.languageCode == 'ar' ? 'منذ $days أيام' : '$days days ago';
  String get waitingForDriver =>
      locale.languageCode == 'ar' ? 'في انتظار السائق' : 'Waiting for driver';
  String get driverOnTheWay =>
      locale.languageCode == 'ar' ? 'السائق في الطريق' : 'Driver on the way';
  String get rideCompleted =>
      locale.languageCode == 'ar' ? 'تمت الرحلة' : 'Ride completed';
  String get rideCanceled =>
      locale.languageCode == 'ar' ? 'تم إلغاء الرحلة' : 'Ride canceled';

  // Location Loading Widget
  String get gettingYourLocation => locale.languageCode == 'ar'
      ? 'جار الحصول على موقعك...'
      : 'Getting your location...';
  String get thisMayTakeFewSeconds => locale.languageCode == 'ar'
      ? 'قد يستغرق هذا بضع ثوان'
      : 'This may take a few seconds';

  // Profile Screen Additional
  String get account => locale.languageCode == 'ar' ? 'الحساب' : 'Account';
  String get selectTheme =>
      locale.languageCode == 'ar' ? 'اختر المظهر' : 'Select Theme';

  // Theme options
  String get system => locale.languageCode == 'ar' ? 'النظام' : 'System';
  String get dark => locale.languageCode == 'ar' ? 'داكن' : 'Dark';
  String get light => locale.languageCode == 'ar' ? 'فاتح' : 'Light';

  // Place Search Widget
  String get searchForPlace =>
      locale.languageCode == 'ar' ? 'ابحث عن مكان...' : 'Search for a place...';

  // Ride Tracking Page Additional
  String eta(String time) =>
      locale.languageCode == 'ar' ? 'الوقت المتوقع: $time' : 'ETA: $time';

  // Location Search Page
  String get chooseLocation =>
      locale.languageCode == 'ar' ? 'اختر الموقع' : 'Choose Location';
  String get searchForPlaces => locale.languageCode == 'ar'
      ? 'ابحث عن الأماكن...'
      : 'Search for places...';
  String get useCurrentLocation => locale.languageCode == 'ar'
      ? 'استخدم الموقع الحالي'
      : 'Use Current Location';
  String get findPlacesNearYou => locale.languageCode == 'ar'
      ? 'اعثر على الأماكن القريبة منك'
      : 'Find places near you';
  String get yourCurrentPosition =>
      locale.languageCode == 'ar' ? 'موقعك الحالي' : 'Your current position';

  // Location Search Delegate
  String get quickSearch =>
      locale.languageCode == 'ar' ? 'البحث السريع' : 'Quick Search';
  String get searchingLocations => locale.languageCode == 'ar'
      ? 'جار البحث عن المواقع...'
      : 'Searching locations...';
  String get tryAgain =>
      locale.languageCode == 'ar' ? 'حاول مرة أخرى' : 'Try Again';
  String get noLocationsFound => locale.languageCode == 'ar'
      ? 'لم يتم العثور على مواقع'
      : 'No locations found';
  String get startTypingToSearch => locale.languageCode == 'ar'
      ? 'ابدأ الكتابة للبحث'
      : 'Start typing to search';
  String get tryDifferentSearchTerm => locale.languageCode == 'ar'
      ? 'جرب مصطلح بحث مختلف'
      : 'Try a different search term';
  String get savedPlaces =>
      locale.languageCode == 'ar' ? 'الأماكن المحفوظة' : 'Saved Places';
  String get recentSearches =>
      locale.languageCode == 'ar' ? 'البحث الأخير' : 'Recent Searches';
  String get clear => locale.languageCode == 'ar' ? 'مسح' : 'Clear';
  String get popularPlaces =>
      locale.languageCode == 'ar' ? 'الأماكن الشائعة' : 'Popular Places';

  // Location Types
  String get location => locale.languageCode == 'ar' ? 'موقع' : 'Location';
  String get restaurant => locale.languageCode == 'ar' ? 'مطعم' : 'Restaurant';
  String get shopping => locale.languageCode == 'ar' ? 'تسوق' : 'Shopping';
  String get hospital => locale.languageCode == 'ar' ? 'مستشفى' : 'Hospital';
  String get school => locale.languageCode == 'ar' ? 'مدرسة' : 'School';
  String get airport => locale.languageCode == 'ar' ? 'مطار' : 'Airport';
  String get gasStation =>
      locale.languageCode == 'ar' ? 'محطة وقود' : 'Gas Station';
  String get bank => locale.languageCode == 'ar' ? 'بنك' : 'Bank';
  String get hotel => locale.languageCode == 'ar' ? 'فندق' : 'Hotel';

  // Location Search Provider Error Messages
  String get failedToSearchLocations => locale.languageCode == 'ar'
      ? 'فشل في البحث عن المواقع'
      : 'Failed to search locations';
  String get failedToGetNearbyPlaces => locale.languageCode == 'ar'
      ? 'فشل في الحصول على الأماكن القريبة'
      : 'Failed to get nearby places';
  String get errorGettingPlaceDetails => locale.languageCode == 'ar'
      ? 'خطأ في الحصول على تفاصيل المكان'
      : 'Error getting place details';

  // Default Saved Places
  String get homeLocation => locale.languageCode == 'ar' ? 'المنزل' : 'Home';
  String get workLocation => locale.languageCode == 'ar' ? 'العمل' : 'Work';
  String get setYourHomeAddress =>
      locale.languageCode == 'ar' ? 'حدد عنوان منزلك' : 'Set your home address';
  String get setYourWorkAddress =>
      locale.languageCode == 'ar' ? 'حدد عنوان عملك' : 'Set your work address';

  // Location Search for nearby places
  String get placesNearMe =>
      locale.languageCode == 'ar' ? 'الأماكن القريبة مني' : 'places near me';

  // Additional UI Text - Widgets
  String get addressNotAvailable => locale.languageCode == 'ar'
      ? 'العنوان غير متوفر'
      : 'Address not available';
  String get driverName =>
      locale.languageCode == 'ar' ? 'السائق أحمد' : 'Ahmed Driver';
  String get driverRating => locale.languageCode == 'ar'
      ? '★ 4.9 • تويوتا كامري • ABC-123'
      : '★ 4.9 • Toyota Camry • ABC-123';

  // Payment Page
  String get paymentMethod =>
      locale.languageCode == 'ar' ? 'طريقة الدفع' : 'Payment Method';
  String get choosePaymentMethod => locale.languageCode == 'ar'
      ? 'اختر طريقة الدفع'
      : 'Choose Payment Method';
  String get addNewPaymentMethod => locale.languageCode == 'ar'
      ? 'إضافة طريقة دفع جديدة'
      : 'Add New Payment Method';
  String get confirmBooking =>
      locale.languageCode == 'ar' ? 'تأكيد الحجز' : 'Confirm Booking';
  String get addPaymentMethod =>
      locale.languageCode == 'ar' ? 'إضافة طريقة دفع' : 'Add Payment Method';
  String get bankAccount =>
      locale.languageCode == 'ar' ? 'الحساب البنكي' : 'Bank Account';
  String get defaultPayment =>
      locale.languageCode == 'ar' ? 'افتراضي' : 'Default';
  String get currentLocationPickup =>
      locale.languageCode == 'ar' ? 'الموقع الحالي' : 'Current Location';

  // Additional Location Types
  String get mall => locale.languageCode == 'ar' ? 'مول' : 'Mall';
  String get university => locale.languageCode == 'ar' ? 'جامعة' : 'University';

  // Ride Booking Page
  String get chooseYourRide =>
      locale.languageCode == 'ar' ? 'اختر رحلتك' : 'Choose Your Ride';
  String get economy => locale.languageCode == 'ar' ? 'اقتصادي' : 'Economy';
  String get comfort => locale.languageCode == 'ar' ? 'مريح' : 'Comfort';
  String get premium => locale.languageCode == 'ar' ? 'مميز' : 'Premium';
  String get xl => locale.languageCode == 'ar' ? 'كبير' : 'XL';
  String get affordableRides =>
      locale.languageCode == 'ar' ? 'رحلات بأسعار مناسبة' : 'Affordable rides';
  String get moreSpaceComfort => locale.languageCode == 'ar'
      ? 'مساحة وراحة أكثر'
      : 'More space and comfort';
  String get luxuryVehicles =>
      locale.languageCode == 'ar' ? 'مركبات فاخرة' : 'Luxury vehicles';
  String get extraSpaceGroups => locale.languageCode == 'ar'
      ? 'مساحة إضافية للمجموعات'
      : 'Extra space for groups';
  String get estimatedTotal =>
      locale.languageCode == 'ar' ? 'الإجمالي المتوقع' : 'Estimated Total';
  String get requestRide => locale.languageCode == 'ar' ? 'طلب' : 'Request';

  // Payment Methods
  String get cash => locale.languageCode == 'ar' ? 'نقداً' : 'Cash';
  String get cashDescription => locale.languageCode == 'ar'
      ? 'ادفع نقداً بعد الرحلة'
      : 'Pay with cash after ride';
  String get visaCard => locale.languageCode == 'ar' ? 'فيزا' : 'Visa';
  String get visaDescription =>
      locale.languageCode == 'ar' ? 'فيزا تنتهي بـ' : 'Visa ending in';
  String get mastercard =>
      locale.languageCode == 'ar' ? 'ماستركارد' : 'Mastercard';
  String get mastercardDescription => locale.languageCode == 'ar'
      ? 'ماستركارد تنتهي بـ'
      : 'Mastercard ending in';
  String get applePay => locale.languageCode == 'ar' ? 'أبل باي' : 'Apple Pay';
  String get applePayDescription => locale.languageCode == 'ar'
      ? 'ادفع باستخدام أبل باي'
      : 'Pay using Apple Pay';
  String get googlePay =>
      locale.languageCode == 'ar' ? 'جوجل باي' : 'Google Pay';
  String get googlePayDescription => locale.languageCode == 'ar'
      ? 'ادفع باستخدام جوجل باي'
      : 'Pay using Google Pay';

  // Ride Tracking Status Messages
  String get rideStatusSearching => locale.languageCode == 'ar'
      ? 'البحث عن سائق...'
      : 'Searching for driver...';
  String get rideStatusConfirmed =>
      locale.languageCode == 'ar' ? 'تم تأكيد السائق' : 'Driver confirmed';
  String get rideStatusOnWay =>
      locale.languageCode == 'ar' ? 'السائق في الطريق' : 'Driver is on the way';
  String get rideStatusArrived =>
      locale.languageCode == 'ar' ? 'وصل السائق' : 'Driver has arrived';
  String get rideStatusInProgress =>
      locale.languageCode == 'ar' ? 'الرحلة جارية' : 'Trip in progress';
  String get rideStatusCompleted =>
      locale.languageCode == 'ar' ? 'تمت الرحلة' : 'Trip completed';
  String get rideStatusCancelled =>
      locale.languageCode == 'ar' ? 'تم إلغاء الرحلة' : 'Trip cancelled';
  String get rideStatusUnknown =>
      locale.languageCode == 'ar' ? 'الحالة غير معروفة' : 'Status unknown';

  // Location Labels (using existing currentLocation getter)
  String get pickupLocationLabel =>
      locale.languageCode == 'ar' ? 'موقع الاستلام' : 'Pickup Location';
  String get destinationLocation =>
      locale.languageCode == 'ar' ? 'الوجهة' : 'Destination';

  // Time and Status
  String get estimatedTime =>
      locale.languageCode == 'ar' ? 'الوصول المتوقع' : 'Estimated arrival';
  String get estimatedTimeCompleted =>
      locale.languageCode == 'ar' ? 'مكتملة' : 'Completed';

  // Driver Names
  String get driverAhmed =>
      locale.languageCode == 'ar' ? 'أحمد محمد' : 'Ahmed Mohamed';
  String get driverSarah =>
      locale.languageCode == 'ar' ? 'سارة أحمد' : 'Sarah Ahmed';
  String get driverOmar =>
      locale.languageCode == 'ar' ? 'عمر حسن' : 'Omar Hassan';
  String get driverFatima =>
      locale.languageCode == 'ar' ? 'فاطمة علي' : 'Fatima Ali';
  String get driverHassan =>
      locale.languageCode == 'ar' ? 'حسن محمود' : 'Hassan Mahmoud';

  // Wait Time Messages
  String get waitTime0 =>
      locale.languageCode == 'ar' ? 'بدون وقت انتظار' : 'No waiting time';
  String get waitTime1 =>
      locale.languageCode == 'ar' ? 'دقيقة واحدة' : '1 minute';
  String get waitTime2 => locale.languageCode == 'ar' ? 'دقيقتين' : '2 minutes';
  String get waitTime3 => locale.languageCode == 'ar' ? '3 دقائق' : '3 minutes';
  String get waitTime4 => locale.languageCode == 'ar' ? '4 دقائق' : '4 minutes';
  String get waitTime5 => locale.languageCode == 'ar' ? '5 دقائق' : '5 minutes';
  String get waitTimeMore => locale.languageCode == 'ar' ? 'دقائق' : 'minutes';

  // Helper method for dynamic driver names
  String getDriverName(String driverKey) {
    switch (driverKey) {
      case 'ahmed':
        return driverAhmed;
      case 'sarah':
        return driverSarah;
      case 'omar':
        return driverOmar;
      case 'fatima':
        return driverFatima;
      case 'hassan':
        return driverHassan;
      default:
        return driverAhmed; // Default fallback
    }
  }

  // Helper method for ride status messages
  String getRideStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'searching':
        return rideStatusSearching;
      case 'confirmed':
        return rideStatusConfirmed;
      case 'onway':
      case 'on_way':
        return rideStatusOnWay;
      case 'arrived':
        return rideStatusArrived;
      case 'inprogress':
      case 'in_progress':
        return rideStatusInProgress;
      case 'completed':
        return rideStatusCompleted;
      case 'cancelled':
      case 'canceled':
        return rideStatusCancelled;
      default:
        return rideStatusUnknown;
    }
  }

  // Helper method for wait time messages
  String getWaitTimeMessage(int minutes) {
    switch (minutes) {
      case 0:
        return waitTime0;
      case 1:
        return waitTime1;
      case 2:
        return waitTime2;
      case 3:
        return waitTime3;
      case 4:
        return waitTime4;
      case 5:
        return waitTime5;
      default:
        return '$minutes ${waitTimeMore}';
    }
  }

  // Error Messages
  String get errorCancellingRide => locale.languageCode == 'ar'
      ? 'خطأ في إلغاء الرحلة'
      : 'Error cancelling ride';
  String get errorOccurred =>
      locale.languageCode == 'ar' ? 'حدث خطأ' : 'An error occurred';

  // Ride History Screen Additional
  String get failedLoadRideHistory => locale.languageCode == 'ar'
      ? 'فشل تحميل تاريخ الرحلات'
      : 'Failed to load ride history';

  // Filter Options
  String get filterAll => locale.languageCode == 'ar' ? 'الكل' : 'All';
  String get filterCompleted =>
      locale.languageCode == 'ar' ? 'مكتملة' : 'Completed';
  String get filterPending =>
      locale.languageCode == 'ar' ? 'في الانتظار' : 'Pending';
  String get filterCanceled =>
      locale.languageCode == 'ar' ? 'ملغية' : 'Canceled';
  String get filterAccepted =>
      locale.languageCode == 'ar' ? 'مقبولة' : 'Accepted';

  // Statistics
  String get statistics =>
      locale.languageCode == 'ar' ? 'الإحصائيات' : 'Statistics';
  String get totalRides =>
      locale.languageCode == 'ar' ? 'إجمالي الرحلات' : 'Total Rides';
  String get completedRides =>
      locale.languageCode == 'ar' ? 'مكتملة' : 'Completed';
  String get canceledRides =>
      locale.languageCode == 'ar' ? 'ملغية' : 'Canceled';
  String get pendingRides =>
      locale.languageCode == 'ar' ? 'في الانتظار' : 'Pending';
  String get acceptedRides =>
      locale.languageCode == 'ar' ? 'مقبولة' : 'Accepted';
  String get totalDistance =>
      locale.languageCode == 'ar' ? 'إجمالي المسافة' : 'Total Distance';
  String get totalTime =>
      locale.languageCode == 'ar' ? 'إجمالي الوقت' : 'Total Time';
  String get averageRide =>
      locale.languageCode == 'ar' ? 'متوسط الرحلة' : 'Average Ride';

  // Search and Filters
  String get searchRides =>
      locale.languageCode == 'ar' ? 'ابحث في الرحلات...' : 'Search rides...';
  String get clearFilters =>
      locale.languageCode == 'ar' ? 'مسح المرشحات' : 'Clear Filters';
  String get dateRange =>
      locale.languageCode == 'ar' ? 'نطاق التاريخ' : 'Date Range';
  String get fromDate => locale.languageCode == 'ar' ? 'من' : 'From';
  String get toDate => locale.languageCode == 'ar' ? 'إلى' : 'To';
  String get selectDate =>
      locale.languageCode == 'ar' ? 'اختر التاريخ' : 'Select Date';

  // Payment page localizations
  String get creditDebitCard =>
      locale.languageCode == 'ar' ? 'بطاقة ائتمان/خصم' : 'Credit/Debit Card';
  String get digitalWallet =>
      locale.languageCode == 'ar' ? 'محفظة رقمية' : 'Digital Wallet';
  String get paymentCompletedSuccessfully => locale.languageCode == 'ar'
      ? 'تم الدفع بنجاح!'
      : 'Payment completed successfully!';
  String get errorProcessingPayment => locale.languageCode == 'ar'
      ? 'خطأ في معالجة الدفع'
      : 'Error processing payment';
  String get comingSoonPaymentMethods => locale.languageCode == 'ar'
      ? 'قريباً! يمكنك استخدام طرق الدفع الحالية في الوقت الحالي.'
      : 'Coming soon! You can use existing payment methods for now.';

  // Ride tracking page localizations
  String get errorInitializingRide => locale.languageCode == 'ar'
      ? 'خطأ في بدء الرحلة'
      : 'Error initializing ride';
  String get yesCancelRide =>
      locale.languageCode == 'ar' ? 'نعم، إلغاء' : 'Yes, Cancel';
  String get callingDriver =>
      locale.languageCode == 'ar' ? 'اتصال مع' : 'Calling';
  String get openingChatWith =>
      locale.languageCode == 'ar' ? 'فتح المحادثة مع' : 'Opening chat with';

  // Notification Strings
  String get notifications =>
      locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications';
  String get notificationSettings => locale.languageCode == 'ar'
      ? 'إعدادات الإشعارات'
      : 'Notification Settings';
  String get noNotifications => locale.languageCode == 'ar'
      ? 'لا توجد إشعارات بعد'
      : 'No notifications yet';
  String get markAllRead =>
      locale.languageCode == 'ar' ? 'تحديد الكل كمقروء' : 'Mark All as Read';
  String get clearAll =>
      locale.languageCode == 'ar' ? 'مسح الجميع' : 'Clear All';
  String get notificationPermissionRequired => locale.languageCode == 'ar'
      ? 'صلاحية الإشعارات مطلوبة لتلقي التحديثات'
      : 'Notification permission is required to receive updates';
  String get enableNotifications =>
      locale.languageCode == 'ar' ? 'تفعيل الإشعارات' : 'Enable Notifications';
  String get notificationPermissionDenied => locale.languageCode == 'ar'
      ? 'تم رفض صلاحية الإشعارات'
      : 'Notification permission denied';

  String get rideUpdates =>
      locale.languageCode == 'ar' ? 'تحديثات الرحلة' : 'Ride Updates';
  String get driverMessages =>
      locale.languageCode == 'ar' ? 'رسائل السائق' : 'Driver Messages';
  String get paymentUpdates =>
      locale.languageCode == 'ar' ? 'تحديثات الدفع' : 'Payment Updates';
  String get promotions =>
      locale.languageCode == 'ar' ? 'العروض الترويجية' : 'Promotions';
  String get generalNotifications => locale.languageCode == 'ar'
      ? 'الإشعارات العامة'
      : 'General Notifications';

  String get soundNotifications =>
      locale.languageCode == 'ar' ? 'الصوت' : 'Sound';
  String get vibrationNotifications =>
      locale.languageCode == 'ar' ? 'الاهتزاز' : 'Vibration';
  String get quietHours =>
      locale.languageCode == 'ar' ? 'الساعات الهادئة' : 'Quiet Hours';
  String get quietHoursStart =>
      locale.languageCode == 'ar' ? 'وقت البداية' : 'Start Time';
  String get quietHoursEnd =>
      locale.languageCode == 'ar' ? 'وقت النهاية' : 'End Time';

  // Notification Messages
  String get notificationRideRequested =>
      locale.languageCode == 'ar' ? 'تم طلب الرحلة' : 'Ride Requested';
  String get notificationDriverAssigned =>
      locale.languageCode == 'ar' ? 'تم تعيين السائق' : 'Driver Assigned';
  String get notificationDriverArriving =>
      locale.languageCode == 'ar' ? 'السائق في الطريق' : 'Driver Arriving';
  String get notificationRideStarted =>
      locale.languageCode == 'ar' ? 'بدأت الرحلة' : 'Ride Started';
  String get notificationRideCompleted =>
      locale.languageCode == 'ar' ? 'اكتملت الرحلة' : 'Ride Completed';
  String get notificationRideCancelled =>
      locale.languageCode == 'ar' ? 'تم إلغاء الرحلة' : 'Ride Cancelled';

  String get notificationPaymentSuccessful =>
      locale.languageCode == 'ar' ? 'تم الدفع بنجاح' : 'Payment Successful';
  String get notificationPaymentFailed =>
      locale.languageCode == 'ar' ? 'فشل الدفع' : 'Payment Failed';

  String get notificationNewPromotion => locale.languageCode == 'ar'
      ? 'عرض ترويجي جديد متاح'
      : 'New Promotion Available';
  String get notificationPromotionExpiresSoon => locale.languageCode == 'ar'
      ? 'ينتهي العرض الترويجي قريباً'
      : 'Promotion expires soon';

  // Helper method for filter status messages
  String getFilterStatusName(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return filterAll;
      case 'completed':
        return filterCompleted;
      case 'pending':
        return filterPending;
      case 'canceled':
      case 'cancelled':
        return filterCanceled;
      case 'accepted':
        return filterAccepted;
      default:
        return filterAll;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
