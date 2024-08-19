import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';
import 'package:my_ticket/presentation/manager/blocs/sign_in/sign_in_bloc.dart';
import 'package:my_ticket/presentation/widgets/connectivity_widget.dart';

@RoutePage()
class LoginPageConnection extends ConnectivityWidget
    implements AutoRouteWrapper {
  @override
  Widget connectedBuild(_) => BlocConsumer<SignInBloc, SignInState>(
      builder: (context, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: background,
              shadowColor: selected,
              title: Center(child: Text(AppLocalizations.of(context)?.title_sign_in ?? " ")),
              automaticallyImplyLeading: false,
            ),
            body: Container(
              color: background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 30),
                    child: Expanded(
                        child: FittedBox(fit: BoxFit.fill,
                          child: Transform.rotate(angle: 35,
                            child: const FaIcon(FontAwesomeIcons.ticketAlt, color: selected),),)),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: secondary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        _emailField(context, enabled: state is! SigningInState),
                        _passwordField(context, enabled: state is! SigningInState),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _signInButton(context, enabled: state is! SigningInState),
                  ),
                  if (state is SigningInState) _orDivider(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _googleLoginButton(context, enabled: state is! SigningInState),
                  ),
                  const Divider(),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _signUpButton(context, enabled: state is! SigningInState),
                        _anonymusHomeButton(context),
                      ],
                    ),
                  ),
                  if (state is SigningInState) _progress(),
                ],
              ),
            ),
          ),
      listener: (context, state) {
        _shouldCloseForSignedIn(context, state: state);
        _shouldShowErrorSignInDialog(context, state: state);
      });

  Widget _progress() => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );

  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignInBloc>().emailbinding,
        builder: (context, controller, data, onChanged, error) => TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            fillColor: secondary,
            errorText: error?.localizedString(context),
            hintText: AppLocalizations.of(context)?.label_email,
          ),
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignInBloc>().passwordBinding,
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

  Widget _signInButton(BuildContext context, {bool enabled = true}) {
    Widget _signInButtonEnabled(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignInBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );

    return _signInButtonEnabled(context,
        function: (enabled) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: selected,
            disabledBackgroundColor: secondary,
            disabledForegroundColor: background,
          ),
            onPressed: enabled
                ? () => context.read<SignInBloc>().performSignIn()
                : null,
            child: Text(AppLocalizations.of(context)?.action_login ?? " ")));
  }

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
                  context.read<SignInBloc>().performSignInWithGoogle(),
            )
          : Container();

  Widget _signUpButton(BuildContext context, {bool enabled = true}) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: selected,
          shadowColor: selected,
        ),
        onPressed: enabled ? () => context.router.replace(const SignUpRoute()) : null,
        child: Text(AppLocalizations.of(context)?.action_sign_up ?? " "),
      );

  Widget _anonymusHomeButton(BuildContext context,) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: selected,
          shadowColor: selected,
        ),
        onPressed: () async {
          await context.read<AuthInteractor>().loginAnonymus()
              .then((value) => context.router.replace(AnonymusHomeRoute(anonym: value)));

        },
        child: const Text("Go anonymus"),
      );

  /// Importante per autoroute
  @override
  Widget wrappedRoute(BuildContext context, {bool enabled = true}) =>
      BlocProvider(
        create: (context) => SignInBloc(
          authInteractor: context.read<AuthInteractor>(),
        ),
        child: this,
      );

  ///-----------

  ///Se il login è completato con successo, navigheremo fino alla home
  void _shouldCloseForSignedIn(
    BuildContext context, {
    required SignInState state,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is SuccessSignInstate) {
        context.router.popUntilRoot();
      }
    });
  }

  ///Per visualizzare il Dialog in caso di errore
  void _shouldShowErrorSignInDialog(
    BuildContext context, {
    required SignInState state,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is ErrorSignInState) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                AppLocalizations.of(context)?.dialog_wrong_login_title ??
                    " "),
            content: Text(
                AppLocalizations.of(context)?.dialog_wrong_login_message ??
                    " "),
            actions: [
              TextButton(
                  onPressed: () => context.router.pop(),
                  child:
                      Text(AppLocalizations.of(context)?.action_ok ?? " ")),
            ],
          ),
        );
      }
    });
  }
}
