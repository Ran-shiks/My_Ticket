part of 'home_utente.dart';

class BodyMyTickets extends StatefulWidget {
  const BodyMyTickets({super.key});

  @override
  State<BodyMyTickets> createState() => _BodyMyTicketsState();
}

class _BodyMyTicketsState extends State<BodyMyTickets> {
  late int _Index;

  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();
    return StreamBuilder<User?>(
        stream: common.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Errore nel caricamento dei dati'));
          } else {
            final futureUser = snapshot.data!;
            return ListView(
              shrinkWrap: true,
              children: [
                Divider(height: 10,),

                if (futureUser.ticketBought.isNotEmpty)Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 300,
                  child: FutureTicketList(context),
                ),

                if (futureUser.ticketBought.isNotEmpty)const Divider(
                  height: 10,
                ),
                if (futureUser.eventsFavorite.isNotEmpty)Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 300,
                  child: FutureEventList(context),
                ),

              ],
            );
          }
        }
    );
  }
}
