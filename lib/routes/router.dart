import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: SignInRoute.page, path: '/sign-in'),
        AutoRoute(page: SignUpRoute.page, path: '/sign-up'),
        AutoRoute(page: UserDataRoute.page, path: '/user-data'),
        AutoRoute(
          page: MyPhotoRoute.page,
          path: '/my-photo',
          fullscreenDialog: true,
          type: const RouteType.custom(transitionsBuilder: TransitionsBuilders.slideBottom, durationInMilliseconds: 200),
        ),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: ConditionerDetailRoute.page, path: '/conditioner-detail'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
      ];
}
