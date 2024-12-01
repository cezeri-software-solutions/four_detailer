import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/core/core.dart';
import '../../3_domain/repositories/auth_repository.dart';
import '../../constants.dart';
import '../../failures/failures.dart';
import '../../routes/router.gr.dart';
import 'widgets/auth_text_field.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final StreamSubscription<AuthState> _authSubscription;

  bool _isHidden = true;
  bool _isHiddenConfirm = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null && mounted) context.router.replaceAll([const SplashRoute()]);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _authSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _passwordConfirmFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = context.brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(isLightMode ? 'assets/logo/logo_black.png' : 'assets/logo/logo_white.png', width: 120, height: 120),
                      Gaps.h32,
                      Text(context.l10n.sign_up_content, style: context.textTheme.titleSmall, textAlign: TextAlign.center),
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
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.password],
                        obscureText: _isHidden,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordConfirmFocusNode),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => setState(() => _isHidden = !_isHidden),
                          child: Icon(_isHidden ? Icons.visibility : Icons.visibility_off, color: context.colorScheme.outline),
                        ),
                      ),
                      Gaps.h16,
                      AuthTextField(
                        controller: _passwordConfirmController,
                        focusNode: _passwordConfirmFocusNode,
                        hintText: context.l10n.sign_up_confirmPassword,
                        prefixIcon: const Icon(Icons.vpn_key),
                        validator: (pw) => validatePassword(pw),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        obscureText: _isHiddenConfirm,
                        onFieldSubmitted: _isLoading ? null : (_) => _onSignUpPressed(),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => setState(() => _isHiddenConfirm = !_isHiddenConfirm),
                          child: Icon(_isHiddenConfirm ? Icons.visibility : Icons.visibility_off, color: context.colorScheme.outline),
                        ),
                      ),
                      Gaps.h16,
                      Visibility.maintain(visible: _isLoading, child: const LinearProgressIndicator()),
                      Gaps.h16,
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _onSignUpPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(context.l10n.sign_up, style: context.textTheme.headlineSmall),
                        ),
                      ),
                      Gaps.h32,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.sign_up_alreadyHaveAccount),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              context.l10n.sign_up_backToSignIn,
                              style: context.textTheme.bodyLarge!.copyWith(color: context.colorScheme.primary),
                            ),
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

  void _onSignUpPressed() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      showMyDialogAlert(context: context, title: context.l10n.error, content: context.l10n.sign_up_passwordsDontMatch);
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authRepo = GetIt.I<AuthRepository>();

      final response = await authRepo.registerWithEmailAndPassword(
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
      }

      if (!mounted) return;
      showMyDialogInfo(
        context: context,
        title: context.l10n.sign_up_congratulations,
        content: context.l10n.sign_up_checkEmail,
        canPop: false,
        showButton: false,
      );

      setState(() => _isLoading = false);
    }
  }
}
