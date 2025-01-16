import 'package:auto_route/auto_route.dart';

import 'auth_guard.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

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
            AutoRoute(page: ConditionersOverviewRoute.page, path: 'conditioners-overview'),
            AutoRoute(page: ConditionerDetailRoute.page, path: 'conditioner-detail/:conditionerId'),
            AutoRoute(page: BranchesOverviewRoute.page, path: 'branches-overview'),
            AutoRoute(page: BranchDetailRoute.page, path: 'branch-detail/:branchId'),
            AutoRoute(page: ServicesOverviewRoute.page, path: 'services-overview'),
            AutoRoute(page: ServiceDetailRoute.page, path: 'service-detail/:serviceId'),
            AutoRoute(page: CategoriesOverviewRoute.page, path: 'categories-overview'),
            AutoRoute(page: TSVehicleSizesOverviewRoute.page, path: 'template-services-vehicle-sizes-overview'),
            AutoRoute(page: TSContaminationLevelsOverviewRoute.page, path: 'template-services-contamination-levels-overview'),
            AutoRoute(page: TSTodosOverviewRoute.page, path: 'template-services-todos-overview'),
            AutoRoute(page: CustomersOverviewRoute.page, path: 'customers-overview'),
            AutoRoute(page: CustomerDetailRoute.page, path: 'customer-detail/:customerId'),
            AutoRoute(page: SettingsRoute.page, path: 'settings'),
            RedirectRoute(path: '*', redirectTo: 'home'),
          ],
        ),
      ];
}
