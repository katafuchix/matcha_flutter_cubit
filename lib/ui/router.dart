import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/event_tracking.dart';
import 'app_routes.dart';
import 'route_args.dart';
import 'routes/block_list/block_list_screen.dart';
import 'routes/favorite_list/favorite_list_screen.dart';
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

// ---------------------------------------------------------------------------
// Transition helpers
// ---------------------------------------------------------------------------
CustomTransitionPage<T> _bottomSlide<T>(Widget child, GoRouterState state) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );

CustomTransitionPage<T> _rightSlide<T>(Widget child, GoRouterState state) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------
final appRouter = GoRouter(
  initialLocation: AppRoutes.launch,
  observers: [_AnalyticsObserver()],
  routes: [
    GoRoute(
      path: AppRoutes.launch,
      builder: (_, __) => LaunchScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      pageBuilder: (_, state) => _bottomSlide(SignInScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (_, state) =>
          _bottomSlide(HomeScreen(deepLink: state.extra as String?), state),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (_, state) {
        final args = state.extra as ProfileScreenArgs;
        return _bottomSlide(
            ProfileScreen(profile: args.profile, isMe: args.isMe), state);
      },
    ),
    GoRoute(
      path: AppRoutes.messageRoom,
      pageBuilder: (_, state) {
        final args = state.extra as MessageRoomScreenArgs;
        return _bottomSlide(
            MessageRoomScreen(
                roomId: args.roomId,
                myProfile: args.myProfile,
                targetProfile: args.targetProfile),
            state);
      },
    ),
    GoRoute(
      path: AppRoutes.myPage,
      pageBuilder: (_, state) => _bottomSlide(MyPageScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.setting,
      pageBuilder: (_, state) => _rightSlide(SettingScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.searchCondition,
      pageBuilder: (_, state) {
        final args = state.extra as SearchConditionScreenArgs;
        return _bottomSlide(
            SearchConditionScreen(
                showSexField: args.showSexField,
                currentCondition: args.currentCondition),
            state);
      },
    ),
    GoRoute(
      path: AppRoutes.multiChoice,
      pageBuilder: (_, state) {
        final args = state.extra as MultiChoiceScreenArgs;
        return _bottomSlide(
            MultiChoiceScreen(title: args.title, items: args.items), state);
      },
    ),
    GoRoute(
      path: AppRoutes.notificationContents,
      pageBuilder: (_, state) {
        final args = state.extra as NotificationContentsScreenArgs;
        return _bottomSlide(
            NotificationContentsScreen(
                notificationId: args.notificationId,
                notificationType: args.notificationType,
                title: args.title),
            state);
      },
    ),
    GoRoute(
      path: AppRoutes.pointHistory,
      pageBuilder: (_, state) => _rightSlide(PointHistoryScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.favoriteList,
      pageBuilder: (_, state) => _bottomSlide(FavoriteListScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.blockList,
      pageBuilder: (_, state) => _bottomSlide(BlockListScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.registerEmail,
      pageBuilder: (_, state) => _rightSlide(RegisterEmailScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.registerImage,
      pageBuilder: (_, state) => _rightSlide(
          RegisterImageScreen(profileImageUrl: state.extra as String?), state),
    ),
    GoRoute(
      path: AppRoutes.inquiry,
      pageBuilder: (_, state) => _rightSlide(InquiryScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.simpleText,
      pageBuilder: (_, state) {
        final args = state.extra as SimpleTextScreenArgs;
        return _rightSlide(
            SimpleTextScreen(title: args.title, text: args.text), state);
      },
    ),
    GoRoute(
      path: AppRoutes.simpleImage,
      pageBuilder: (_, state) {
        final args = state.extra as SimpleImageScreenArgs;
        return _bottomSlide(
            SimpleImageScreen(title: args.title, url: args.url, image: args.image),
            state);
      },
    ),
  ],
);

class _AnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    final name = route.settings.name;
    if (name != null) AppEvent.sendPushEvent(name);
  }
}
