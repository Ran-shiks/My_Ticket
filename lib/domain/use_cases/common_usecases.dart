import 'package:my_ticket/domain/entities/event.dart';
import '../../data/repositories/authentication_repositories.dart';
import '../entities/block.dart';
import '../entities/location.dart';
import '../entities/ticket.dart';
import '../entities/user.dart';
import '../repositories/myTicket_database_repositories.dart';

class CommonInteractor {
  final EventDatabaseRepository eventDatabaseRepository;
  final LocationDatabaseRepository locationDatabaseRepository;
  final TicketDatabaseRepository ticketDatabaseRepository;
  final BlockDatabaseRepository blockDatabaseRepository;
  final UserDatabaseRepository userDatabaseRepository;
  final AuthenticationRepositories authenticationRepositories;

  CommonInteractor(
      {required this.eventDatabaseRepository,
      required this.locationDatabaseRepository,
      required this.ticketDatabaseRepository,
      required this.blockDatabaseRepository,
      required this.userDatabaseRepository,
      required this.authenticationRepositories});


  Future<Ticket?> searchTicketById(String id) {
    return ticketDatabaseRepository.searchTicketById(id);
  }

  Future<Block?> searchBlockById(String id) {
    return blockDatabaseRepository.searchBlockById(id);
  }

  Future<Location?> searchLocationById(String id) {
    return locationDatabaseRepository.searchLocationById(id);
  }

  Future<Event?> searchEventById(String id) {
    return eventDatabaseRepository.searchEventById(id);
  }

  Future<List<Event>> searchEventByName(String name) {
    return eventDatabaseRepository.searchEventByName(name);
  }

  Stream<List<Event>> streamOfEvents() async* {
    yield* eventDatabaseRepository.streamOfEvent();
  }

  Stream<List<Event>> streamOfEventFilteredisGreaterThanOrEqualTo(field, value) async* {
    yield* eventDatabaseRepository.streamOfEventFilteredisGreaterThanOrEqualTo(field, value);
  }

  Future<Block?> searchBlock(String id) {
    return blockDatabaseRepository.searchBlockById(id);
  }

  Future<List<Block>> listOfBlock() {
    return blockDatabaseRepository.listOfBlocks();
  }

  Future<User?> infoUser(String id) {
    return userDatabaseRepository.searchUserById(id);
  }

  Future<List<User>> searchUserByEmail(String email) {
    return userDatabaseRepository.searchUserByEmail(email);
  }

  Stream<User?> streamUser() {
    var idUser = authenticationRepositories.fetchIdCurrentUser();
    return userDatabaseRepository.changeUser(idUser!);
  }

  Future<List<Ticket>> retriveUserTicket (List<String> tickets) async {
    List<Ticket> ticketsRetrived = [];

    for (var element in tickets) {
      await ticketDatabaseRepository.searchTicketById(element).then((value) => ticketsRetrived.add(value!));
    }
    return ticketsRetrived;
  }

  Future<List<Event>> retriveUserEvent (List<String> event) async {
    List<Event> eventRetrived = [];

    for (var element in  event) {
      await eventDatabaseRepository.searchEventById(element).then((value) => eventRetrived.add(value!));
    }
    return eventRetrived;
  }

  void incrementFavourite(String event){
    eventDatabaseRepository.incrementFavEvent(event);
  }

  void decrementFavourite(String event){
    eventDatabaseRepository.decrementFavEvent(event);
  }

  void addEventInFavourite(String idEvent) async {
    var idUser = authenticationRepositories.fetchIdCurrentUser();
    await userDatabaseRepository.updateFieldUser(idUser!,"eventsFavorite", idEvent, true);
  }

  void deleteEventFromFavourite(String idEvent) async {
    var idUser = authenticationRepositories.fetchIdCurrentUser();
    await userDatabaseRepository.updateFieldUser(idUser!,"eventsFavorite", idEvent, false);
  }


  void buyTicket(Event event, String seat, String block, String location,  double cost, String? idU) {
    var idUser = authenticationRepositories.fetchIdCurrentUser();
    if (idUser != null) {
    var ticket = Ticket(event: event.id!, seat: seat, block: block, location:location, cost: cost,used: false, isOccupied: true, user: idU ?? idUser);

    ticketDatabaseRepository.createTicket(ticket).then((value) {
      userDatabaseRepository.updateFieldUser(idU ?? idUser, "ticketBought", value, true);
      event.tickets.addAll({value : seat});

      eventDatabaseRepository.updateEvent(event);
    });
    }
  }


  Future<bool> buyTicketWithBalance(Event event, String seat, String block, String location,  double cost, String? idU) async {

    var idUser = authenticationRepositories.fetchIdCurrentUser()!;


    var user = await userDatabaseRepository.searchUserById(idUser);

    if( user != null && user.balance < cost) {
      var ticket = Ticket(event: event.id!, seat: seat, block: block, location:location, cost: cost,used: false, isOccupied: true, user: idU ?? idUser);

      userDatabaseRepository.updateBalanceUser(idUser, -cost);
      ticketDatabaseRepository.createTicket(ticket).then((value) {
        userDatabaseRepository.updateFieldUser(idU ?? idUser, "ticketBought", value, true);
        event.tickets.addAll({value : seat});

        eventDatabaseRepository.updateEvent(event);
      });
      return true;
    }
    return false;
  }

  void CancelTicket(Ticket ticket) {
    var idUser = authenticationRepositories.fetchIdCurrentUser();
    userDatabaseRepository.updateBalanceUser(idUser!, ticket.cost);

    ticketDatabaseRepository.deleteTicket(ticket).then((value) async {
      userDatabaseRepository.updateFieldUser(idUser, "ticketBought", ticket.id!, false);
      await eventDatabaseRepository.searchEventById(ticket.event).then((event) {
        event!.tickets.remove(ticket.id);
        eventDatabaseRepository.updateEvent(event);
      });
    });
  }

}
