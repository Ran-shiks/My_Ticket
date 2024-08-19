import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_essentials_kit/widgets/two_way_binding_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/presentation/manager/blocs/sign_up/sign_up_bloc.dart';
import 'package:my_ticket/presentation/widgets/connectivity_widget.dart';

import '../../domain/use_cases/authentication_Interactor.dart';

@RoutePage()
class SignUpPage extends ConnectivityWidget implements AutoRouteWrapper {
  @override
  Widget connectedBuild(_) => BlocConsumer<SignUpBloc, SignUpState>(
      builder: (context, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: background,
              shadowColor: selected,
              title: Text(AppLocalizations.of(context)?.title_sign_up ?? " "),
            ),
            body: Container(
              color: background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 120.0, vertical: 40),
                    child: Expanded(
                        child: FittedBox(
                      fit: BoxFit.fill,
                      child: Transform.rotate(
                        angle: 35,
                        child: const FaIcon(FontAwesomeIcons.ticketAlt,
                            color: selected),
                      ),
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        _nameField(context, enabled: state is! SigningUpState),
                        const Divider(),
                        _surnameField(context,
                            enabled: state is! SigningUpState),
                        const Divider(),
                        _emailField(context, enabled: state is! SigningUpState),
                        const Divider(),
                        _passwordField(context,
                            enabled: state is! SigningUpState),
                      ],
                    ),
                  ),
                  const Divider(),
                  _signUpButton(context,
                      enabled: state is! SigningUpState),
                  _orDivider(context),
                  _googleLoginButton(context,
                      enabled: state is! SigningUpState),
                  const Divider(),
                  if (state is SigningUpState) _progress(),
                ],
              ),
            ),
          ),
      listener: (context, state) {
        _shouldCloseForSignedIn(context, state: state);
        _shouldShowErrorSignInDialog(context, state: state);
      });

  Widget _orDivider(BuildContext context) {
    const divider = Expanded(
        child: Divider(
      height: 0,
    ));
    return Row(
      children: [
        divider,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              AppLocalizations.of(context)?.label_or ?? " ",
              style: Theme.of(context).textTheme.bodySmall,
            )),
        divider,
      ],
    );
  }

  Widget _googleLoginButton(BuildContext context, {bool enabled = true}) =>
      enabled
          ? SignInButton(
              Buttons.Google,
              onPressed: () =>
                  context.read<SignUpBloc>().performSignUpWithGoogle(),
            )
          : Container();

  Widget _surnameField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
          binding: context.watch<SignUpBloc>().surnameBinding,
          builder: (context, controller, data, onChanged, error) => TextField(
                controller: controller,
                onChanged: onChanged,
                enabled: enabled,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  errorText: error?.localizedString(context),
                  hintText: AppLocalizations.of(context)?.label_surname,
                ),
              ));

  Widget _nameField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
          binding: context.watch<SignUpBloc>().nameBinding,
          builder: (context, controller, data, onChanged, error) => TextField(
                controller: controller,
                onChanged: onChanged,
                enabled: enabled,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  errorText: error?.localizedString(context),
                  hintText: AppLocalizations.of(context)?.label_name,
                ),
              ));

  Widget _progress() => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );

  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().emailbinding,
        builder: (context, controller, data, onChanged, error) => TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: error?.localizedString(context),
            hintText: AppLocalizations.of(context)?.label_email,
          ),
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().passwordBinding,
        builder: (context, controller, data, onChanged, error) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: enabled,
            obscureText: true,
            decoration: InputDecoration(
              errorText: error?.localizedString(context),
              hintText: AppLocalizations.of(context)?.label_password,
            ),
          ),
        ),
      );

  Widget _signUpButton(BuildContext context, {bool enabled = true}) {
    Widget _signUpButtonEnabled(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignUpBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );

    return _signUpButtonEnabled(context,
        function: (enabled) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: selected,
              disabledBackgroundColor: secondary,
              disabledForegroundColor: background,
            ),
            onPressed: enabled
                ? () => context.read<SignUpBloc>().performSignUp()
                : null,
            child: Text(AppLocalizations.of(context)?.action_sign_up ?? " ")));
  }

  /// Importante per autoroute
  @override
  Widget wrappedRoute(BuildContext context, {bool enabled = true}) =>
      BlocProvider(
        create: (context) => SignUpBloc(
          authInteractor: context.read<AuthInteractor>(),
        ),
        child: this,
      );

  ///-----------

  void _shouldCloseForSignedIn(
    BuildContext context, {
    required SignUpState state,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is SuccessSignUpstate) {
        context.router.popUntilRoot();
      }
    });
  }

  void _shouldShowErrorSignInDialog(
    BuildContext context, {
    required SignUpState state,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is ErrorSignUpState) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                AppLocalizations.of(context)?.dialog_wrong_signUp_title ?? " "),
            content: Text(state.error.code),
            actions: [
              TextButton(
                  onPressed: () => context.router.pop(),
                  child: Text(AppLocalizations.of(context)?.action_ok ?? " ")),
            ],
          ),
        );
      }
    });
  }
}
