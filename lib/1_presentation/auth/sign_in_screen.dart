import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '/3_domain/repositories/auth_repository.dart';
import '/constants.dart';
import '/core/core.dart';
import '/failures/failures.dart';
import '/routes/router.gr.dart';
import 'widgets/auth_text_field.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isHidden = true;
  bool _isLoading = false;
  bool _isFirstTimeSubmitted = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = context.brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _isFirstTimeSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.onUnfocus,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(context.l10n.sign_in_welcome, style: context.textTheme.displayMedium),
                      Gaps.h32,
                      Image.asset(isLightMode ? 'assets/logo/logo_advertised_black.png' : 'assets/logo/logo_advertised_white.png', width: 250),
                      Gaps.h42,
                      AuthTextField(
                        controller: _emailController,
                        hintText: context.l10n.email,
                        prefixIcon: const Icon(Icons.email),
                        validator: (email) => validateEmail(email),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                      ),
                      Gaps.h16,
                      AuthTextField(
                        controller: _passwordController,
                        hintText: context.l10n.password,
                        prefixIcon: const Icon(Icons.vpn_key),
                        validator: (pw) => validatePassword(pw),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        obscureText: _isHidden,
                        onFieldSubmitted: _isLoading ? null : (_) => _onSignInPressed(),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => setState(() => _isHidden = !_isHidden),
                          child: Icon(_isHidden ? Icons.visibility : Icons.visibility_off, color: context.colorScheme.outline),
                        ),
                      ),
                      Gaps.h16,
                      Visibility.maintain(visible: _isLoading, child: const LinearProgressIndicator()),
                      Gaps.h16,
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _onSignInPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(context.l10n.login, style: context.textTheme.headlineSmall),
                        ),
                      ),
                      Gaps.h54,
                      TextButton(
                        onPressed: () {}, // TODO: Forgot password screen
                        child: Text(context.l10n.sign_in_forgotPassword,
                            style: context.textTheme.bodyLarge!.copyWith(color: context.colorScheme.primary)),
                      ),
                      Gaps.h54,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.sign_in_noAccountYet),
                          TextButton(
                            onPressed: () => context.router.push(const SignUpRoute()),
                            child: Text(context.l10n.sign_up, style: context.textTheme.bodyLarge!.copyWith(color: context.colorScheme.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInPressed() async {
    setState(() => _isFirstTimeSubmitted = true);

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authRepo = GetIt.I<AuthRepository>();

      await authRepo.signOut();

      final response = await authRepo.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.isLeft() && mounted) {
        showMyDialogAlert(
          context: context,
          title: context.l10n.error,
          content: switch (response.getLeft()) {
            final AuthServerFailure _ => context.l10n.auth_failure_onDefaultFailure,
            final WrongEmailOrPasswordFailure _ => context.l10n.auth_failure_wrongEmailOrPasswordFailure,
            final EmailNotConfirmedFailure _ => context.l10n.auth_failure_emailNotConfirmedFailure,
            (_) => context.l10n.auth_failure_onDefaultFailure,
          },
        );

        setState(() => _isLoading = false);

        return;
      }

      if (mounted) context.router.replaceAll([const SplashRoute()]);

      setState(() => _isLoading = false);
    }
  }
}
