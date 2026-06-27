import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import 'router.dart';
import 'routes/home/home_change_notifier.dart';

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppColors colors = MaleColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchingNotifier()),
        ChangeNotifierProvider(create: (_) => BbsNotifier()),
        ChangeNotifierProvider(create: (_) => MatchingProfileNotifier()),
        ChangeNotifierProvider(create: (_) => FavoriteNotifier()),
        ChangeNotifierProvider(create: (_) => IncommingFavoriteNotifier()),
        ChangeNotifierProvider(create: (_) => NotificationNotifier()),
        ChangeNotifierProvider(create: (_) => MyProfileNotifier()),
        ChangeNotifierProvider(create: (_) => VisitorNotifier()),
        ChangeNotifierProvider(create: (_) => BlockNotifier()),
      ],
      child: MaterialApp.router(
        title: 'matcha',
        theme: ThemeData(
          primaryColor: colors.primary,
          colorScheme: ColorScheme.light(
            primary: colors.primary,
            secondary: colors.accent,
          ),
          fontFamily: 'NotoSansJP-Regular',
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
