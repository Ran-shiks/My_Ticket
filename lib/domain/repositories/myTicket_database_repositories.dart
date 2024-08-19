import '../entities/block.dart';
import '../entities/event.dart';
import '../entities/location.dart';
import '../entities/ticket.dart';
import '../entities/user.dart';

abstract class UserDatabaseRepository {
  Future<void> createUser(User u);
  Future<void> deleteUser(User u);
  Future<void> updateUser(User u);
  Future<void> updateFieldUser(String idUser, String field, String data, bool add);
  Future<void> updateBalanceUser(String idUser, double value);
  Future<List<User>> searchUserByEmail(String email);

  Stream<List<User>> streamOfUser();
  Future<List<User>> listOfUser();

  Future<User?> searchUserById(String id);
  Stream<User?> changeUser(String u);
}

abstract class EventDatabaseRepository {
  Future<String> createEvent(Event e);
  Future<void> deleteEvent(Event e);
  Future<void> updateEvent(Event e);
  Future<void> updateFieldEvent(String idEvent, String field, Object data, bool add);
  Future<void> incrementFavEvent(String idEvent);
  Future<void> decrementFavEvent(String idEvent);


  Future<List<Event>> listOfEvent();
  Stream<List<Event>> streamOfEvent();
  Stream<List<Event>> streamOfEventFilteredisGreaterThanOrEqualTo(field, value);
  Stream<List<Event>> searchEventFilteredByOperator(String idUser);

  Future<List<Event>> searchEventByName(String u);
  Future<Event?> searchEventById(String u);
}

abstract class LocationDatabaseRepository {
  //admin
  Future<void> createLocation(
    Location p,
  );
  Future<void> deleteLocation(Location p);
  Future<void> updateLocation(Location p);

  Stream<List<Location>> streamOfLocation();
  Future<List<Location>> listOfLocation();

  //all
  Future<List<Location>> searchLocationByName(String name);
  Future<Location?> searchLocationById(String id);
}

abstract class BlockDatabaseRepository {
  Future<String> createBlock(Block b);
  Future<void> deleteBlock(Block b);
  Future<void> deleteBlockById(String id);
  Future<void> updateBlock(Block b);

  Future<List<Block>> listOfBlocks();
  Stream<List<Block>> streamOfBlock();

  Future<Block?> searchBlockById(String id);
}

abstract class TicketDatabaseRepository {
  Future<String> createTicket(Ticket s);
  Future<void> deleteTicket(Ticket s);
  Future<void> updateTicket(Ticket s);
  Future<void> updateFieldTicket(String idTicket, String field, Object data);

  Future<List<Ticket>> listOfTickets();
  Stream<List<Ticket>> streamOfTicket();

  Future<Ticket?> searchTicketById(String id);
  Future<void> deleteTicketById(String id);
}
