import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/event.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/block.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/user.dart';
import '../../presentation/pages/Amministratore/EntityPage/event_page.dart';
import '../../presentation/pages/Amministratore/EntityPage/location_page.dart';
import '../../presentation/pages/Amministratore/InfoPages/event_info_page.dart';
import '../../presentation/pages/Amministratore/InfoPages/location_info_page.dart';
import '../../presentation/pages/Amministratore/InfoPages/ticket_info_page.dart';
import '../../presentation/pages/Amministratore/home_amministratore.dart';
import '../../presentation/pages/Utente/profile_page_utente.dart';
import '../../presentation/pages/guest/anonymous_home_page.dart';
import '../../presentation/pages/guest/event_page.dart';
import '../../presentation/pages/guest/location_page.dart';
import '../../presentation/pages/Operatore/home_operatore.dart';
import '../../presentation/pages/Profile/profile_page.dart';
import '../../presentation/pages/Utente/EntityPage/event_customer_page.dart';
import '../../presentation/pages/Utente/EntityPage/location_customer_page.dart';
import '../../presentation/pages/Utente/home_utente.dart';
import '../../presentation/pages/Operatore/qr_widget.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/sign_up_page.dart';
import '../../presentation/pages/welcome_page.dart';
import '../../presentation/pages/Utente/PaymentPages/payment_page.dart';

part 'app_router.gr.dart';

///flutter packages pub run build_runner watch

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [

        AutoRoute(page: MainRoute.page, initial: true),
        AutoRoute(page: AnonymusHomeRoute.page,),
        AutoRoute(page: HomeRouteOperator.page),
        AutoRoute(page: HomeRouteAdmin.page),
        AutoRoute(page: HomeRouteUser.page),

        AutoRoute(page: EventInfoAdminRoute.page),
        AutoRoute(page: LocationInfoAdminRoute.page),
        AutoRoute(page: TicketInfoAdminRoute.page),
        AutoRoute(page: EventInfoRoute.page),
        AutoRoute(page: LocationInfoRoute.page),

        AutoRoute(page: EventRoute.page),
        AutoRoute(page: LocationRoute.page),

        AutoRoute(page: EventInfoCustomerRoute.page),
        AutoRoute(page: LocationInfoCustomerRoute.page),
        AutoRoute(page: PaymentRoute.page),

        AutoRoute(page:QRViewRoute.page),

        AutoRoute(page: LoginRouteConnection.page,),
        AutoRoute(page: SignUpRoute.page,),
        AutoRoute(page: ProfileRoute.page,),
        AutoRoute(page: ProfileRouteUtente.page,),
        AutoRoute(page: WelcomeRoute.page,),

      ];
}
