import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/3_domain/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

import '../2_application/conditioner_detail/conditioner_detail_bloc.dart';
import '../core/core.dart';
import '../failures/failures.dart';
import '../injection.dart';
import '../routes/router.gr.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = GetIt.I<AuthRepository>();
    // authRepo.signOut();
    final isUserSignedIn = authRepo.checkIfUserIsSignedIn();

    final conditionerDetailBloc = sl<ConditionerDetailBloc>();

    isUserSignedIn ? conditionerDetailBloc.add(GetCurrentConditionerEvent()) : context.router.replaceAll([const SignInRoute()]);
    // final settingsBloc = sl<MainSettingsBloc>();

    return BlocProvider<ConditionerDetailBloc>(
      create: (context) => conditionerDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConditionerDetailBloc, ConditionerDetailState>(
            listenWhen: (p, c) => p.fosConditionerOnObserveOption != c.fosConditionerOnObserveOption,
            listener: (context, state) {
              state.fosConditionerOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failure.runtimeType == EmptyFailure
                      ? context.router.replaceAll([const UserDataRoute()])
                      : null, // TODO: Speichere den Fehler in Firebase und kontaktiere den User
                  (conditioner) {
                    context.router.replaceAll([const HomeRoute()]);
                    // if (conditioner.name != Conditioner.empty().name) {
                    //   context.read<MainSettingsBloc>().add(GetMainSettingsEvent());
                    // } else {
                    //   context.router.replaceAll([const RegisterUserDataRoute()]);
                    // }
                  },
                ),
              );
            },
          ),
        ],
        child: const Scaffold(body: Center(child: MyLoadingIndicator())),
      ),
    );
  }
}
