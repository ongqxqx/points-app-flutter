import 'dart:ui';
import 'package:get/get.dart';
import 'package:points/languageSaved.dart';

class TranslationService extends Translations {
  // Default locale and fallback locale
  static final locale = Locale('en', 'US');
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages and their corresponding locales
  static final langs = ['English', '中文'];
  static final locales = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
//General
      'back': 'Back',
      'loading': 'Loading...',
      'pts': 'Pts',
//Authentication
      'signIn': 'Sign In',
      'signIn/signUp': 'Sign In / Sign Up',
      'signInSuccessful': 'Sign in successful',
      'signInWithGoogleAccount': 'Sign in with Google Account',
      'signOut': 'Sign Out',
//OnBoard
      'wouldYouLikeToCreateAnAccount':
      'Would you like to create an account?',
      'byCreatingAnAccount':
      'By creating an account, your data will be securely saved, allowing you to access it from multiple devices.',
      'createAnAccount': 'Create an account',
      'anAnonymousAccountHasBeenCreated':
      'An anonymous account has been created.',
      'UseAnAnonymousAccount': 'Use an anonymous account',
      'getStarted': 'Get Started',
//BottomNavigationScreen
      'home': 'Home',
      'scanQR': 'Scan QR',
      'profile': 'Profile',
//HomeScreen
      'rewards': 'Rewards',
//HomeHistory
      'history': 'History',
//HomeMyPoint
      'myPoints': 'My Points',
//HomeMyReward
      'myRewards': 'My Rewards',
//HomeMyRewardScreen
      'noRewardFound': 'No rewards found.',
      'qty': 'Qty',
//HomeProductList
      'noProductsAvailable': 'No products available.',
      'left': 'left(s)',
//HomeRewardViewAll
      'viewAll': 'View All',
//HomeUserName
      'anonymousUser': 'Anonymous User',
//ProductCategory
      'noCategoriesAvailable': 'No categories available',
//ProductDetail
      'yourPts': 'Your Pts',
      'confirmRedeem': 'Confirm Redeem',
      'lefts': 'left(s)',
      'signInRequired': 'Sign in required',
      'pleaseSignInToContinue': 'Please sign in to continue',
      'cancel': 'Cancel',
      'pleaseSignIn': 'Please sign in',
      'error': 'Error',
      'failedToObtainUserPoints,PleaseTryAgainLater':
      'Failed to obtain user points, please try again later',
      'confirm': 'Confirm',
      'failedToObtainProductPoints,PleaseTryAgainLater':
      'Failed to obtain product points, please try again later',
      'willDeduct': 'Will deduct',
      'remainingPtsAfterRedeem': 'remaining Pts after redeem',
      'insufficientPtsToRedeemThisItem':
      'Insufficient Pts to redeem this item',
      'unableToRetrieveUserData': 'Unable to retrieve user data',
      'redemptionFailed:InsufficientPts':
      'Redemption failed: Insufficient Pts',
      'redeemSuccessful': 'Redeem successful! ',
      'deducted': 'Deducted',
      'remaining': 'remaining',
      'redemptionFailed,PleaseTryAgainLater':
      'Redemption failed, please try again later',
//ProductScreen
      'allReward': 'All Rewards',
//ProductScreen
      'noProductsFound': 'No products found',
//ProfileConfigureScreen
      'accountSetting': 'Account Setting',
      'appSetting': 'App Setting',
      'signOutSuccessful': 'Sign out successful',
//AccountSettingEmail
      'email': 'Email',
      'bindEmail':
      'Please proceed with binding your email to your account.',
//AccountSettingGender
      'gender': 'Gender',
      //AccountSettingName
      'name': 'Name',
//AccountSettingPhoneNumber
      'phoneNumber': 'Phone Number',
//AccountSettingReferrerCode
      'referrerCode': 'Refer Code',
      'referralCode': 'Share Your Referral Code with Friends',
//AccountSettingScreen
      'save': 'Save',
//Other
      'hot': 'Hot',
      'cash': 'Cash',
      'drink': 'Drink',
      'food': 'Food',
      'transport': 'Transport',
      'hotProduct': 'Hot Rewards',
      'otherProduct': 'Other Rewards',
//BindingPhoneNumber
      'phoneNumberLinkedSuccessfully': 'Phone number linked successfully',
      'bindingPhoneNumber': 'Binding Phone Number',
      'countryCode': 'Country Code',
      //'phoneNumber': 'Phone Number',
      'verificationCodeSent': 'Verification code sent',
      'sendVerificationCode': 'Send Verification Code',
      'smsCode': 'SMS Code',
      'verify': 'Verify',
//BindingGoogleAccount
      'linkedWithGoogleAccountSuccessfully':
      'Linked with Google account successfully',
      'bindingGoogleAccount': 'Binding Google Account',
//SignInUpWithGoogle
      'anonymousAccountLinkedWithGoogleAccount':
      'Anonymous account linked with Google account',
      'accountConflict': 'Account Conflict',
      'googleAccountAlreadyInUse':
      'This Google account is already in use. Do you want to delete the anonymous account and continue with the Google account, or use another Google account?',
      'deleteAnonymousAccount': 'Delete Anonymous Account',
      'useAnotherGoogleAccount': 'Use Another Google Account',
    },
    'zh_CN': {
//General
      'back': '返回',
      'loading': '加载中...',
      'pts': '积分',
//Authentication
      'signIn': '登录',
      'signIn/signUp': '登录 / 注册',
      'signInSuccessful': '登录成功',
      'signInWithGoogleAccount': '使用谷歌账户登录',
      'signOut': '退出登录',
//OnBoard
      'wouldYouLikeToCreateAnAccount': '您想创建一个账户吗？',
      'byCreatingAnAccount':
      '创建账户后，您的数据将被安全保存，允许您从多个设备访问。',
      'createAnAccount': '创建账户',
      'anAnonymousAccountHasBeenCreated': '已创建匿名账户。',
      'UseAnAnonymousAccount': '使用匿名账户',
      'getStarted': '开始使用',
//BottomNavigationScreen
      'home': '主页',
      'scanQR': '扫描二维码',
      'profile': '个人资料',
//HomeScreen
      'rewards': '奖励',
//HomeHistory
      'history': '历史记录',
//HomeMyPoint
      'myPoints': '我的积分',
//HomeMyReward
      'myRewards': '我的奖励',
//HomeMyRewardScreen
      'noRewardFound': '未找到奖励。',
      'qty': '数量',
//HomeProductList
      'noProductsAvailable': '没有可用商品。',
      'left': '剩余',
//HomeRewardViewAll
      'viewAll': '查看全部',
//HomeUserName
      'anonymousUser': '匿名用户',
//ProductCategory
      'noCategoriesAvailable': '没有可用类别',
//ProductDetail
      'yourPts': '你的积分',
      'confirmRedeem': '确认兑换',
      'lefts': '剩余',
      'signInRequired': '需要登录',
      'pleaseSignInToContinue': '请登录以继续',
      'cancel': '取消',
      'pleaseSignIn': '请登录',
      'error': '错误',
      'failedToObtainUserPoints,PleaseTryAgainLater': '获取用户积分失败，请稍后再试',
      'confirm': '确认',
      'failedToObtainProductPoints,PleaseTryAgainLater': '获取商品积分失败，请稍后再试',
      'willDeduct': '将扣除',
      'remainingPtsAfterRedeem': '兑换后剩余积分',
      'insufficientPtsToRedeemThisItem': '积分不足，无法兑换该商品',
      'unableToRetrieveUserData': '无法获取用户数据',
      'redemptionFailed:InsufficientPts': '兑换失败：积分不足',
      'redeemSuccessful': '兑换成功！',
      'deducted': '已扣除',
      'remaining': '剩余',
      'redemptionFailed,PleaseTryAgainLater': '兑换失败，请稍后再试',
//ProductScreen
      'allReward': '所有奖励',
//ProductScreen
      'noProductsFound': '未找到商品',
//ProfileConfigureScreen
      'accountSetting': '账户设置',
      'appSetting': '应用设置',
      'signOutSuccessful': '退出登录成功',
//AccountSettingEmail
      'email': '电子邮箱',
      'bindEmail': '请绑定您的电子邮箱到账户。',
//AccountSettingGender
      'gender': '性别',
//AccountSettingName
      'name': '姓名',
//AccountSettingPhoneNumber
      'phoneNumber': '电话号码',
//AccountSettingReferrerCode
      'referrerCode': '推荐码',
      'referralCode': '与朋友分享您的推荐码',
//AccountSettingScreen
      'save': '保存',
//Other
      'hot': '热门',
      'cash': '现金',
      'drink': '饮品',
      'food': '食品',
      'transport': '交通',
      'hotProduct': '热门奖励',
      'otherProduct': '其他奖励',
//BindingPhoneNumber
      'phoneNumberLinkedSuccessfully': '电话号码绑定成功',
      'bindingPhoneNumber': '绑定电话号码',
      'countryCode': '国家代码',
      //'phoneNumber': '电话号码',
      'verificationCodeSent': '验证码已发送',
      'sendVerificationCode': '发送验证码',
      'smsCode': '短信验证码',
      'verify': '验证',
//BindingGoogleAccount
      'linkedWithGoogleAccountSuccessfully': '成功绑定 Google 账号',
      'bindingGoogleAccount': '绑定 Google 账号',
//SignInUpWithGoogle
      'anonymousAccountLinkedWithGoogleAccount': '匿名账户与 Google 账户已关联',
      'accountConflict': '账户冲突',
      'googleAccountAlreadyInUse':
      '该 Google 账户已被使用。您想要删除匿名账户并继续使用 Google 账户，还是使用其他 Google 账户？',
      'deleteAnonymousAccount': '删除匿名账户',
      'useAnotherGoogleAccount': '使用其他 Google 账户',
    },
  };

  // Instance of LanguageSaved to handle saving and loading language preferences
  final LanguageSaved _languageSaved = LanguageSaved();

  // Change the current locale based on the selected language
  void changeLocale(String lang) async {
    final locale = _getLocaleFromLanguage(lang);
    await _languageSaved.saveLanguageCode(locale.languageCode);
    Get.updateLocale(locale);
  }

  // Get the corresponding Locale object from the language string
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale ?? fallbackLocale;
  }

  // Load the saved locale from persistent storage and update the locale
  Future<void> loadSavedLocale() async {
    final savedLanguageCode = await _languageSaved.getLanguageCode();
    if (savedLanguageCode != null) {
      final locale = _getLocaleFromLanguageCode(savedLanguageCode);
      Get.updateLocale(locale);
    }
  }

  // Get the Locale object from the saved language code
  Locale _getLocaleFromLanguageCode(String languageCode) {
    for (final locale in locales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return fallbackLocale;
  }
}
