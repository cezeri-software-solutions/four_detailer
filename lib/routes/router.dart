import 'package:auto_route/auto_route.dart';

import 'auth_guard.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super();

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
        AutoRoute(
          path: '/app',
          guards: [AuthGuard()],
          page: RootLayoutRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home'),
            AutoRoute(page: ConditionerDetailRoute.page, path: 'conditioner-detail'),
            AutoRoute(page: BranchesOverviewRoute.page, path: 'branches-overview'),
            AutoRoute(page: BranchDetailRoute.page, path: 'branch-detail/:branchId'),
            AutoRoute(page: SettingsRoute.page, path: 'settings'),
            RedirectRoute(path: '*', redirectTo: 'home'),
          ],
        ),
      ];
}
