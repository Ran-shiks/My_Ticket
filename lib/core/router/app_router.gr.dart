// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AnonymusHomeRoute.name: (routeData) {
      final args = routeData.argsAs<AnonymusHomeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AnonymusHomePage(
          key: args.key,
          anonym: args.anonym,
        ),
      );
    },
    EventInfoAdminRoute.name: (routeData) {
      final args = routeData.argsAs<EventInfoAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventInfoAdminPage(
          key: args.key,
          event: args.event,
        ),
      );
    },
    EventInfoCustomerRoute.name: (routeData) {
      final args = routeData.argsAs<EventInfoCustomerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventInfoCustomerPage(
          key: args.key,
          event: args.event,
        ),
      );
    },
    EventInfoRoute.name: (routeData) {
      final args = routeData.argsAs<EventInfoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventInfoPage(
          key: args.key,
          event: args.event,
        ),
      );
    },
    EventRoute.name: (routeData) {
      final args = routeData.argsAs<EventRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventPage(
          key: args.key,
          event: args.event,
        ),
      );
    },
    HomeRouteAdmin.name: (routeData) {
      final args = routeData.argsAs<HomeRouteAdminArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePageAdmin(user: args.user),
      );
    },
    HomeRouteOperator.name: (routeData) {
      final args = routeData.argsAs<HomeRouteOperatorArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePageOperator(
          key: args.key,
          user: args.user,
        ),
      );
    },
    HomeRouteUser.name: (routeData) {
      final args = routeData.argsAs<HomeRouteUserArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePageUser(
          key: args.key,
          user: args.user,
        ),
      );
    },
    LocationInfoAdminRoute.name: (routeData) {
      final args = routeData.argsAs<LocationInfoAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationInfoAdminPage(
          key: args.key,
          location: args.location,
        ),
      );
    },
    LocationInfoCustomerRoute.name: (routeData) {
      final args = routeData.argsAs<LocationInfoCustomerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationInfoCustomerPage(
          key: args.key,
          location: args.location,
        ),
      );
    },
    LocationInfoRoute.name: (routeData) {
      final args = routeData.argsAs<LocationInfoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationInfoPage(
          key: args.key,
          location: args.location,
        ),
      );
    },
    LocationRoute.name: (routeData) {
      final args = routeData.argsAs<LocationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationPage(
          key: args.key,
          location: args.location,
        ),
      );
    },
    LoginRouteConnection.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: LoginPageConnection()),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MainPage(),
      );
    },
    PaymentRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PaymentPage(
          key: args.key,
          location: args.location,
          block: args.block,
          seats: args.seats,
          event: args.event,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    ProfileRouteUtente.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteUtenteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePageUtente(
          key: args.key,
          user: args.user,
        ),
      );
    },
    QRViewRoute.name: (routeData) {
      final args = routeData.argsAs<QRViewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QRViewPage(
          key: args.key,
          event: args.event,
        ),
      );
    },
    SignUpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: SignUpPage()),
      );
    },
    TicketInfoAdminRoute.name: (routeData) {
      final args = routeData.argsAs<TicketInfoAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TicketInfoAdminPage(
          key: args.key,
          ticket: args.ticket,
        ),
      );
    },
    WelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomePage(),
      );
    },
  };
}

/// generated route for
/// [AnonymusHomePage]
class AnonymusHomeRoute extends PageRouteInfo<AnonymusHomeRouteArgs> {
  AnonymusHomeRoute({
    Key? key,
    required User anonym,
    List<PageRouteInfo>? children,
  }) : super(
          AnonymusHomeRoute.name,
          args: AnonymusHomeRouteArgs(
            key: key,
            anonym: anonym,
          ),
          initialChildren: children,
        );

  static const String name = 'AnonymusHomeRoute';

  static const PageInfo<AnonymusHomeRouteArgs> page =
      PageInfo<AnonymusHomeRouteArgs>(name);
}

class AnonymusHomeRouteArgs {
  const AnonymusHomeRouteArgs({
    this.key,
    required this.anonym,
  });

  final Key? key;

  final User anonym;

  @override
  String toString() {
    return 'AnonymusHomeRouteArgs{key: $key, anonym: $anonym}';
  }
}

/// generated route for
/// [EventInfoAdminPage]
class EventInfoAdminRoute extends PageRouteInfo<EventInfoAdminRouteArgs> {
  EventInfoAdminRoute({
    Key? key,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          EventInfoAdminRoute.name,
          args: EventInfoAdminRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventInfoAdminRoute';

  static const PageInfo<EventInfoAdminRouteArgs> page =
      PageInfo<EventInfoAdminRouteArgs>(name);
}

class EventInfoAdminRouteArgs {
  const EventInfoAdminRouteArgs({
    this.key,
    required this.event,
  });

  final Key? key;

  final Event event;

  @override
  String toString() {
    return 'EventInfoAdminRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [EventInfoCustomerPage]
class EventInfoCustomerRoute extends PageRouteInfo<EventInfoCustomerRouteArgs> {
  EventInfoCustomerRoute({
    Key? key,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          EventInfoCustomerRoute.name,
          args: EventInfoCustomerRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventInfoCustomerRoute';

  static const PageInfo<EventInfoCustomerRouteArgs> page =
      PageInfo<EventInfoCustomerRouteArgs>(name);
}

class EventInfoCustomerRouteArgs {
  const EventInfoCustomerRouteArgs({
    this.key,
    required this.event,
  });

  final Key? key;

  final Event event;

  @override
  String toString() {
    return 'EventInfoCustomerRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [EventInfoPage]
class EventInfoRoute extends PageRouteInfo<EventInfoRouteArgs> {
  EventInfoRoute({
    Key? key,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          EventInfoRoute.name,
          args: EventInfoRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventInfoRoute';

  static const PageInfo<EventInfoRouteArgs> page =
      PageInfo<EventInfoRouteArgs>(name);
}

class EventInfoRouteArgs {
  const EventInfoRouteArgs({
    this.key,
    required this.event,
  });

  final Key? key;

  final Event event;

  @override
  String toString() {
    return 'EventInfoRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [EventPage]
class EventRoute extends PageRouteInfo<EventRouteArgs> {
  EventRoute({
    Key? key,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          EventRoute.name,
          args: EventRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventRoute';

  static const PageInfo<EventRouteArgs> page = PageInfo<EventRouteArgs>(name);
}

class EventRouteArgs {
  const EventRouteArgs({
    this.key,
    required this.event,
  });

  final Key? key;

  final Event event;

  @override
  String toString() {
    return 'EventRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [HomePageAdmin]
class HomeRouteAdmin extends PageRouteInfo<HomeRouteAdminArgs> {
  HomeRouteAdmin({
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRouteAdmin.name,
          args: HomeRouteAdminArgs(user: user),
          initialChildren: children,
        );

  static const String name = 'HomeRouteAdmin';

  static const PageInfo<HomeRouteAdminArgs> page =
      PageInfo<HomeRouteAdminArgs>(name);
}

class HomeRouteAdminArgs {
  const HomeRouteAdminArgs({required this.user});

  final User user;

  @override
  String toString() {
    return 'HomeRouteAdminArgs{user: $user}';
  }
}

/// generated route for
/// [HomePageOperator]
class HomeRouteOperator extends PageRouteInfo<HomeRouteOperatorArgs> {
  HomeRouteOperator({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRouteOperator.name,
          args: HomeRouteOperatorArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRouteOperator';

  static const PageInfo<HomeRouteOperatorArgs> page =
      PageInfo<HomeRouteOperatorArgs>(name);
}

class HomeRouteOperatorArgs {
  const HomeRouteOperatorArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'HomeRouteOperatorArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [HomePageUser]
class HomeRouteUser extends PageRouteInfo<HomeRouteUserArgs> {
  HomeRouteUser({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRouteUser.name,
          args: HomeRouteUserArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRouteUser';

  static const PageInfo<HomeRouteUserArgs> page =
      PageInfo<HomeRouteUserArgs>(name);
}

class HomeRouteUserArgs {
  const HomeRouteUserArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'HomeRouteUserArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [LocationInfoAdminPage]
class LocationInfoAdminRoute extends PageRouteInfo<LocationInfoAdminRouteArgs> {
  LocationInfoAdminRoute({
    Key? key,
    required Location location,
    List<PageRouteInfo>? children,
  }) : super(
          LocationInfoAdminRoute.name,
          args: LocationInfoAdminRouteArgs(
            key: key,
            location: location,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationInfoAdminRoute';

  static const PageInfo<LocationInfoAdminRouteArgs> page =
      PageInfo<LocationInfoAdminRouteArgs>(name);
}

class LocationInfoAdminRouteArgs {
  const LocationInfoAdminRouteArgs({
    this.key,
    required this.location,
  });

  final Key? key;

  final Location location;

  @override
  String toString() {
    return 'LocationInfoAdminRouteArgs{key: $key, location: $location}';
  }
}

/// generated route for
/// [LocationInfoCustomerPage]
class LocationInfoCustomerRoute
    extends PageRouteInfo<LocationInfoCustomerRouteArgs> {
  LocationInfoCustomerRoute({
    Key? key,
    required Location location,
    List<PageRouteInfo>? children,
  }) : super(
          LocationInfoCustomerRoute.name,
          args: LocationInfoCustomerRouteArgs(
            key: key,
            location: location,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationInfoCustomerRoute';

  static const PageInfo<LocationInfoCustomerRouteArgs> page =
      PageInfo<LocationInfoCustomerRouteArgs>(name);
}

class LocationInfoCustomerRouteArgs {
  const LocationInfoCustomerRouteArgs({
    this.key,
    required this.location,
  });

  final Key? key;

  final Location location;

  @override
  String toString() {
    return 'LocationInfoCustomerRouteArgs{key: $key, location: $location}';
  }
}

/// generated route for
/// [LocationInfoPage]
class LocationInfoRoute extends PageRouteInfo<LocationInfoRouteArgs> {
  LocationInfoRoute({
    Key? key,
    required Location location,
    List<PageRouteInfo>? children,
  }) : super(
          LocationInfoRoute.name,
          args: LocationInfoRouteArgs(
            key: key,
            location: location,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationInfoRoute';

  static const PageInfo<LocationInfoRouteArgs> page =
      PageInfo<LocationInfoRouteArgs>(name);
}

class LocationInfoRouteArgs {
  const LocationInfoRouteArgs({
    this.key,
    required this.location,
  });

  final Key? key;

  final Location location;

  @override
  String toString() {
    return 'LocationInfoRouteArgs{key: $key, location: $location}';
  }
}

/// generated route for
/// [LocationPage]
class LocationRoute extends PageRouteInfo<LocationRouteArgs> {
  LocationRoute({
    Key? key,
    required Location location,
    List<PageRouteInfo>? children,
  }) : super(
          LocationRoute.name,
          args: LocationRouteArgs(
            key: key,
            location: location,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationRoute';

  static const PageInfo<LocationRouteArgs> page =
      PageInfo<LocationRouteArgs>(name);
}

class LocationRouteArgs {
  const LocationRouteArgs({
    this.key,
    required this.location,
  });

  final Key? key;

  final Location location;

  @override
  String toString() {
    return 'LocationRouteArgs{key: $key, location: $location}';
  }
}

/// generated route for
/// [LoginPageConnection]
class LoginRouteConnection extends PageRouteInfo<void> {
  const LoginRouteConnection({List<PageRouteInfo>? children})
      : super(
          LoginRouteConnection.name,
          initialChildren: children,
        );

  static const String name = 'LoginRouteConnection';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PaymentPage]
class PaymentRoute extends PageRouteInfo<PaymentRouteArgs> {
  PaymentRoute({
    Key? key,
    required Location location,
    required Block block,
    required List<String> seats,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentRoute.name,
          args: PaymentRouteArgs(
            key: key,
            location: location,
            block: block,
            seats: seats,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentRoute';

  static const PageInfo<PaymentRouteArgs> page =
      PageInfo<PaymentRouteArgs>(name);
}

class PaymentRouteArgs {
  const PaymentRouteArgs({
    this.key,
    required this.location,
    required this.block,
    required this.seats,
    required this.event,
  });

  final Key? key;

  final Location location;

  final Block block;

  final List<String> seats;

  final Event event;

  @override
  String toString() {
    return 'PaymentRouteArgs{key: $key, location: $location, block: $block, seats: $seats, event: $event}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [ProfilePageUtente]
class ProfileRouteUtente extends PageRouteInfo<ProfileRouteUtenteArgs> {
  ProfileRouteUtente({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRouteUtente.name,
          args: ProfileRouteUtenteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRouteUtente';

  static const PageInfo<ProfileRouteUtenteArgs> page =
      PageInfo<ProfileRouteUtenteArgs>(name);
}

class ProfileRouteUtenteArgs {
  const ProfileRouteUtenteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'ProfileRouteUtenteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [QRViewPage]
class QRViewRoute extends PageRouteInfo<QRViewRouteArgs> {
  QRViewRoute({
    Key? key,
    required Event event,
    List<PageRouteInfo>? children,
  }) : super(
          QRViewRoute.name,
          args: QRViewRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'QRViewRoute';

  static const PageInfo<QRViewRouteArgs> page = PageInfo<QRViewRouteArgs>(name);
}

class QRViewRouteArgs {
  const QRViewRouteArgs({
    this.key,
    required this.event,
  });

  final Key? key;

  final Event event;

  @override
  String toString() {
    return 'QRViewRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TicketInfoAdminPage]
class TicketInfoAdminRoute extends PageRouteInfo<TicketInfoAdminRouteArgs> {
  TicketInfoAdminRoute({
    Key? key,
    required Ticket ticket,
    List<PageRouteInfo>? children,
  }) : super(
          TicketInfoAdminRoute.name,
          args: TicketInfoAdminRouteArgs(
            key: key,
            ticket: ticket,
          ),
          initialChildren: children,
        );

  static const String name = 'TicketInfoAdminRoute';

  static const PageInfo<TicketInfoAdminRouteArgs> page =
      PageInfo<TicketInfoAdminRouteArgs>(name);
}

class TicketInfoAdminRouteArgs {
  const TicketInfoAdminRouteArgs({
    this.key,
    required this.ticket,
  });

  final Key? key;

  final Ticket ticket;

  @override
  String toString() {
    return 'TicketInfoAdminRouteArgs{key: $key, ticket: $ticket}';
  }
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
