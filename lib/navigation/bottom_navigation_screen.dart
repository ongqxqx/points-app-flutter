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
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure widgets are initialized before running async code
  // Initialize Firebase app
  await Firebase.initializeApp(); // This initializes the default Firebase app
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    //print('Custom error handler: ${details.exception}');
  };
  runApp(BottomNavigationScreen());
}

class BottomNavigationScreen extends StatelessWidget {
  //const BottomNavigationScreen({super.key});
  //static final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: TranslationService(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      home: MainPage(),//(key: mainPageKey),
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
  int _selectedIndex = 0;
  Widget _currentPage = HomeScreen(); // 初始为占位符
  List<String> _appBarTitles = ['home'.tr, 'scanQR'.tr, 'profile'.tr];
  bool _isOnboarding = false;

  // void updateCurrentPage(Widget newPage) {
  //   setState(() {
  //     _currentPage = newPage;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _currentPage = HomeScreen();

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
                                  OnboardingSignInUpScreen()));
                    });
                    _currentPage = HomeScreen();
                    _selectedIndex = 0;
                  } else {
                    _currentPage = HomeScreen();
                    _selectedIndex = 0; // 重置选中的导航项
                  }
                  _isOnboarding = true;
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
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentPage = HomeScreen();
          break;
        case 1:
          _currentPage = QRCodeScreen(); // 假设 ScanPage 是您定义的页面
          break;
        case 2:
          if (FirebaseAuth.instance.currentUser != null &&
              !FirebaseAuth.instance.currentUser!.isAnonymous) {
            _currentPage = ProfileWithSignedInScreen();
          } else {
            _currentPage = SignInUpScreen(); //ProfileWithoutSignInDart();
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
          : null, // Set to null to disable AppBar
      body: _currentPage,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _navBarItems,
        //backgroundColor: Color(0xFFF26101), // 更改背景颜色
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
