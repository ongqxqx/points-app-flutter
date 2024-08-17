import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/onboard/onboarding_sign_in_up_screen.dart';
import 'package:points/qr_code/qr_code_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../home/home_screen.dart';
import '../onboard/onboarding_screen.dart';
import '../profile/profile_with_signed_in.dart';
import '../profile/sign_in_up_screen.dart';
import '../translation_service.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized before running async code
  await Firebase.initializeApp(); // Initialize the default Firebase app
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'), // Configure App Check for web
    androidProvider: AndroidProvider.debug, // Configure App Check for Android
    appleProvider: AppleProvider.appAttest, // Configure App Check for iOS
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details); // Custom error handling
    //print('Custom error handler: ${details.exception}');
  };
  runApp(BottomNavigationScreen()); // Start the app with BottomNavigationScreen
}

class BottomNavigationScreen extends StatelessWidget {
  //const BottomNavigationScreen({super.key});
  //static final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: TranslationService(), // Set up internationalization
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      home: MainPage(), // Main page of the app
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.title = 'Points'}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Track the selected index in the bottom navigation bar
  Widget _currentPage = HomeScreen(); // Default page is HomeScreen
  List<String> _appBarTitles = ['home'.tr, 'scanQR'.tr, 'profile'.tr]; // Titles for the AppBar
  bool _isOnboarding = false; // Track if onboarding is completed

  // void updateCurrentPage(Widget newPage) {
  //   setState(() {
  //     _currentPage = newPage;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _currentPage = HomeScreen(); // Initialize with HomeScreen

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && !_isOnboarding) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(
              onCompleted: (bool createAccount) {
                setState(() {
                  if (createAccount) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OnboardingSignInUpScreen())); // Navigate to sign-in/up screen
                    });
                    _currentPage = HomeScreen(); // Set default page
                    _selectedIndex = 0; // Reset selected index
                  } else {
                    _currentPage = HomeScreen(); // Set default page
                    _selectedIndex = 0; // Reset selected index
                  }
                  _isOnboarding = true; // Mark onboarding as completed
                });
              },
            ),
          ),
        );
      }
    });
  }

  List<SalomonBottomBarItem> get _navBarItems => [
    SalomonBottomBarItem(
      icon: Icon(_selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined),
      title: Text('home'.tr),
      selectedColor: Color(0xFFF26101),
      unselectedColor: Color(0xFF003354),
    ),
    SalomonBottomBarItem(
      icon: Icon(_selectedIndex == 1 ? Icons.qr_code_scanner_rounded : Icons.qr_code_rounded),
      title: Text('scanQR'.tr),
      selectedColor: Color(0xFFF26101),
      unselectedColor: Color(0xFF003354),
    ),
    SalomonBottomBarItem(
      icon: Icon(_selectedIndex == 2 ? Icons.person_rounded : Icons.person_outline_rounded),
      title: Text('profile'.tr),
      selectedColor: Color(0xFFF26101),
      unselectedColor: Color(0xFF003354),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
      switch (index) {
        case 0:
          _currentPage = HomeScreen(); // Set HomeScreen for index 0
          break;
        case 1:
          _currentPage = QRCodeScreen(); // Set QRCodeScreen for index 1
          break;
        case 2:
          if (FirebaseAuth.instance.currentUser != null &&
              !FirebaseAuth.instance.currentUser!.isAnonymous) {
            _currentPage = ProfileWithSignedInScreen(); // Set ProfileWithSignedInScreen if signed in
          } else {
            _currentPage = SignInUpScreen(); // Set SignInUpScreen if not signed in
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 0
          ? AppBar(
        title: Text(_appBarTitles[_selectedIndex].tr),
      )
          : null, // AppBar is shown only if selectedIndex is not 0
      body: _currentPage, // Display the current page
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex, // Current index for the bottom navigation bar
        onTap: _onItemTapped, // Handle tap events
        items: _navBarItems, // Navigation bar items
        //backgroundColor: Color(0xFFF26101), // Uncomment to change the background color
        duration: Duration(milliseconds: 1500), // Duration for the animation
      ),
    );
  }
}
