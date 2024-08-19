import 'package:my_ticket/domain/entities/block.dart';
import 'package:my_ticket/domain/entities/event.dart';

import '../entities/location.dart';
import '../entities/ticket.dart';
import '../entities/user.dart';
import '../repositories/myTicket_authentication_repositories.dart';
import '../repositories/myTicket_database_repositories.dart';

class AdminInteractor {
  final EventDatabaseRepository eventdatabaserepository;
  final LocationDatabaseRepository locationdatabaserepository;
  final TicketDatabaseRepository ticketDatabaseRepository;
  final BlockDatabaseRepository blockdatabaserepository;
  final UserDatabaseRepository userdatabaserepository;
  final MyTicketAuthenticationRepositories myTicketAuthenticationRepositories;

  AdminInteractor(
      {required this.eventdatabaserepository,
      required this.locationdatabaserepository,
      required this.ticketDatabaseRepository,
      required this.blockdatabaserepository,
      required this.userdatabaserepository,
      required this.myTicketAuthenticationRepositories});

  //--------------------------------------------------------------------------
  // Creazione Users
  //--------------------------------------------------------------------------
  void createUser(User u) {
    userdatabaserepository.createUser(u);
  }
  Future<User?> searchUser(User user) {
    return userdatabaserepository.searchUserById(user.uid);
  }
  void deleteUser(User u) {
    userdatabaserepository.deleteUser(u);
  }

  Stream<List<User>> streamOfUser() async* {
    yield* userdatabaserepository.streamOfUser();
  }
  Future<List<User>> listOfUser() async {
    return userdatabaserepository.listOfUser();
  }
  void updateUser(User u) {
    userdatabaserepository.updateUser(u);
  }

  // Funzione usata per cambiare il ruolo degli utenti
  void updateRole(User user, int newRole) {
    var newUser = User(
        uid: user.uid,
        name: user.name,
        surname: user.surname,
        balance: user.balance,
        email: user.email,
        imageUrl: user.imageUrl,
        role: Role.values[newRole]);
    userdatabaserepository.updateUser(newUser);
  }
  //--------------------------------------------------------------------------
  // Fine Sezione Creazione Users
  //--------------------------------------------------------------------------



  //--------------------------------------------------------------------------
  // Creazione Location e Blocchi associati
  //--------------------------------------------------------------------------
  Future<void> createLocation(Location p, List<Block> blocks) async {
    var Ids = await createBlocks(blocks);

    p.blocks.addAll(Ids);

    locationdatabaserepository.createLocation(p);
  }

  Future<List<String>> createBlocks (List<Block> blocks) async {
    List<String> blockId = [];

    for (var block in blocks){
      var id = await blockdatabaserepository.createBlock(block);
      blockId.add(id);
    }

    return blockId;
  }
  Future<List<Location>> listOfLocation() async {
    return locationdatabaserepository.listOfLocation();
  }
  Stream<List<Location>> streamOfLocation() async* {
    yield* locationdatabaserepository.streamOfLocation();
  }

  Stream<List<Event>> streamOfLocationForOperator() async* {
    String idUser = myTicketAuthenticationRepositories.fetchIdCurrentUser()!;
    yield* eventdatabaserepository.searchEventFilteredByOperator(idUser);
  }

  void deleteLocation(Location p) {
    locationdatabaserepository.deleteLocation(p);

    for (var element in p.blocks){
      deleteBlock(element);
    }
  }
  void deleteBlock(String id){
    blockdatabaserepository.deleteBlockById(id);
  }

  Future<List<Location>> searchLocation(String name) {
    return locationdatabaserepository.searchLocationByName(name);
  }
  Future<Block?> searchBlockById(String id){
    return blockdatabaserepository.searchBlockById(id);
  }

  Future<Location?> searchLocationById (String id){
    return locationdatabaserepository.searchLocationById(id);
  }

  void updateLocation(Location p) {
    locationdatabaserepository.updateLocation(p);
  }
  //--------------------------------------------------------------------------
  // Fine sezione Creazione Location e Blocchi associati
  //--------------------------------------------------------------------------





  //--------------------------------------------------------------------------
  // Creazione Event
  //--------------------------------------------------------------------------
  Future<List<Event>> searchEventByName(String name) {
    return eventdatabaserepository.searchEventByName(name);
  }

  Future<String> createEvent(Event e) {
    return eventdatabaserepository.createEvent(e);
  }

  void deleteEvent(Event e) {
    RefoundEventDeteted(e);

    eventdatabaserepository.deleteEvent(e);
  }

  void updateEvent(Event e) {
    eventdatabaserepository.updateEvent(e);
  }

  void RefoundEventDeteted(Event event) {
    event.tickets.forEach((seat, idTicket) {
      ticketDatabaseRepository.searchTicketById(idTicket).then((ticket) {
        userdatabaserepository.searchUserById(ticket!.user!).then((user) {

          userdatabaserepository.updateBalanceUser(user!.uid, ticket.cost);
          return userdatabaserepository.updateFieldUser(user.uid, 'ticketBought', ticket.id!, false);
        });
        ticketDatabaseRepository.deleteTicket(ticket);
        eventdatabaserepository.updateFieldEvent(event.id!, 'tickets', {seat : idTicket}, false);
      });
    });
  }

  //--------------------------------------------------------------------------
  // Fine Sezione Creazione Eventi
  //--------------------------------------------------------------------------




  //--------------------------------------------------------------------------
  // Creazione Ticket
  //--------------------------------------------------------------------------
  Future<String> _createTicket(Ticket ticket){
   return ticketDatabaseRepository.createTicket(ticket);
  }

  Future<bool> checkTicket(String idTicket) async {
    if (await ticketDatabaseRepository.searchTicketById(idTicket)!= null){
      await ticketDatabaseRepository.updateFieldTicket(idTicket, "used", true);
      return true;
    }
    return false;

  }

  void updateFieldTicket(String idTicket, String field, String data) {
    ticketDatabaseRepository.updateFieldTicket(idTicket, field, data);
  }

  //--------------------------------------------------------------------------
  // Fine Sezione Creazione Ticket
  //--------------------------------------------------------------------------

}