import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/domain/use_cases/administrator_usecases.dart';
import 'package:my_ticket/presentation/widgets/connectivity_widget.dart';

import '../../../domain/entities/user.dart';
import '../../manager/cubits/new_auth/auth_cubit.dart';
import '../../widgets/operator_widget/stream_event_list_operator.dart';

@RoutePage()
class HomePageOperator extends ConnectivityWidget {
  final User user;

  const HomePageOperator({Key? key, required this.user}) : super(key: key);

  @override
  Widget connectedBuild(BuildContext context) {
    var admin = context.read<AdminInteractor>();
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        
        title: Row(
          children: [
            Text(AppLocalizations
                .of(context)
                ?.app_name ?? " ", style: TextStyle(color: selected),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Operator"),
            )
          ],
        ),
        actions: [
          _signOutButton(context),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          child: StreamEventListOperator(admin)
      ),




    );
  }

  Widget _signOutButton(BuildContext context, {bool enabled = true}) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: background,foregroundColor: selected),
          onPressed: enabled ? () => context.read<AuthCubit>().signOut() : null,
          child: const Text("SignOut"),
        ),
      );
}