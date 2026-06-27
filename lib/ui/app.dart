import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/colors.dart';
import 'my_navigator.dart';
import 'routes/block_list/block_list_screen.dart';
import 'routes/favorite_list/favorite_list_screen.dart';
import 'routes/home/home_change_notifier.dart';
import 'routes/home/home_screen.dart';
import 'routes/inquiry/inquiry_screen.dart';
import 'routes/launch/launch_screen.dart';
import 'routes/message_room/message_room_screen.dart';
import 'routes/my_page/my_page_screen.dart';
import 'routes/notification_contents/notification_contents_screen.dart';
import 'routes/point_hisotry/point_history_screen.dart';
import 'routes/profile/profile_screen.dart';
import 'routes/register_email/register_email_screen.dart';
import 'routes/register_image/register_image_screen.dart';
import 'routes/search_condition/multi_choice_screen.dart';
import 'routes/search_condition/search_condition_screen.dart';
import 'routes/setting/setting_screen.dart';
import 'routes/sign_in/sign_in_screen.dart';
import 'routes/simple_text/simple_image_screen.dart';
import 'routes/simple_text/simple_text_screen.dart';

typedef CreatePage = Widget Function();
// FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppColors colors = MaleColors();

    return MaterialApp(
      title: 'matcha',
      theme: ThemeData(
          primaryColor: colors.primary,
          colorScheme: ColorScheme.light(
            primary: colors.primary,
            secondary: colors.accent,
          ),
          fontFamily: "NotoSansJP-Regular"),
      home: LaunchScreen(),
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: analytics),
      // ],
    );
  }
}

class MyApp extends StatefulWidget {
  final bool doneSignIn;
  final String? deepLink;

  MyApp({required this.doneSignIn, this.deepLink});

  @override
  _MyAppState createState() =>
      _MyAppState(doneSignIn: doneSignIn, deepLink: deepLink);
}

class _MyAppState extends State<MyApp> {
  final bool doneSignIn;
  final String? deepLink;

  _MyAppState({required this.doneSignIn, this.deepLink});

  @override
  Widget build(BuildContext context) {
    AppColors colors = MaleColors();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SearchingNotifier>(
            create: (_) => SearchingNotifier(),
          ),
          ChangeNotifierProvider<BbsNotifier>(
            create: (_) => BbsNotifier(),
          ),
          ChangeNotifierProvider<MatchingProfileNotifier>(
            create: (_) => MatchingProfileNotifier(),
          ),
          ChangeNotifierProvider<FavoriteNotifier>(
            create: (_) => FavoriteNotifier(),
          ),
          ChangeNotifierProvider<IncommingFavoriteNotifier>(
            create: (_) => IncommingFavoriteNotifier(),
          ),
          ChangeNotifierProvider<NotificationNotifier>(
            create: (_) => NotificationNotifier(),
          ),
          ChangeNotifierProvider<MyProfileNotifier>(
            create: (_) => MyProfileNotifier(),
          ),
          ChangeNotifierProvider<VisitorNotifier>(
            create: (_) => VisitorNotifier(),
          ),
          ChangeNotifierProvider<BlockNotifier>(
            create: (_) => BlockNotifier(),
          )
        ],
        child: MaterialApp(
          title: 'matcha',
          theme: ThemeData(
              primaryColor: colors.primary,
              colorScheme: ColorScheme.light(
                primary: colors.primary,
                secondary: colors.accent,
              ),
              fontFamily: "NotoSansJP-Regular"),
          home: _createHome(deepLink),
          onGenerateRoute: (RouteSettings settings) {
            assert(
                settings.arguments == null || settings.arguments is ScreenArgs);
            CreatePage createPage = _createScreen(
                    context, settings.arguments as ScreenArgs?)[settings.name]
                as CreatePage;
            return _SlideRoute<Object>(
                page: createPage, args: settings.arguments as ScreenArgs);
          },
          // navigatorObservers: [
          //   FirebaseAnalyticsObserver(analytics: analytics),
          // ],
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   const Locale('en', 'US'), // English
          //   const Locale('de', 'DE'), // German
          //   // const Locale("ja"),
          // ],
        ));
  }

  Widget _createHome(String? deepLink) {
    return doneSignIn
        ? HomeScreen(
            deepLink: deepLink,
          )
        : SignInScreen();
  }

  Map<String, CreatePage> _createScreen(
      BuildContext context, ScreenArgs? args) {
    return {
      Routes.signIn: () => SignInScreen(),
      Routes.home: () => HomeScreen(),
      Routes.myPage: () => MyPageScreen(),
      Routes.setting: () => SettingScreen(),
      Routes.profile: () => ProfileScreen(args: args!),
      Routes.registerEmail: () => RegisterEmailScreen(),
      Routes.registerImage: () => RegisterImageScreen(args: args!),
      Routes.messageRoom: () => MessageRoomScreen(args: args!),
      Routes.searchCondition: () => SearchConditionScreen(args: args!),
      Routes.multiChoice: () => MultiChoiceScreen(args: args!),
      Routes.notificationContents: () =>
          NotificationContentsScreen(args: args!),
      Routes.pointHistory: () => PointHistoryScreen(),
      Routes.favoriteList: () => FavoriteListScreen(),
      Routes.blockList: () => BlockListScreen(),
      Routes.inquiry: () => InquiryScreen(),
      Routes.simpleText: () => SimpleTextScreen(args: args!),
      Routes.simpleImage: () => SimpleImageScreen(args: args!),
    };
  }
}

class Routes {
  static const String signIn = '/sign_in';
  static const String home = '/home';
  static const String myPage = '/home/my_page';
  static const String setting = '/home/setting';
  static const String profile = '/home/profile';
  static const String registerEmail = '/home/my_page/register_email';
  static const String registerImage = '/home/my_page/register_image';
  static const String messageRoom = '/home/message_room';
  static const String searchCondition = '/home/search_condition';
  static const String multiChoice = '/home/multi_choice';
  static const String notificationContents = '/home/notification_contents';
  static const String pointHistory = '/home/point_history';
  static const String favoriteList = '/home/favorite_list';
  static const String blockList = '/home/block_list';
  static const String inquiry = '/home/inquiry';
  static const String simpleText = '/simple_text';
  static const String simpleImage = '/simple_image';
}

class _SlideRoute<T> extends PageRouteBuilder<T> {
  final CreatePage page;
  final ScreenArgs args;

  _SlideRoute({required this.page, required this.args})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page(),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset(_dxFrom(args), _dyFrom(args)),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

  static double _dxFrom(ScreenArgs args) {
    PageOpenType? type = MyNavigator.getPageOpenType(args);
    if (type == null || type == PageOpenType.PUSH)
      return 0;
    else
      return 1;
  }

  static double _dyFrom(ScreenArgs args) {
    PageOpenType? type = MyNavigator.getPageOpenType(args);
    if (type == null || type == PageOpenType.PUSH)
      return 1;
    else
      return 0;
  }
}
