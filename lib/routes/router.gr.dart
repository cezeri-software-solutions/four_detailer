// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:four_detailer/1_presentation/auth/sign_in_screen.dart' as _i11;
import 'package:four_detailer/1_presentation/auth/sign_up_screen.dart' as _i12;
import 'package:four_detailer/1_presentation/auth/user_data_screen.dart'
    as _i14;
import 'package:four_detailer/1_presentation/drawer/branches/branche_detail/branch_detail_screen.dart'
    as _i1;
import 'package:four_detailer/1_presentation/drawer/branches/branches_overview/branches_overview_screen.dart'
    as _i2;
import 'package:four_detailer/1_presentation/drawer/conditioners/conditioner_detail/conditioner_detail_screen.dart'
    as _i3;
import 'package:four_detailer/1_presentation/drawer/conditioners/conditioners_overview/conditioners_overview_screen.dart'
    as _i4;
import 'package:four_detailer/1_presentation/drawer/customers/customer_detail/customer_detail_screen.dart'
    as _i5;
import 'package:four_detailer/1_presentation/drawer/customers/customers_overview/customers_overview_screen.dart'
    as _i6;
import 'package:four_detailer/1_presentation/drawer/settings/settings_screen.dart'
    as _i10;
import 'package:four_detailer/1_presentation/home_screen.dart' as _i7;
import 'package:four_detailer/1_presentation/splash_screen.dart' as _i13;
import 'package:four_detailer/core/widgets/my_photo_page.dart' as _i8;
import 'package:four_detailer/routes/root_layout_route.dart' as _i9;

/// generated route for
/// [_i1.BranchDetailScreen]
class BranchDetailRoute extends _i15.PageRouteInfo<BranchDetailRouteArgs> {
  BranchDetailRoute({
    _i16.Key? key,
    required String branchId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          BranchDetailRoute.name,
          args: BranchDetailRouteArgs(
            key: key,
            branchId: branchId,
          ),
          rawPathParams: {'branchId': branchId},
          initialChildren: children,
        );

  static const String name = 'BranchDetailRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BranchDetailRouteArgs>(
          orElse: () => BranchDetailRouteArgs(
              branchId: pathParams.getString('branchId')));
      return _i1.BranchDetailScreen(
        key: args.key,
        branchId: args.branchId,
      );
    },
  );
}

class BranchDetailRouteArgs {
  const BranchDetailRouteArgs({
    this.key,
    required this.branchId,
  });

  final _i16.Key? key;

  final String branchId;

  @override
  String toString() {
    return 'BranchDetailRouteArgs{key: $key, branchId: $branchId}';
  }
}

/// generated route for
/// [_i2.BranchesOverviewScreen]
class BranchesOverviewRoute extends _i15.PageRouteInfo<void> {
  const BranchesOverviewRoute({List<_i15.PageRouteInfo>? children})
      : super(
          BranchesOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'BranchesOverviewRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i2.BranchesOverviewScreen();
    },
  );
}

/// generated route for
/// [_i3.ConditionerDetailScreen]
class ConditionerDetailRoute
    extends _i15.PageRouteInfo<ConditionerDetailRouteArgs> {
  ConditionerDetailRoute({
    _i16.Key? key,
    required String conditionerId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ConditionerDetailRoute.name,
          args: ConditionerDetailRouteArgs(
            key: key,
            conditionerId: conditionerId,
          ),
          rawPathParams: {'conditionerId': conditionerId},
          initialChildren: children,
        );

  static const String name = 'ConditionerDetailRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ConditionerDetailRouteArgs>(
          orElse: () => ConditionerDetailRouteArgs(
              conditionerId: pathParams.getString('conditionerId')));
      return _i3.ConditionerDetailScreen(
        key: args.key,
        conditionerId: args.conditionerId,
      );
    },
  );
}

class ConditionerDetailRouteArgs {
  const ConditionerDetailRouteArgs({
    this.key,
    required this.conditionerId,
  });

  final _i16.Key? key;

  final String conditionerId;

  @override
  String toString() {
    return 'ConditionerDetailRouteArgs{key: $key, conditionerId: $conditionerId}';
  }
}

/// generated route for
/// [_i4.ConditionersOverviewScreen]
class ConditionersOverviewRoute extends _i15.PageRouteInfo<void> {
  const ConditionersOverviewRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ConditionersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConditionersOverviewRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i4.ConditionersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i5.CustomerDetailScreen]
class CustomerDetailRoute extends _i15.PageRouteInfo<CustomerDetailRouteArgs> {
  CustomerDetailRoute({
    _i16.Key? key,
    required String? customerId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          CustomerDetailRoute.name,
          args: CustomerDetailRouteArgs(
            key: key,
            customerId: customerId,
          ),
          rawPathParams: {'customerId': customerId},
          initialChildren: children,
        );

  static const String name = 'CustomerDetailRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CustomerDetailRouteArgs>(
          orElse: () => CustomerDetailRouteArgs(
              customerId: pathParams.optString('customerId')));
      return _i5.CustomerDetailScreen(
        key: args.key,
        customerId: args.customerId,
      );
    },
  );
}

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({
    this.key,
    required this.customerId,
  });

  final _i16.Key? key;

  final String? customerId;

  @override
  String toString() {
    return 'CustomerDetailRouteArgs{key: $key, customerId: $customerId}';
  }
}

/// generated route for
/// [_i6.CustomersOverviewScreen]
class CustomersOverviewRoute extends _i15.PageRouteInfo<void> {
  const CustomersOverviewRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CustomersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomersOverviewRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i6.CustomersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeScreen();
    },
  );
}

/// generated route for
/// [_i8.MyPhotoPage]
class MyPhotoRoute extends _i15.PageRouteInfo<MyPhotoRouteArgs> {
  MyPhotoRoute({
    required List<String> urls,
    int initialIndex = 0,
    _i16.Key? key,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          MyPhotoRoute.name,
          args: MyPhotoRouteArgs(
            urls: urls,
            initialIndex: initialIndex,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MyPhotoRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyPhotoRouteArgs>();
      return _i8.MyPhotoPage(
        urls: args.urls,
        initialIndex: args.initialIndex,
        key: args.key,
      );
    },
  );
}

class MyPhotoRouteArgs {
  const MyPhotoRouteArgs({
    required this.urls,
    this.initialIndex = 0,
    this.key,
  });

  final List<String> urls;

  final int initialIndex;

  final _i16.Key? key;

  @override
  String toString() {
    return 'MyPhotoRouteArgs{urls: $urls, initialIndex: $initialIndex, key: $key}';
  }
}

/// generated route for
/// [_i9.RootLayoutRoute]
class RootLayoutRoute extends _i15.PageRouteInfo<void> {
  const RootLayoutRoute({List<_i15.PageRouteInfo>? children})
      : super(
          RootLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootLayoutRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i9.RootLayoutRoute();
    },
  );
}

/// generated route for
/// [_i10.SettingsScreen]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i10.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i11.SignInScreen]
class SignInRoute extends _i15.PageRouteInfo<void> {
  const SignInRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i11.SignInScreen();
    },
  );
}

/// generated route for
/// [_i12.SignUpScreen]
class SignUpRoute extends _i15.PageRouteInfo<void> {
  const SignUpRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i12.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i13.SplashScreen]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.SplashScreen();
    },
  );
}

/// generated route for
/// [_i14.UserDataScreen]
class UserDataRoute extends _i15.PageRouteInfo<void> {
  const UserDataRoute({List<_i15.PageRouteInfo>? children})
      : super(
          UserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserDataRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i14.UserDataScreen();
    },
  );
}
