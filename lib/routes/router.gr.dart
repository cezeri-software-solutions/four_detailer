// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
import 'package:four_detailer/1_presentation/auth/sign_in_screen.dart' as _i7;
import 'package:four_detailer/1_presentation/auth/sign_up_screen.dart' as _i8;
import 'package:four_detailer/1_presentation/auth/user_data_screen.dart'
    as _i10;
import 'package:four_detailer/1_presentation/drawer/branches/branche_detail/branch_detail_screen.dart'
    as _i1;
import 'package:four_detailer/1_presentation/drawer/branches/branches_overview/branches_overview_screen.dart'
    as _i2;
import 'package:four_detailer/1_presentation/drawer/conditioner/conditioner_detail_screen.dart'
    as _i3;
import 'package:four_detailer/1_presentation/drawer/settings/settings_screen.dart'
    as _i6;
import 'package:four_detailer/1_presentation/home_screen.dart' as _i4;
import 'package:four_detailer/1_presentation/splash_screen.dart' as _i9;
import 'package:four_detailer/core/widgets/my_photo_page.dart' as _i5;

/// generated route for
/// [_i1.BranchDetailScreen]
class BranchDetailRoute extends _i11.PageRouteInfo<BranchDetailRouteArgs> {
  BranchDetailRoute({
    _i12.Key? key,
    required String branchId,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          BranchDetailRoute.name,
          args: BranchDetailRouteArgs(
            key: key,
            branchId: branchId,
          ),
          initialChildren: children,
        );

  static const String name = 'BranchDetailRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BranchDetailRouteArgs>();
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

  final _i12.Key? key;

  final String branchId;

  @override
  String toString() {
    return 'BranchDetailRouteArgs{key: $key, branchId: $branchId}';
  }
}

/// generated route for
/// [_i2.BranchesOverviewScreen]
class BranchesOverviewRoute extends _i11.PageRouteInfo<void> {
  const BranchesOverviewRoute({List<_i11.PageRouteInfo>? children})
      : super(
          BranchesOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'BranchesOverviewRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.BranchesOverviewScreen();
    },
  );
}

/// generated route for
/// [_i3.ConditionerDetailScreen]
class ConditionerDetailRoute extends _i11.PageRouteInfo<void> {
  const ConditionerDetailRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ConditionerDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConditionerDetailRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.ConditionerDetailScreen();
    },
  );
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomeScreen();
    },
  );
}

/// generated route for
/// [_i5.MyPhotoPage]
class MyPhotoRoute extends _i11.PageRouteInfo<MyPhotoRouteArgs> {
  MyPhotoRoute({
    required List<String> urls,
    int initialIndex = 0,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
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

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyPhotoRouteArgs>();
      return _i5.MyPhotoPage(
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'MyPhotoRouteArgs{urls: $urls, initialIndex: $initialIndex, key: $key}';
  }
}

/// generated route for
/// [_i6.SettingsScreen]
class SettingsRoute extends _i11.PageRouteInfo<void> {
  const SettingsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i7.SignInScreen]
class SignInRoute extends _i11.PageRouteInfo<void> {
  const SignInRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.SignInScreen();
    },
  );
}

/// generated route for
/// [_i8.SignUpScreen]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashScreen();
    },
  );
}

/// generated route for
/// [_i10.UserDataScreen]
class UserDataRoute extends _i11.PageRouteInfo<void> {
  const UserDataRoute({List<_i11.PageRouteInfo>? children})
      : super(
          UserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserDataRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.UserDataScreen();
    },
  );
}
